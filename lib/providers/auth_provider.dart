import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:template_project/models/user_model.dart';
import 'package:template_project/services/firebase_auth_service.dart';
import 'package:template_project/services/secure_storage_service.dart';

enum AuthState { uninitialized, authenticated, authenticating, unauthenticated }

class AuthProvider with ChangeNotifier {
  final FirebaseAuthService _firebaseAuthService;
  final SecureStorageService _storageService;

  AuthProvider(this._firebaseAuthService, this._storageService);

  User? _user;
  User? get user => _user;

  AuthState _authState = AuthState.uninitialized;
  AuthState get authState => _authState;

  Future<void> initAuth() async {
    // Start listening to auth state changes to persist sessions across restarts
    _firebaseAuthService.authStateChanges.listen((fbUser) async {
      if (fbUser != null) {
        final token = await _firebaseAuthService.getCurrentUserToken();
        _user = User(
          id: fbUser.uid,
          name: fbUser.displayName ?? 'User',
          email: fbUser.email ?? '',
          role: UserRole.user,
          token: token,
        );
        if (token != null) {
          await _storageService.saveSession(token, jsonEncode(_user!.toJson()));
        }
        _authState = AuthState.authenticated;
      } else {
        await _storageService.deleteSession();
        _user = null;
        _authState = AuthState.unauthenticated;
      }
      notifyListeners();
    });

    // Kick initial state based on current user synchronously
    if (_firebaseAuthService.isSignedIn) {
      final fbUser = _firebaseAuthService.currentFirebaseUser!;
      final token = await _firebaseAuthService.getCurrentUserToken();
      _user = User(
        id: fbUser.uid,
        name: fbUser.displayName ?? 'User',
        email: fbUser.email ?? '',
        role: UserRole.user,
        token: token,
      );
      if (token != null) {
        await _storageService.saveSession(token, jsonEncode(_user!.toJson()));
      }
      _authState = AuthState.authenticated;
    } else {
      _authState = AuthState.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _authState = AuthState.authenticating;
    notifyListeners();

    try {
      final user = await _firebaseAuthService.signInWithEmailAndPassword(email: email, password: password);
      if (user != null) {
        _user = user;
        await _storageService.saveSession(user.token!, jsonEncode(user.toJson()));
        _authState = AuthState.authenticated;
        notifyListeners();
        return true;
      }
      _authState = AuthState.unauthenticated;
      notifyListeners();
      return false;
    } catch (e) {
      _authState = AuthState.unauthenticated;
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> signup(String name, String email, String password, UserRole role) async {
    _authState = AuthState.authenticating;
    notifyListeners();

    try {
      final user = await _firebaseAuthService.signUpWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      if (user != null) {
        _user = user;
        await _storageService.saveSession(user.token!, jsonEncode(user.toJson()));
        _authState = AuthState.authenticated;
        notifyListeners();
        return true;
      }
      _authState = AuthState.unauthenticated;
      notifyListeners();
      return false;
    } catch (e) {
      _authState = AuthState.unauthenticated;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    await _firebaseAuthService.signOut();
    await _storageService.deleteSession();
    _user = null;
    _authState = AuthState.unauthenticated;
    notifyListeners();
  }
}