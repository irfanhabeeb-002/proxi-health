import 'user_model.dart';

class AuthResult {
  final bool success;
  final String? errorMessage;
  final User? user;

  AuthResult({
    required this.success,
    this.errorMessage,
    this.user,
  });

  // Factory constructor for successful authentication
  factory AuthResult.success(User user) {
    return AuthResult(
      success: true,
      user: user,
    );
  }

  // Factory constructor for failed authentication
  factory AuthResult.error(String errorMessage) {
    return AuthResult(
      success: false,
      errorMessage: errorMessage,
    );
  }

  // Helper method to check if the result has an error
  bool get hasError => !success && errorMessage != null;

  // Helper method to get error message or empty string
  String get safeErrorMessage => errorMessage ?? '';
}