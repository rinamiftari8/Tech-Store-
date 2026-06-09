import 'package:flutter/material.dart';

import '../../app/theme.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.label,
    this.text,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.outlined = false,
    this.height = 58,
    this.fullWidth = true,
  });

  final String? label;
  final String? text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool outlined;
  final double height;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final buttonText = label ?? text ?? '';
    final isDisabled = onPressed == null || isLoading;

    final child = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        else if (icon != null)
          Icon(
            icon,
            size: 21,
            color: outlined ? AppColors.primaryDark : Colors.white,
          ),
        if (isLoading || icon != null) const SizedBox(width: 10),
        Flexible(
          child: Text(
            isLoading ? 'Please wait...' : buttonText,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: outlined ? AppColors.primaryDark : Colors.white,
              fontSize: 15.5,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.1,
            ),
          ),
        ),
      ],
    );

    if (outlined) {
      return SizedBox(
        width: fullWidth ? double.infinity : null,
        height: height,
        child: OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primaryDark,
            side: const BorderSide(
              color: AppColors.border,
              width: 1.2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: child,
        ),
      );
    }

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: Opacity(
        opacity: isDisabled && !isLoading ? 0.55 : 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: isDisabled
                ? const LinearGradient(
                    colors: [
                      Color(0xFF9BB8A8),
                      Color(0xFF7CA58E),
                    ],
                  )
                : AppGradients.greenHero,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isDisabled
                ? []
                : [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.26),
                      blurRadius: 24,
                      offset: const Offset(0, 14),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isDisabled ? null : onPressed,
              borderRadius: BorderRadius.circular(20),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}

