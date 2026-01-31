import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dark_colors.dart';

/// Dark theme configuration for the app
class DarkTheme {
  static ThemeData get theme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: DarkColors.primary,
        scaffoldBackgroundColor: DarkColors.background,
        
        // App Bar Theme
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: DarkColors.text),
          titleTextStyle: GoogleFonts.poppins(
            color: DarkColors.text,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        // Text Theme
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          displayLarge: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: DarkColors.text,
          ),
          displayMedium: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: DarkColors.text,
          ),
          displaySmall: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: DarkColors.text,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 16,
            color: DarkColors.text,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 14,
            color: DarkColors.text,
          ),
          bodySmall: GoogleFonts.poppins(
            fontSize: 12,
            color: DarkColors.textSecondary,
          ),
        ),
        
        // Color Scheme
        colorScheme: const ColorScheme.dark(
          primary: DarkColors.primary,
          secondary: DarkColors.secondary,
          surface: DarkColors.surface,
          error: Colors.red,
        ),
        
        useMaterial3: true,
      );
}
