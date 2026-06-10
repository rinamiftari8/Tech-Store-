import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/models/app_user.dart';
import '../constants/app_constants.dart';

class AuthService {
  static const _usersKey = 'tech_store_users';
  static const _currentUserEmailKey = 'tech_store_current_user_email';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  List<AppUser> _readUsers() {
    final raw = _prefs.getString(_usersKey);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => AppUser.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveUsers(List<AppUser> users) async {
    final encoded = jsonEncode(users.map((user) => user.toJson()).toList());
    await _prefs.setString(_usersKey, encoded);
  }

  Future<AppUser?> currentUser() async {
    final email = _prefs.getString(_currentUserEmailKey);
    if (email == null) return null;
    final users = _readUsers();
    try {
      return users.firstWhere((user) => user.email == email);
    } catch (_) {
      return null;
    }
  }

  Future<AppUser> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    final users = _readUsers();
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedUsername = username.trim();

    final exists = users.any(
      (user) =>
          user.email == normalizedEmail ||
          user.username.toLowerCase() == normalizedUsername.toLowerCase(),
    );
    if (exists) {
      throw Exception('Ky email ose username ekziston tashmë.');
    }

    final user = AppUser(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      username: normalizedUsername,
      email: normalizedEmail,
      password: password,
      isVerified: false,
      createdAt: DateTime.now(),
    );

    users.add(user);
    await _saveUsers(users);
    await _prefs.setString(_currentUserEmailKey, normalizedEmail);
    return user;
  }

  Future<AppUser> login({
    required String emailOrUsername,
    required String password,
  }) async {
    final users = _readUsers();
    final value = emailOrUsername.trim().toLowerCase();

    try {
      final user = users.firstWhere(
        (item) =>
            (item.email.toLowerCase() == value ||
                item.username.toLowerCase() == value) &&
            item.password == password,
      );
      await _prefs.setString(_currentUserEmailKey, user.email);
      return user;
    } catch (_) {
      throw Exception('Email/username ose password është gabim.');
    }
  }

  Future<AppUser> verifyEmail(String code) async {
    if (code.trim() != AppConstants.verificationCode) {
      throw Exception('Kodi i verifikimit nuk është i saktë.');
    }

    final current = await currentUser();
    if (current == null) {
      throw Exception('Nuk ka përdorues aktiv për verifikim.');
    }

    final users = _readUsers();
    final index = users.indexWhere((user) => user.id == current.id);
    final updated = current.copyWith(isVerified: true);
    users[index] = updated;
    await _saveUsers(users);
    return updated;
  }

  Future<bool> forgotPassword(String email) async {
    final users = _readUsers();
    return users.any((user) => user.email == email.trim().toLowerCase());
  }

  Future<void> resetPassword({required String email, required String newPassword}) async {
    final users = _readUsers();
    final index = users.indexWhere((user) => user.email == email.trim().toLowerCase());
    if (index == -1) {
      throw Exception('Ky email nuk u gjet.');
    }
    users[index] = users[index].copyWith(password: newPassword);
    await _saveUsers(users);
  }

  Future<void> logout() async {
    await _prefs.remove(_currentUserEmailKey);
  }
}
