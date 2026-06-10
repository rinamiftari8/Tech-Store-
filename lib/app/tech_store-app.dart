import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/auth/viewmodels/auth_view_model.dart';
import '../features/auth/views/login_screen.dart';
import '../features/home/views/main_shell.dart';
import 'theme.dart';

class TechStoreApp extends StatelessWidget {
  const TechStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tech Store',
      theme: AppTheme.lightTheme,
      home: Consumer<AuthViewModel>(
        builder: (context, auth, _) {
          if (auth.isBootstrapping) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return auth.isAuthenticated ? const MainShell() : const LoginScreen();
        },
      ),
    );
  }
}

