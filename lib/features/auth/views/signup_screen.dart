import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../viewmodels/auth_view_model.dart';
import 'auth_scaffold.dart';
import 'verify_email_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _acceptTerms = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    FocusScope.of(context).unfocus();

    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields.'),
        ),
      );
      return;
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address.'),
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters.'),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match.'),
        ),
      );
      return;
    }

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms to continue.'),
        ),
      );
      return;
    }

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final ok = await context.read<AuthViewModel>().signUp(
          username,
          email,
          password,
        );

    if (ok) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Account created. Please verify your email.'),
        ),
      );

      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (_) => const VerifyEmailScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();

    return AuthScaffold(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.93),
          borderRadius: BorderRadius.circular(34),
          border: Border.all(
            color: Colors.white.withOpacity(0.9),
          ),
          boxShadow: SoftShadow.strong,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _SignupTopPanel(),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthHeader(
                      title: 'Create your account',
                      subtitle:
                          'Join Tech Store and manage products, bookings, orders, analytics and notifications from one premium dashboard.',
                    ),
                    const SizedBox(height: 24),
                    const _VerificationInfoBox(),
                    const SizedBox(height: 18),
                    AppTextField(
                      controller: _usernameController,
                      label: 'Username',
                      icon: Icons.badge_rounded,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      controller: _emailController,
                      label: 'Email address',
                      icon: Icons.email_rounded,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock_rounded,
                      obscureText: true,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm password',
                      icon: Icons.lock_reset_rounded,
                      obscureText: true,
                    ),
                    const SizedBox(height: 12),
                    _PasswordChecklist(
                      password: _passwordController.text,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _acceptTerms,
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _acceptTerms = value ?? true;
                            });
                          },
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text(
                              'I agree to use this demo application for the Tech Store project presentation.',
                              style: TextStyle(
                                color: AppColors.muted,
                                height: 1.35,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (auth.errorMessage != null) ...[
                      const SizedBox(height: 8),
                      _ErrorBox(message: auth.errorMessage!),
                    ],
                    const SizedBox(height: 18),
                    AppButton(
                      label: 'Create premium account',
                      icon: Icons.person_add_alt_1_rounded,
                      isLoading: auth.isLoading,
                      onPressed: _createAccount,
                    ),
                    const SizedBox(height: 16),
                    const _ProjectRequirementsRow(),
                    const SizedBox(height: 18),
                    _BackToLoginBox(
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignupTopPanel extends StatelessWidget {
  const _SignupTopPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 134,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppGradients.greenHero,
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -42,
            child: Container(
              width: 145,
              height: 145,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.10),
              ),
            ),
          ),
          Positioned(
            left: -40,
            bottom: -54,
            child: Container(
              width: 155,
              height: 155,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.25),
                    ),
                  ),
                  child: const Icon(
                    Icons.person_add_alt_1_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Start with Tech Store',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Secure signup • Verification • Dashboard',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.shield_rounded,
                  color: Colors.white.withOpacity(0.9),
                  size: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VerificationInfoBox extends StatelessWidget {
  const _VerificationInfoBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: AppGradients.cardGlow,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.verified_user_rounded,
            color: AppColors.primaryDark,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'After signup, verify the account with code: 123456.',
              style: TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w800,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordChecklist extends StatelessWidget {
  const _PasswordChecklist({
    required this.password,
  });

  final String password;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundSoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CheckLine(
            text: 'Use at least 6 characters',
            active: true,
          ),
          SizedBox(height: 7),
          _CheckLine(
            text: 'Email verification included',
            active: true,
          ),
          SizedBox(height: 7),
          _CheckLine(
            text: 'Forgot password supported',
            active: true,
          ),
        ],
      ),
    );
  }
}

class _CheckLine extends StatelessWidget {
  const _CheckLine({
    required this.text,
    required this.active,
  });

  final String text;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          active ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
          color: active ? AppColors.primary : AppColors.muted,
          size: 18,
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: active ? AppColors.primaryDark : AppColors.muted,
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProjectRequirementsRow extends StatelessWidget {
  const _ProjectRequirementsRow();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        _FeatureChip(
          icon: Icons.login_rounded,
          label: 'Auth',
        ),
        _FeatureChip(
          icon: Icons.api_rounded,
          label: 'REST API',
        ),
        _FeatureChip(
          icon: Icons.notifications_rounded,
          label: 'Alerts',
        ),
        _FeatureChip(
          icon: Icons.analytics_rounded,
          label: 'MVVM',
        ),
      ],
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.07),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: AppColors.primary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _BackToLoginBox extends StatelessWidget {
  const _BackToLoginBox({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.backgroundSoft,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.login_rounded,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Already have an account?',
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          TextButton(
            onPressed: onPressed,
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.danger.withOpacity(0.12),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.danger,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
