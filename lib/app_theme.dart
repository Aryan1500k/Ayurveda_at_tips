import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Pistachio Palette
  static const Color pistachioBackground = Color(0xFFE8F3EE); // Light background
  static const Color primaryGreen = Color(0xFF009460); // Button/Icon green
  static const Color cardWhite = Colors.white;
  static const Color textDark = Color(0xFF2D2D2D);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: pistachioBackground,
      textTheme: GoogleFonts.instrumentSansTextTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}