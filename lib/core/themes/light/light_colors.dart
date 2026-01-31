import 'package:flutter/material.dart';

/// Light theme colors for the Game Hub app
class LightColors {
  // Primary Colors
  static const Color primary = Color(0xFF4CAF50);
  static const Color secondary = Color(0xFFFFC107);
  static const Color accent = Color(0xFF2196F3);
  
  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F5F5);
  
  // Text Colors
  static const Color text = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  
  // Glass Morphism
  static const Color glassBackground = Color(0x40FFFFFF); // rgba(255, 255, 255, 0.25)
  static const Color glassBorder = Color(0x66FFFFFF); // rgba(255, 255, 255, 0.4)
  
  // Effects
  static const Color cardGlow = Color(0x334CAF50); // rgba(76, 175, 80, 0.2)
  
  // State Colors
  static const Color danger = Color(0xFFF44336); // Red for errors, warnings
  static const Color success = Color(0xFF4CAF50); // Green for success, wins
  
  // Gradient Colors
  static const List<Color> backgroundGradient = [
    Color(0xFFE8F5E9), // Light green tint
    Color(0xFFFFF8E1), // Light yellow tint
    Color(0xFFE3F2FD), // Light blue tint
  ];
  
  // Animated Orbs
  static const Color orb1 = Color(0x2E4CAF50); // rgba(76, 175, 80, 0.18)
  static const Color orb2 = Color(0x262196F3); // rgba(33, 150, 243, 0.15)
  static const Color orb3 = Color(0x2EFFC107); // rgba(255, 193, 7, 0.18)
}
