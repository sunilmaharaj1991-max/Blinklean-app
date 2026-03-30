import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 🌿 BlinKlean Branded Theme exactly matching vibrant official logo 
  static const Color primaryColor = Color(0xFF14B351); // Vibrant Logo Leaf Green
  static const Color secondaryColor = Color(0xFF00AEEF); // Vibrant Logo Sky Blue
  static const Color primaryGradientEnd = Color(0xFF00AEEF);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFF9FBF9);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF1B1B1F);
  static const Color subtleColor = Color(0xFF74777F);
  static const Color accentColor = Color(0xFFFFB200); // Warm Gold for premium highlights
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  
  static Gradient get primaryGradient => const LinearGradient(
    colors: [primaryColor, Color(0xFF0D8A3E)], // Deep Green to Vibrant Green
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Gradient get secondaryGradient => const LinearGradient(
    colors: [secondaryColor, Color(0xFF0079A6)], // Sky Blue to Deep Blue
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Gradient get goldGradient => const LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFF8C00)], // Gold Gradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static List<BoxShadow> get premiumShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: primaryColor.withValues(alpha: 0.06),
      blurRadius: 40,
      offset: const Offset(0, 12),
    ),
  ];

  static BoxDecoration glassDecoration({double opacity = 0.1, double blur = 12}) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackground,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: cardColor,
        onSurface: textColor,
      ),
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: const TextStyle(color: textColor, fontWeight: FontWeight.bold, letterSpacing: -1.2),
        displayMedium: const TextStyle(color: textColor, fontWeight: FontWeight.bold, letterSpacing: -0.8),
        titleLarge: const TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 22),
        titleMedium: const TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 18),
        bodyLarge: const TextStyle(color: textColor, fontSize: 16, height: 1.5),
        bodyMedium: const TextStyle(color: textColor, fontSize: 14, height: 1.4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0, // Zero elevation for modern flat look with gradients
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        prefixIconColor: primaryColor,
        suffixIconColor: subtleColor,
        contentPadding: const EdgeInsets.all(20),
        hintStyle: TextStyle(color: subtleColor.withValues(alpha: 0.6)),
      ),
      cardTheme: CardThemeData(
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}
