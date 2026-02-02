import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'variants/neon_dreams_colors.dart';
import 'variants/ocean_breeze_colors.dart';
import 'variants/sunset_glow_colors.dart';
import 'variants/galaxy_stars_colors.dart';
import 'variants/forest_green_colors.dart';
import 'variants/royal_purple_colors.dart';
import 'dark/dark_colors.dart';
import 'light/light_colors.dart';

/// Controller for managing app theme (dark/light mode and theme variants)
/// Follows GetX state management pattern and persists theme preference
class ThemeController extends GetxController {
  // Reactive theme mode
  final Rx<ThemeMode> _themeMode = ThemeMode.dark.obs;
  
  // Selected theme variant (null = default theme)
  final Rx<String?> selectedTheme = Rx<String?>(null);
  
  // Getter for theme mode
  ThemeMode get themeMode => _themeMode.value;
  
  // Check if dark mode is active
  bool get isDarkMode => _themeMode.value == ThemeMode.dark;
  
  // Storage box for persistence
  Box? _settingsBox;
  
  @override
  void onInit() {
    super.onInit();
    _loadThemePreference();
  }
  
  /// Load theme preference from storage
  Future<void> _loadThemePreference() async {
    try {
      _settingsBox = await Hive.openBox('settings');
      final savedThemeMode = _settingsBox?.get('themeMode', defaultValue: 'dark');
      final savedThemeVariant = _settingsBox?.get('themeVariant');
      
      if (savedThemeMode == 'light') {
        _themeMode.value = ThemeMode.light;
      } else {
        _themeMode.value = ThemeMode.dark;
      }
      
      selectedTheme.value = savedThemeVariant;
    } catch (e) {
      // If error, default to dark mode with no variant
      _themeMode.value = ThemeMode.dark;
      selectedTheme.value = null;
    }
  }
  
  /// Toggle between light and dark theme
  void toggleTheme() {
    if (_themeMode.value == ThemeMode.dark) {
      _themeMode.value = ThemeMode.light;
      _saveThemePreference('light');
    } else {
      _themeMode.value = ThemeMode.dark;
      _saveThemePreference('dark');
    }
    
    // Update GetMaterialApp theme
    Get.changeThemeMode(_themeMode.value);
  }
  
  /// Save theme preference to storage
  Future<void> _saveThemePreference(String mode) async {
    try {
      await _settingsBox?.put('themeMode', mode);
    } catch (e) {
      // Handle error silently
    }
  }
  
