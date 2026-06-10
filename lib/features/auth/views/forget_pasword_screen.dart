import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../viewmodels/auth_view_model.dart';
import 'auth_scaffold.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();

    return AuthScaffold(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(
                title: 'Reset password',
                subtitle: 'Write your email and set a new password for your local demo account.',
              ),
              const SizedBox(height: 26),
              AppTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _newPasswordController,
                label: 'New password',
                icon: Icons.lock_reset_rounded,
                obscureText: true,
              ),
              const SizedBox(height: 18),
              if (auth.errorMessage != null) ...[
                Text(auth.errorMessage!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
              ],
              AppButton(
                label: 'Reset password',
                icon: Icons.restart_alt_rounded,
                isLoading: auth.isLoading,
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(context);
                  final found = await context.read<AuthViewModel>().forgotPassword(_emailController.text);
                  if (!found) return;
                  final ok = await context.read<AuthViewModel>().resetPassword(
                        _emailController.text,
                        _newPasswordController.text,
                      );
                  if (ok) {
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Password changed successfully.')),
                    );
                    navigator.pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
