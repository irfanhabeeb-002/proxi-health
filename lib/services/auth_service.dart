import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:proxi_health/models/auth_result.dart';
import 'package:proxi_health/models/user_model.dart';
import 'package:proxi_health/services/firestore_service.dart';

class AuthService {
  static final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  /// Main signup method that handles both Firebase Auth and Firestore creation
  static Future<AuthResult> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      // Create Firebase Auth user
      final userCredential = await _createFirebaseUser(email, password);
      final firebaseUser = userCredential.user;
      
      if (firebaseUser == null) {
        return AuthResult.error('Failed to create user account');
      }

      // Create Firestore user document
      await FirestoreService.createUserDocumentIfNotExists(
        uid: firebaseUser.uid,
        email: email,
        role: role,
      );

      // Create User model
      final user = User(
        id: firebaseUser.uid,
        email: email,
        role: role,
      );

      return AuthResult.success(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return AuthResult.error(_formatAuthError(e));
    } catch (e) {
      return AuthResult.error('An unexpected error occurred. Please try again.');
    }
  }

  /// Helper method for Firebase Auth signup
  static Future<firebase_auth.UserCredential> _createFirebaseUser(
    String email, 
    String password,
  ) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Format Firebase Auth errors into user-friendly messages
  static String _formatAuthError(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Password should be at least 6 characters';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      default:
        return 'Signup failed. Please try again';
    }
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validate password strength
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  /// Get current user
  static firebase_auth.User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Sign out current user
  static Future<void> signOut() async {
    await _auth.signOut();
  }
}