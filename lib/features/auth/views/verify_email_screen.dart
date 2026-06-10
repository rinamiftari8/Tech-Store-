import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../viewmodels/auth_view_model.dart';
import 'auth_scaffold.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _codeController = TextEditingController(text: AppConstants.verificationCode);

  @override
  void dispose() {
    _codeController.dispose();
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
                title: 'Verify email',
                subtitle: 'For demo purposes, the verification code is 123456.',
              ),
              const SizedBox(height: 26),
              AppTextField(
                controller: _codeController,
                label: 'Verification code',
                icon: Icons.verified_rounded,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 18),
              if (auth.errorMessage != null) ...[
                Text(auth.errorMessage!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
              ],
              AppButton(
                label: 'Verify account',
                icon: Icons.check_circle_rounded,
                isLoading: auth.isLoading,
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(context);
                  final ok = await context.read<AuthViewModel>().verifyEmail(_codeController.text);
                  if (ok) {
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Email verified successfully.')),
                    );
                    navigator.popUntil((route) => route.isFirst);
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
