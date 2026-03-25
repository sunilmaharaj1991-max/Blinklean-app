import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminTheme {
  static const Color primaryColor = Color(0xFF009543);
  static const Color secondaryColor = Color(0xFF00ADEF);
  static const Color accentPurple = Color(0xFF7C4DFF);
  static const Color accentOrange = Color(0xFFFF6B35);
  static const Color backgroundColor = Color(0xFFF0F2F5);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF1B1B1F);
  static const Color subtleColor = Color(0xFF74777F);
  static const Color successColor = Color(0xFF00C853);
  static const Color warningColor = Color(0xFFFFAB00);
  static const Color errorColor = Color(0xFFFF5252);
  static const Color darkCard = Color(0xFF2D2D3A);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: cardColor,
        onSurface: textColor,
      ),
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: const TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: const TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: const TextStyle(color: textColor),
        bodyMedium: const TextStyle(color: textColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: primaryColor.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}
