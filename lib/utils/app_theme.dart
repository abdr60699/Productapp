import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color lightOrange = Color(0xFFFFB892);
  static const Color darkOrange = Color(0xFFE55A2B);
  static const Color accentOrange = Color(0xFFFFA366);

  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textMuted = Color(0xFFBDC3C7);

  static const Color successColor = Color(0xFF27AE60);
  static const Color errorColor = Color(0xFFE74C3C);
  static const Color warningColor = Color(0xFFF39C12);

  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: GoogleFonts.nunito().fontFamily,
      primarySwatch: createMaterialColor(primaryOrange),
      primaryColor: primaryOrange,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      useMaterial3: true,

      colorScheme: const ColorScheme.light(
        primary: primaryOrange,
        secondary: accentOrange,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onError: Colors.white,
        outline: textMuted,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: primaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryOrange,
          side: const BorderSide(color: primaryOrange, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: textMuted),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: textMuted),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryOrange, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        fillColor: surfaceColor,
        filled: true,
        labelStyle: const TextStyle(
          color: textSecondary,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: const TextStyle(
          color: textMuted,
          fontWeight: FontWeight.w400,
        ),
      ),

      cardTheme: CardTheme(
        color: cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      textTheme: GoogleFonts.nunitoTextTheme().copyWith(
        displayLarge: GoogleFonts.nunito(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        displayMedium: GoogleFonts.nunito(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        displaySmall: GoogleFonts.nunito(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineLarge: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        titleSmall: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        bodySmall: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textMuted,
        ),
      ),
    );
  }

  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}