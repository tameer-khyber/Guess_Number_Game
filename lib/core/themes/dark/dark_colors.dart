import 'package:flutter/material.dart';

/// Dark theme colors for the Game Hub app
class DarkColors {
  // Primary Colors
  static const Color primary = Color(0xFF1E1E2F);
  static const Color secondary = Color(0xFF27293D);
  static const Color accent = Color(0xFF00E5FF); // Cyan accent
  
  // Background Colors
  static const Color background = Color(0xFF12121F);
  static const Color surface = Color(0xFF1E1E2F);
  
  // Text Colors
  static const Color text = Color(0xFFE0E0E0);
  static const Color textSecondary = Color(0xFF9E9E9E);
  
  // Glass Morphism
  static const Color glassBackground = Color(0x591E1E2F); // rgba(30, 30, 47, 0.35)
  static const Color glassBorder = Color(0x3300E5FF); // rgba(0, 229, 255, 0.2)
  
  // Effects
  static const Color cardGlow = Color(0x2600E5FF); // rgba(0, 229, 255, 0.15)
  
  // State Colors
  static const Color danger = Color(0xFFFF5252); // Red for errors, warnings
  static const Color success = Color(0xFF00E676); // Green for success, wins
  
  // Gradient Colors
  static const List<Color> backgroundGradient = [
    Color(0xFF12121F),
    Color(0xFF1E1E2F),
    Color(0xFF0D0D1A),
  ];
  
  // Animated Orbs
  static const Color orb1 = Color(0x1F00E5FF); // rgba(0, 229, 255, 0.12)
  static const Color orb2 = Color(0x1400E5FF); // rgba(0, 229, 255, 0.08)
  static const Color orb3 = Color(0x0F00E5FF); // rgba(0, 229, 255, 0.06)
}
