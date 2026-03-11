import 'package:flutter/material.dart';

class AppTheme {
  // School Color Palette
  static const Color primaryPurple   = Color(0xFF6A0DAD); // Deep School Purple
  static const Color secondaryPurple = Color(0xFF9B59B6); // Mid Purple
  static const Color lilac           = Color(0xFFD7B4F3); // Lilac
  static const Color primaryYellow   = Color(0xFFFFD700); // School Gold/Yellow
  static const Color accentYellow    = Color(0xFFFFF176); // Light Yellow
  static const Color black           = Color(0xFF1A1A1A); // Near Black
  static const Color white           = Color(0xFFFFFFFF);

  // Semantic Colors
  static const Color success  = Color(0xFF27AE60);
  static const Color warning  = Color(0xFFF39C12);
  static const Color error    = Color(0xFFE74C3C);
  static const Color info     = Color(0xFF2980B9);

  // Neutral
  static const Color backgroundLight = Color(0xFFF8F5FF); // Tinted with purple
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color textPrimary     = Color(0xFF1A1A1A);
  static const Color textSecondary   = Color(0xFF6B6B6B);
  static const Color dividerColor    = Color(0xFFE8E0F0);
  static const Color cardBackground  = Color(0xFFFFFFFF);

  // RIASEC type colors (kept distinct for data visualization)
  static const Color riasecR = Color(0xFFE74C3C);
  static const Color riasecI = Color(0xFF2980B9);
  static const Color riasecA = Color(0xFF8E44AD);
  static const Color riasecS = Color(0xFF27AE60);
  static const Color riasecE = Color(0xFFE67E22);
  static const Color riasecC = Color(0xFF16A085);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        brightness: Brightness.light,
        primary: primaryPurple,
        secondary: primaryYellow,
        surface: backgroundWhite,
        onPrimary: white,
        onSecondary: black,
      ),
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: primaryPurple,
        foregroundColor: white,
        titleTextStyle: TextStyle(
          color: white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: white),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: cardBackground,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryPurple,
          side: const BorderSide(color: primaryPurple),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return primaryPurple;
            return white;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return white;
            return primaryPurple;
          }),
        ),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryPurple, width: 2),
        ),
        filled: true,
        fillColor: backgroundWhite,
        prefixIconColor: primaryPurple,
        labelStyle: const TextStyle(color: textSecondary),
        floatingLabelStyle: const TextStyle(color: primaryPurple),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lilac.withOpacity(0.3),
        labelStyle: const TextStyle(color: primaryPurple),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryPurple,
        linearTrackColor: dividerColor,
      ),
    );
  }

  // Helper: Get RIASEC type color
  static Color riasecColor(String type) {
    switch (type.toUpperCase()) {
      case 'R': return riasecR;
      case 'I': return riasecI;
      case 'A': return riasecA;
      case 'S': return riasecS;
      case 'E': return riasecE;
      case 'C': return riasecC;
      default:  return primaryPurple;
    }
  }

  // Helper: Get RIASEC type full name
  static String riasecName(String type) {
    switch (type.toUpperCase()) {
      case 'R': return 'Realistic';
      case 'I': return 'Investigative';
      case 'A': return 'Artistic';
      case 'S': return 'Social';
      case 'E': return 'Enterprising';
      case 'C': return 'Conventional';
      default:  return type;
    }
  }

  // Helper: Get RIASEC type descriptor
  static String riasecDescriptor(String type) {
    switch (type.toUpperCase()) {
      case 'R': return 'Doers';
      case 'I': return 'Thinkers';
      case 'A': return 'Creators';
      case 'S': return 'Helpers';
      case 'E': return 'Persuaders';
      case 'C': return 'Organizers';
      default:  return '';
    }
  }
}