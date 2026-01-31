import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Controller for managing app theme (dark/light mode)
/// Follows GetX state management pattern and persists theme preference
class ThemeController extends GetxController {
  // Reactive theme mode
  final Rx<ThemeMode> _themeMode = ThemeMode.dark.obs;
  
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
      
      if (savedThemeMode == 'light') {
        _themeMode.value = ThemeMode.light;
      } else {
        _themeMode.value = ThemeMode.dark;
      }
    } catch (e) {
      // If error, default to dark mode
      _themeMode.value = ThemeMode.dark;
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
}
