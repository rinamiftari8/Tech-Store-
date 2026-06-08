import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String loginKey = 'tech_store_logged_in';
  static const String nameKey = 'tech_store_user_name';
  static const String usernameKey = 'tech_store_user_username';
  static const String emailKey = 'tech_store_user_email';

  Future<bool> get isLoggedIn async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(loginKey) ?? false;
  }

  Future<void> login() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(loginKey, true);
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(loginKey);
  }

  Future<void> saveUser({
    required String fullName,
    required String username,
    required String email,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(nameKey, fullName);
    await prefs.setString(usernameKey, username);
    await prefs.setString(emailKey, email);
  }

  Future<Map<String, String>> getUserProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return {
      'fullName': prefs.getString(nameKey) ?? 'Tech Store User',
      'username': prefs.getString(usernameKey) ?? 'tech_user',
      'email': prefs.getString(emailKey) ?? 'user@techstore.com',
    };
  }
}
