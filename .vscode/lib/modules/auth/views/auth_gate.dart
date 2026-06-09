import 'package:flutter/material.dart';

import 'package:tech_store/core/services/auth_service.dart';
import 'package:tech_store/modules/dashboard/views/dashboard_page.dart';
import 'package:tech_store/modules/auth/views/login_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final AuthService authService = AuthService();

  bool isLoading = true;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    loadAuthStatus();
  }

  Future<void> loadAuthStatus() async {
    final bool loggedIn = await authService.isLoggedIn;

    if (!mounted) return;

    setState(() {
      isLoggedIn = loggedIn;
      isLoading = false;
    });
  }

  void login() {
    authService.login();

    setState(() {
      isLoggedIn = true;
    });
  }

  void logout() {
    authService.logout();

    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFEAF3EF),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF24664B),
          ),
        ),
      );
    }

    if (!isLoggedIn) {
      return LoginPage(onLogin: login);
    }

    return DashboardPage(onLogout: logout);
  }
}


