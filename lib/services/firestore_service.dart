import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proxi_health/models/user_model.dart';
import 'package:proxi_health/models/health_data_model.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Users Collection
  static const String _usersCollection = 'users';
  static const String _healthDataCollection = 'health_data';

  /// Check if user document exists
  static Future<bool> userDocumentExists(String uid) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(uid).get();
      return doc.exists;
    } catch (e) {
      throw Exception('Failed to check user document existence: $e');
    }
  }

  /// Create user document only if it doesn't exist
  static Future<void> createUserDocumentIfNotExists({
    required String uid,
    required String email,
    required UserRole role,
  }) async {
    try {
      final exists = await userDocumentExists(uid);
      if (!exists) {
        await _firestore.collection(_usersCollection).doc(uid).set({
          'email': email,
          'role': role.toString().split('.').last,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw Exception('Failed to create user document: $e');
    }
  }

  /// Add a new user to Firestore (updated to use UID as document ID)
  static Future<void> addUser({
    required String uid,
    String? name,
    required String email,
    required UserRole role,
  }) async {
    try {
      final userData = <String, dynamic>{
        'email': email,
        'role': role.toString().split('.').last,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      if (name != null) {
        userData['name'] = name;
      }

      await _firestore.collection(_usersCollection).doc(uid).set(userData);
    } catch (e) {
      throw Exception('Failed to add user: $e');
    }
  }

  /// Get user data from Firestore
  static Future<User?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        return User(
          id: uid,
          email: data['email'],
          name: data['name'],
          role: data['role'] == 'doctor' ? UserRole.doctor : UserRole.patient,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  /// Add health data for a user
  static Future<void> addHealthData({
    required String userId,
    required double heartRate,
    required double bloodPressureSystolic,
    required double bloodPressureDiastolic,
    required double temperature,
    required double weight,
    String? notes,
  }) async {
    try {
      await _firestore.collection(_healthDataCollection).add({
        'userId': userId,
        'heartRate': heartRate,
        'bloodPressureSystolic': bloodPressureSystolic,
        'bloodPressureDiastolic': bloodPressureDiastolic,
        'temperature': temperature,
        'weight': weight,
        'notes': notes,
        'timestamp': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add health data: $e');
    }
  }

  /// Get health data for a user
  static Future<List<HealthData>> getHealthData(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_healthDataCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return HealthData(
          heartRate: data['heartRate']?.toDouble(),
          steps: data['steps']?.toInt(),
          calories: data['calories']?.toInt(),
          sleepHours: data['sleepHours']?.toDouble(),
          timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get health data: $e');
    }
  }

  /// Update user profile
  static Future<void> updateUser({
    required String uid,
    String? name,
    String? email,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (name != null) updateData['name'] = name;
      if (email != null) updateData['email'] = email;

      await _firestore.collection(_usersCollection).doc(uid).update(updateData);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  /// Delete health data entry
  static Future<void> deleteHealthData(String healthDataId) async {
    try {
      await _firestore.collection(_healthDataCollection).doc(healthDataId).delete();
    } catch (e) {
      throw Exception('Failed to delete health data: $e');
    }
  }

  /// Get all users (for doctors)
  static Future<List<User>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('role', isEqualTo: 'patient')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return User(
          id: doc.id,
          email: data['email'],
          name: data['name'],
          role: UserRole.patient,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get all users: $e');
    }
  }


}