  /// Set specific theme mode
  void setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    _saveThemePreference(mode == ThemeMode.dark ? 'dark' : 'light');
    Get.changeThemeMode(mode);
  }
  
  /// Set theme variant
  Future<void> setTheme(String? themeId) async {
    selectedTheme.value = themeId;
    try {
      await _settingsBox?.put('themeVariant', themeId);
    } catch (e) {
      // Handle error silently
    }
    // Force UI update
    update();
  }
  
  /// Get current theme colors based on selected variant and theme mode
  Map<String, dynamic> getCurrentColors() {
    // If no theme variant selected, use default dark/light colors
    if (selectedTheme.value == null) {
      return isDarkMode ? _getDefaultDarkColors() : _getDefaultLightColors();
    }
    
    // Get variant colors
    switch (selectedTheme.value) {
      case 'neon_theme':
        return _getNeonDreamsColors();
      case 'ocean_theme':
        return _getOceanBreezeColors();
      case 'sunset_theme':
        return _getSunsetGlowColors();
      case 'galaxy_theme':
        return _getGalaxyStarsColors();
      case 'forest_theme':
        return _getForestGreenColors();
      case 'royal_theme':
        return _getRoyalPurpleColors();
      default:
        return isDarkMode ? _getDefaultDarkColors() : _getDefaultLightColors();
    }
  }
  
  // Convenient getters for individual colors
  Color get primary => getCurrentColors()['primary'] as Color;
  Color get secondary => getCurrentColors()['secondary'] as Color;
  Color get accent => getCurrentColors()['accent'] as Color;
  List<Color> get backgroundGradient => getCurrentColors()['backgroundGradient'] as List<Color>;
  Color get text => getCurrentColors()['text'] as Color;
  Color get textSecondary => getCurrentColors()['textSecondary'] as Color;
  Color get glassBackground => getCurrentColors()['glassBackground'] as Color;
  Color get glassBorder => getCurrentColors()['glassBorder'] as Color;
  
  Map<String, dynamic> _getDefaultDarkColors() => {
    'primary': DarkColors.primary,
    'secondary': DarkColors.secondary,
    'accent': DarkColors.accent,
    'backgroundGradient': DarkColors.backgroundGradient,
    'text': DarkColors.text,
    'textSecondary': DarkColors.textSecondary,
    'glassBackground': DarkColors.glassBackground,
    'glassBorder': DarkColors.glassBorder,
  };
  
  Map<String, dynamic> _getDefaultLightColors() => {
    'primary': LightColors.primary,
    'secondary': LightColors.secondary,
    'accent': LightColors.accent,
    'backgroundGradient': LightColors.backgroundGradient,
    'text': LightColors.text,
    'textSecondary': LightColors.textSecondary,
    'glassBackground': LightColors.glassBackground,
    'glassBorder': LightColors.glassBorder,
  };
  
  Map<String, dynamic> _getNeonDreamsColors() => {
    'primary': NeonDreamsColors.primary,
    'secondary': NeonDreamsColors.secondary,
    'accent': NeonDreamsColors.accent,
    'backgroundGradient': NeonDreamsColors.backgroundGradient,
    'text': NeonDreamsColors.text,
    'textSecondary': NeonDreamsColors.textSecondary,
    'glassBackground': NeonDreamsColors.glassBackground,
    'glassBorder': NeonDreamsColors.glassBorder,
  };
  
  Map<String, dynamic> _getOceanBreezeColors() => {
    'primary': OceanBreezeColors.primary,
    'secondary': OceanBreezeColors.secondary,
    'accent': OceanBreezeColors.accent,
    'backgroundGradient': OceanBreezeColors.backgroundGradient,
    'text': OceanBreezeColors.text,
    'textSecondary': OceanBreezeColors.textSecondary,
    'glassBackground': OceanBreezeColors.glassBackground,
    'glassBorder': OceanBreezeColors.glassBorder,
  };
  
  Map<String, dynamic> _getSunsetGlowColors() => {
    'primary': SunsetGlowColors.primary,
    'secondary': SunsetGlowColors.secondary,
    'accent': SunsetGlowColors.accent,
    'backgroundGradient': SunsetGlowColors.backgroundGradient,
    'text': SunsetGlowColors.text,
    'textSecondary': SunsetGlowColors.textSecondary,
    'glassBackground': SunsetGlowColors.glassBackground,
    'glassBorder': SunsetGlowColors.glassBorder,
  };
  
  Map<String, dynamic> _getGalaxyStarsColors() => {
    'primary': GalaxyStarsColors.primary,
    'secondary': GalaxyStarsColors.secondary,
    'accent': GalaxyStarsColors.accent,
    'backgroundGradient': GalaxyStarsColors.backgroundGradient,
    'text': GalaxyStarsColors.text,
    'textSecondary': GalaxyStarsColors.textSecondary,
    'glassBackground': GalaxyStarsColors.glassBackground,
    'glassBorder': GalaxyStarsColors.glassBorder,
  };
  
  Map<String, dynamic> _getForestGreenColors() => {
    'primary': ForestGreenColors.primary,
    'secondary': ForestGreenColors.secondary,
    'accent': ForestGreenColors.accent,
    'backgroundGradient': ForestGreenColors.backgroundGradient,
    'text': ForestGreenColors.text,
    'textSecondary': ForestGreenColors.textSecondary,
    'glassBackground': ForestGreenColors.glassBackground,
    'glassBorder': ForestGreenColors.glassBorder,
  };
  
  Map<String, dynamic> _getRoyalPurpleColors() => {
    'primary': RoyalPurpleColors.primary,
    'secondary': RoyalPurpleColors.secondary,
    'accent': RoyalPurpleColors.accent,
    'backgroundGradient': RoyalPurpleColors.backgroundGradient,
    'text': RoyalPurpleColors.text,
    'textSecondary': RoyalPurpleColors.textSecondary,
    'glassBackground': RoyalPurpleColors.glassBackground,
    'glassBorder': RoyalPurpleColors.glassBorder,
  };
}
