import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  Future<void> saveSession(String token, String userJson) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _userKey, value: userJson);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<String?> getUserData() async {
    return await _storage.read(key: _userKey);
  }

  Future<void> deleteSession() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }
}