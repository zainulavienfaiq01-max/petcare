import 'package:flutter/material.dart';

class AppColors {
  // ─── Light Theme Colors ───
  static const Color primaryPurple = Color(0xFFB39DDB);
  static const Color primaryPurpleDark = Color(0xFF9575CD);
  static const Color primaryPurpleLight = Color(0xFFD1C4E9);
  static const Color accentPurple = Color(0xFF7E57C2);

  static const Color backgroundLight = Color(0xFFF8F6FC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF2D2D3A);
  static const Color textSecondary = Color(0xFF6E6E82);
  static const Color textHint = Color(0xFFB0B0C0);

  static const Color softGrey = Color(0xFFF0EEF5);
  static const Color divider = Color(0xFFE8E5F0);

  // ─── Dark Theme Colors ───
  static const Color backgroundDark = Color(0xFF1A1A2E);
  static const Color surfaceDark = Color(0xFF222240);
  static const Color cardDark = Color(0xFF2A2A4A);

  static const Color textPrimaryDark = Color(0xFFEAEAF0);
  static const Color textSecondaryDark = Color(0xFFB0B0C8);

  // ─── Gradient Colors ───
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFB39DDB), Color(0xFF9575CD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient1 = LinearGradient(
    colors: [Color(0xFFE8DEF8), Color(0xFFD1C4E9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient2 = LinearGradient(
    colors: [Color(0xFFBBDEFB), Color(0xFF90CAF9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient3 = LinearGradient(
    colors: [Color(0xFFC8E6C9), Color(0xFFA5D6A7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient4 = LinearGradient(
    colors: [Color(0xFFFFE0B2), Color(0xFFFFCC80)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Status Colors ───
  static const Color success = Color(0xFF66BB6A);
  static const Color warning = Color(0xFFFFB74D);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF42A5F5);

  // ─── Shadow ───
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: primaryPurple.withValues(alpha: 0.10),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];
}
