import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:proxi_health/models/user_model.dart';
import 'package:proxi_health/services/firestore_service.dart';

class FirebaseAuthService {
  final fb.FirebaseAuth _auth;

  FirebaseAuthService({fb.FirebaseAuth? auth}) : _auth = auth ?? fb.FirebaseAuth.instance;

  bool get isSignedIn => _auth.currentUser != null;
  fb.User? get currentFirebaseUser => _auth.currentUser;
  Stream<fb.User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInWithEmailAndPassword({required String email, required String password}) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final fb.User user = credential.user!;
    final idToken = await user.getIdToken();
    
    // Get user role from Firestore
    final firestoreUser = await FirestoreService.getUser(user.uid);
    
    return User(
      id: user.uid,
      name: user.displayName ?? firestoreUser?.name ?? 'User',
      email: user.email ?? email,
      role: firestoreUser?.role ?? UserRole.patient, // Use role from Firestore
      token: idToken,
    );
  }

  Future<User?> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final fb.User user = credential.user!;
    
    // Update display name
    await user.updateDisplayName(name);
    await user.reload();
    final refreshed = _auth.currentUser!;
    final idToken = await refreshed.getIdToken();
    
    // Create Firestore user document with the selected role
    await FirestoreService.createUserDocumentIfNotExists(
      uid: refreshed.uid,
      email: email,
      role: role,
    );
    
    return User(
      id: refreshed.uid,
      name: refreshed.displayName ?? name,
      email: refreshed.email ?? email,
      role: role,
      token: idToken,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> getCurrentUserToken() async {
    final u = _auth.currentUser;
    if (u == null) return null;
    return u.getIdToken();
  }
}


