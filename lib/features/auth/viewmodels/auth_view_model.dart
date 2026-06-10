import 'package:flutter/foundation.dart';

import '../../../core/services/auth_service.dart';
import '../models/app_user.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._authService);

  final AuthService _authService;

  AppUser? _currentUser;
  bool _isLoading = false;
  bool _isBootstrapping = true;
  String? _errorMessage;

  AppUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  bool get isBootstrapping => _isBootstrapping;
  String? get errorMessage => _errorMessage;

  Future<void> loadCurrentUser() async {
    _currentUser = await _authService.currentUser();
    _isBootstrapping = false;
    notifyListeners();
  }

  Future<bool> login(String emailOrUsername, String password) async {
    return _runAuthAction(() async {
      _currentUser = await _authService.login(
        emailOrUsername: emailOrUsername,
        password: password,
      );
    });
  }

  Future<bool> signUp(String username, String email, String password) async {
    return _runAuthAction(() async {
      _currentUser = await _authService.signUp(
        username: username,
        email: email,
        password: password,
      );
    });
  }

  Future<bool> verifyEmail(String code) async {
    return _runAuthAction(() async {
      _currentUser = await _authService.verifyEmail(code);
    });
  }

  Future<bool> forgotPassword(String email) async {
    return _runAuthAction(() async {
      final exists = await _authService.forgotPassword(email);
      if (!exists) throw Exception('Ky email nuk u gjet.');
    });
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    return _runAuthAction(() async {
      await _authService.resetPassword(email: email, newPassword: newPassword);
    });
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> _runAuthAction(Future<void> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await action();
      return true;
    } catch (error) {
      _errorMessage = error.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
