import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:tech_store/core/services/auth_service.dart';
import 'package:tech_store/utils/app_styles.dart';
import 'package:tech_store/widgets/common_widgets.dart';

enum AuthView {
  login,
  signup,
  verify,
  forgotPassword,
  resetPassword,
}

class LoginPage extends StatefulWidget {
  final VoidCallback onLogin;

  const LoginPage({
    super.key,
    required this.onLogin,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService authService = AuthService();

  AuthView authView = AuthView.signup;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController verificationCodeController =
      TextEditingController();
  final TextEditingController forgotEmailController = TextEditingController();
  final TextEditingController resetCodeController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool hidePassword = true;
  bool hideNewPassword = true;

  final String demoCode = '123456';
  String emailVerificationCode = '123456';

  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    verificationCodeController.dispose();
    forgotEmailController.dispose();
    resetCodeController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
  }

  void showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : const Color(0xFF24664B),
      ),
    );
  }

  String generateVerificationCode() {
    final Random random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  Future<bool> sendVerificationEmail({
    required String userName,
    required String email,
    required String code,
  }) async {
    const String serviceId = 'service_gmail_rina';
    const String templateId = 'z6bd9hi';
    const String publicKey = '42QI5HYEvDggFav-u';

    final Map<String, dynamic> payload = {
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': publicKey,
      'template_params': {
        'email': email,
        'user_name': userName,
        'passcode': code,
      },
    };

    try {
      final http.Response response = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (_) {
      return false;
    }
  }
  Future<void> createAccount() async {
    final String fullName = fullNameController.text.trim();
    final String username = usernameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (fullName.isEmpty) {
      showMessage('Please write your full name.');
      return;
    }

    if (username.isEmpty) {
      showMessage('Please write your username.');
      return;
    }

    if (!isValidEmail(email)) {
      showMessage('Please write a valid email.');
      return;
    }

    if (password.length < 6) {
      showMessage('Password must have at least 6 characters.');
      return;
    }

    await authService.saveUser(
      fullName: fullName,
      username: username,
      email: email,
    );

    emailVerificationCode = generateVerificationCode();

    final bool emailSent = await sendVerificationEmail(
      userName: fullName,
      email: email,
      code: emailVerificationCode,
    );

    setState(() {
      authView = AuthView.verify;
    });

    if (emailSent) {
      showMessage(
        'Verification code sent to your Gmail.',
        isError: false,
      );
    } else {
      showMessage(
        'Email service is slow. Use this verification code: ' + emailVerificationCode,
        isError: false,
      );
    }
  }

  void verifyAccount() {
    final String code = verificationCodeController.text.trim();

    if (code != emailVerificationCode) {
      showMessage('Wrong verification code. Please check your Gmail.');
      return;
    }

    showMessage('Account verified successfully.', isError: false);
    widget.onLogin();
  }

  void loginUser() {
    final String emailOrUsername = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (emailOrUsername.isEmpty) {
      showMessage('Please write email or username.');
      return;
    }

    if (password.length < 6) {
      showMessage('Password must have at least 6 characters.');
      return;
    }

    widget.onLogin();
  }

  void sendResetCode() {
    final String email = forgotEmailController.text.trim();

    if (!isValidEmail(email)) {
      showMessage('Please write a valid email.');
      return;
    }

    setState(() {
      authView = AuthView.resetPassword;
    });

    showMessage(
      'Reset code sent. Demo code is 123456.',
      isError: false,
    );
  }

  void resetPassword() {
    final String code = resetCodeController.text.trim();
    final String newPassword = newPasswordController.text.trim();

    if (code != emailVerificationCode) {
      showMessage('Wrong reset code. Use 123456.');
      return;
    }

    if (newPassword.length < 6) {
      showMessage('New password must have at least 6 characters.');
      return;
    }

    newPasswordController.clear();
    resetCodeController.clear();

    setState(() {
      authView = AuthView.login;
    });

    showMessage(
      'Password reset successfully. Please login now.',
      isError: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isPhone = MediaQuery.of(context).size.width < 720;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF3EF),
      body: Container(
        decoration: appGradient(),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.all(isPhone ? 16 : 34),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: isPhone
                    ? Column(
                        children: [
                          loginHero(isPhone),
                          const SizedBox(height: 24),
                          authCard(isPhone),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: loginHero(isPhone)),
                          const SizedBox(width: 34),
                          Expanded(child: authCard(isPhone)),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginHero(bool isPhone) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isPhone ? 24 : 42),
      decoration: darkHeroDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelChip('TECH STORE PRO'),
          const SizedBox(height: 26),
          Text(
            'Smart devices\nin one place',
            style: TextStyle(
              color: Colors.white,
              fontSize: isPhone ? 38 : 60,
              fontWeight: FontWeight.w900,
              height: 1.12,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Create an account or login first. After that you can open dashboard, products, cart and payment.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.90),
              fontSize: isPhone ? 16 : 19,
              height: 1.75,
            ),
          ),
          const SizedBox(height: 30),
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: appImage(
              'https://images.unsplash.com/photo-1550009158-9ebf69173e03?auto=format&fit=crop&w=600&q=55',
              height: isPhone ? 205 : 315,
            ),
          ),
        ],
      ),
    );
  }

  Widget authCard(bool isPhone) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isPhone ? 24 : 34),
      decoration: whiteCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          authIcon(),
          const SizedBox(height: 24),
          Text(
            authTitle(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isPhone ? 34 : 42,
              fontWeight: FontWeight.w900,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            authSubtitle(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 30),
          authBody(),
        ],
      ),
    );
  }

  Widget authIcon() {
    IconData icon = Icons.lock_rounded;

    if (authView == AuthView.signup) {
      icon = Icons.person_add_alt_1_rounded;
    }

    if (authView == AuthView.verify) {
      icon = Icons.verified_user_rounded;
    }

    if (authView == AuthView.forgotPassword ||
        authView == AuthView.resetPassword) {
      icon = Icons.password_rounded;
    }

    return Icon(
      icon,
      color: const Color(0xFF24664B),
      size: 76,
    );
  }

  String authTitle() {
    if (authView == AuthView.signup) return 'Create Account';
    if (authView == AuthView.verify) return 'Verify Account';
    if (authView == AuthView.forgotPassword) return 'Forgot Password';
    if (authView == AuthView.resetPassword) return 'Reset Password';
    return 'Login';
  }

  String authSubtitle() {
    if (authView == AuthView.signup) {
      return 'Create your account first to continue.';
    }

    if (authView == AuthView.verify) {
      return 'Enter the verification code to activate your account.';
    }

    if (authView == AuthView.forgotPassword) {
      return 'Write your email to receive a reset code.';
    }

    if (authView == AuthView.resetPassword) {
      return 'Use the reset code and create a new password.';
    }

    return 'Login to continue to dashboard.';
  }

  Widget authBody() {
    if (authView == AuthView.signup) {
      return signupForm();
    }

    if (authView == AuthView.verify) {
      return verificationForm();
    }

    if (authView == AuthView.forgotPassword) {
      return forgotPasswordForm();
    }

    if (authView == AuthView.resetPassword) {
      return resetPasswordForm();
    }

    return loginForm();
  }

  Widget signupForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        appField(
          controller: fullNameController,
          hint: 'Full name',
          icon: Icons.person_rounded,
        ),
        const SizedBox(height: 18),
        appField(
          controller: usernameController,
          hint: 'Username',
          icon: Icons.alternate_email_rounded,
        ),
        const SizedBox(height: 18),
        appField(
          controller: emailController,
          hint: 'Email',
          icon: Icons.email_rounded,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 18),
        appField(
          controller: passwordController,
          hint: 'Password',
          icon: Icons.lock_rounded,
          obscureText: hidePassword,
          suffix: IconButton(
            onPressed: () {
              setState(() {
                hidePassword = !hidePassword;
              });
            },
            icon: Icon(
              hidePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          ),
        ),
        const SizedBox(height: 28),
        SizedBox(
          height: 58,
          child: ElevatedButton(
            onPressed: createAccount,
            style: greenButton(),
            child: const Text('Create Account'),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 54,
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                authView = AuthView.login;
              });
            },
            child: const Text('Already have an account? Login'),
          ),
        ),
      ],
    );
  }

  Widget loginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        appField(
          controller: emailController,
          hint: 'Email or username',
          icon: Icons.email_rounded,
        ),
        const SizedBox(height: 18),
        appField(
          controller: passwordController,
          hint: 'Password',
          icon: Icons.lock_rounded,
          obscureText: hidePassword,
          suffix: IconButton(
            onPressed: () {
              setState(() {
                hidePassword = !hidePassword;
              });
            },
            icon: Icon(
              hidePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          ),
        ),
        const SizedBox(height: 28),
        SizedBox(
          height: 58,
          child: ElevatedButton(
            onPressed: loginUser,
            style: greenButton(),
            child: const Text('Login'),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 54,
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                authView = AuthView.signup;
              });
            },
            child: const Text('Create Account'),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            setState(() {
              authView = AuthView.forgotPassword;
            });
          },
          child: const Text('Forgot Password?'),
        ),
      ],
    );
  }

  Widget verificationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        appField(
          controller: verificationCodeController,
          hint: 'Verification code',
          icon: Icons.verified_rounded,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        const Text(
          'Check your Gmail for the verification code.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF24664B),
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 28),
        SizedBox(
          height: 58,
          child: ElevatedButton(
            onPressed: verifyAccount,
            style: greenButton(),
            child: const Text('Verify and Continue'),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            setState(() {
              authView = AuthView.signup;
            });
          },
          child: const Text('Back to Signup'),
        ),
      ],
    );
  }

  Widget forgotPasswordForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        appField(
          controller: forgotEmailController,
          hint: 'Email',
          icon: Icons.email_rounded,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 28),
        SizedBox(
          height: 58,
          child: ElevatedButton(
            onPressed: sendResetCode,
            style: greenButton(),
            child: const Text('Send Reset Code'),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            setState(() {
              authView = AuthView.login;
            });
          },
          child: const Text('Back to Login'),
        ),
      ],
    );
  }

  Widget resetPasswordForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        appField(
          controller: resetCodeController,
          hint: 'Reset code',
          icon: Icons.pin_rounded,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 18),
        appField(
          controller: newPasswordController,
          hint: 'New password',
          icon: Icons.lock_reset_rounded,
          obscureText: hideNewPassword,
          suffix: IconButton(
            onPressed: () {
              setState(() {
                hideNewPassword = !hideNewPassword;
              });
            },
            icon: Icon(
              hideNewPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Demo reset code: 123456',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF24664B),
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 28),
        SizedBox(
          height: 58,
          child: ElevatedButton(
            onPressed: resetPassword,
            style: greenButton(),
            child: const Text('Reset Password'),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            setState(() {
              authView = AuthView.login;
            });
          },
          child: const Text('Back to Login'),
        ),
      ],
    );
  }
}






