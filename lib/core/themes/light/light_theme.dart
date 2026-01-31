import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'light_colors.dart';

/// Light theme configuration for the app
class LightTheme {
  static ThemeData get theme => ThemeData(
        brightness: Brightness.light,
        primaryColor: LightColors.primary,
        scaffoldBackgroundColor: LightColors.background,
        
        // App Bar Theme
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: LightColors.text),
          titleTextStyle: GoogleFonts.poppins(
            color: LightColors.text,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        // Text Theme
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          displayLarge: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: LightColors.text,
          ),
          displayMedium: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: LightColors.text,
          ),
          displaySmall: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: LightColors.text,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 16,
            color: LightColors.text,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 14,
            color: LightColors.text,
          ),
          bodySmall: GoogleFonts.poppins(
            fontSize: 12,
            color: LightColors.textSecondary,
          ),
        ),
        
        // Color Scheme
        colorScheme: const ColorScheme.light(
          primary: LightColors.primary,
          secondary: LightColors.secondary,
          surface: LightColors.surface,
          error: Colors.red,
        ),
        
        useMaterial3: true,
      );
}
