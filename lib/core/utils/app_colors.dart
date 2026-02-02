import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../themes/theme_controller.dart';

/// Dynamic theme colors that update when theme changes
/// Use this instead of DarkColors/LightColors for theme-reactive UI
class AppColors {
  static ThemeController get _theme => Get.find<ThemeController>();
  
  static Color get primary => _theme.primary;
  static Color get secondary => _theme.secondary;
  static Color get accent => _theme.accent;
  static List<Color> get backgroundGradient => _theme.backgroundGradient;
  static Color get text => _theme.text;
  static Color get textSecondary => _theme.textSecondary;
  static Color get glassBackground => _theme.glassBackground;
  static Color get glassBorder => _theme.glassBorder;
}
