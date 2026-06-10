import 'package:flutter/material.dart';

import '../../../app/theme.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.softBackground,
        ),
        child: Stack(
          children: [
            const Positioned(
              top: -90,
              left: -70,
              child: _DecorCircle(
                size: 230,
                opacity: 0.22,
              ),
            ),
            const Positioned(
              bottom: -120,
              right: -70,
              child: _DecorCircle(
                size: 290,
                opacity: 0.26,
              ),
            ),
            const Positioned(
              top: 130,
              left: 34,
              child: _SmallDecorDot(
                size: 16,
                opacity: 0.24,
              ),
            ),
            const Positioned(
              top: 220,
              right: 42,
              child: _SmallDecorDot(
                size: 22,
                opacity: 0.18,
              ),
            ),
            const Positioned(
              bottom: 190,
              left: 46,
              child: _SmallDecorDot(
                size: 26,
                opacity: 0.16,
              ),
            ),
            Positioned(
              top: 80,
              right: 70,
              child: Transform.rotate(
                angle: -0.22,
                child: const _FloatingTechCard(
                  icon: Icons.memory_rounded,
                  title: 'AI Chips',
                  subtitle: 'Next generation',
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              left: 70,
              child: Transform.rotate(
                angle: 0.18,
                child: const _FloatingTechCard(
                  icon: Icons.headphones_rounded,
                  title: 'Smart Audio',
                  subtitle: 'Premium devices',
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(22),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: child,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primaryDark,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.30),
                blurRadius: 30,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: const Icon(
            Icons.devices_other_rounded,
            color: Colors.white,
            size: 48,
          ),
        ),
        const SizedBox(height: 24),
        const _MiniBadge(label: 'PREMIUM TECH DASHBOARD'),
        const SizedBox(height: 14),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            height: 1.05,
            letterSpacing: -0.8,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.muted,
            height: 1.55,
            fontSize: 15.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.09),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.14),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primaryDark,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.7,
        ),
      ),
    );
  }
}

class _DecorCircle extends StatelessWidget {
  const _DecorCircle({
    required this.size,
    required this.opacity,
  });

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withOpacity(opacity),
      ),
    );
  }
}

class _SmallDecorDot extends StatelessWidget {
  const _SmallDecorDot({
    required this.size,
    required this.opacity,
  });

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _FloatingTechCard extends StatelessWidget {
  const _FloatingTechCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 175,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.80),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.8),
          ),
          boxShadow: SoftShadow.medium,
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
              child: Icon(
                icon,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
