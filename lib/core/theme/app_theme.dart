import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const ink = Color(0xFF1E2925);
  static const cream = Color(0xFFF8F7F2);
  static const sage = Color(0xFF88A28F);
  static const coral = Color(0xFFE77863);
  static const mist = Color(0xFFE9EFE9);

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: sage,
        brightness: Brightness.light,
        surface: cream,
      ),
    );
    return base.copyWith(
      textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).apply(
        bodyColor: ink,
        displayColor: ink,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: cream,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: cream,
        indicatorColor: mist,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ink),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: sage, width: 1.5),
        ),
      ),
    );
  }
}
