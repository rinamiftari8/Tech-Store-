import 'package:tech_store/core/services/auth_service.dart';

class AuthViewModel {
  final AuthService authService = AuthService();

  Future<bool> isLoggedIn() {
    return authService.isLoggedIn;
  }

  Future<void> login() {
    return authService.login();
  }

  Future<void> logout() {
    return authService.logout();
  }

  Future<void> saveUser({
    required String fullName,
    required String username,
    required String email,
  }) {
    return authService.saveUser(
      fullName: fullName,
      username: username,
      email: email,
    );
  }

  Future<Map<String, String>> getUserProfile() {
    return authService.getUserProfile();
  }
}

