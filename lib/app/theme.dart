import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF0F9D58);
  static const primaryDark = Color(0xFF075E35);
  static const primaryDeep = Color(0xFF043B24);

  static const accent = Color(0xFF72E4A5);
  static const lime = Color(0xFFBDFCC9);
  static const mint = Color(0xFFDDF8E9);
  static const lightGreen = Color(0xFFEAF8F0);

  static const background = Color(0xFFF4FBF7);
  static const backgroundSoft = Color(0xFFEFF8F3);
  static const card = Color(0xFFFFFFFF);

  static const text = Color(0xFF17231D);
  static const muted = Color(0xFF6B7A72);
  static const border = Color(0xFFE1ECE6);

  static const danger = Color(0xFFE5484D);
  static const warning = Color(0xFFF2A93B);
  static const blue = Color(0xFF2D7FF9);
  static const purple = Color(0xFF7C5CFC);

  // Kjo është lënë për kompatibilitet me file-t e vjetër.
  static const darkGreen = primaryDark;
}

class AppTheme {
  static ThemeData get lightTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.primaryDark,
      surface: AppColors.card,
      background: AppColors.background,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',
      visualDensity: VisualDensity.adaptivePlatformDensity,

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.text),
        titleTextStyle: TextStyle(
          color: AppColors.text,
          fontSize: 24,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.3,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: AppColors.muted),
        prefixIconColor: AppColors.muted,
        suffixIconColor: AppColors.muted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: AppColors.danger,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 17,
        ),
      ),

      cardTheme: CardTheme(
        color: AppColors.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shadowColor: AppColors.primaryDark.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: AppColors.primary.withOpacity(0.22),
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 18,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primaryDeep,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primary.withOpacity(0.14),
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        iconTheme: MaterialStateProperty.all(
          const IconThemeData(color: AppColors.primaryDark),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
      ),
    );
  }
}

class SoftShadow {
  static List<BoxShadow> get medium => [
        BoxShadow(
          color: AppColors.primaryDark.withOpacity(0.08),
          blurRadius: 28,
          offset: const Offset(0, 16),
        ),
      ];

  static List<BoxShadow> get strong => [
        BoxShadow(
          color: AppColors.primaryDark.withOpacity(0.14),
          blurRadius: 42,
          offset: const Offset(0, 22),
        ),
      ];
}

class AppGradients {
  static const greenHero = LinearGradient(
    colors: [
      AppColors.primaryDeep,
      AppColors.primaryDark,
      AppColors.primary,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const softBackground = LinearGradient(
    colors: [
      AppColors.background,
      AppColors.backgroundSoft,
      Color(0xFFE7F8EE),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const cardGlow = LinearGradient(
    colors: [
      Colors.white,
      AppColors.lightGreen,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
