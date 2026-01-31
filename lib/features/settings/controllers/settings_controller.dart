import 'package:get/get.dart';

/// Controller for managing settings page logic
class SettingsController extends GetxController {
  // Appearance settings
  final RxBool animations = true.obs;
  
  // Audio settings
  final RxDouble masterVolume = 80.0.obs;
  final RxDouble sfxVolume = 70.0.obs;
  final RxDouble musicVolume = 60.0.obs;
  final RxBool vibration = true.obs;
  
  // Gameplay settings
  final RxBool showHints = true.obs;
  final RxBool autoSave = true.obs;
  
  // Notification settings
  final RxBool notifications = true.obs;
  final RxBool pushAlerts = false.obs;
  
  // Performance settings
  final RxBool highQuality = true.obs;
  final RxBool batteryMode = false.obs;
  
  // Language
  final RxString selectedLanguage = 'English'.obs;
  final List<String> languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Japanese',
    'Korean',
    'Chinese',
  ];
  
  // Modal states
  final RxBool showLanguageModal = false.obs;
  final RxBool showResetConfirm = false.obs;
  
  /// Toggle setting
  void toggleSetting(String key) {
    switch (key) {
      case 'animations':
        animations.value = !animations.value;
        break;
      case 'vibration':
        vibration.value = !vibration.value;
        break;
      case 'showHints':
        showHints.value = !showHints.value;
        break;
      case 'autoSave':
        autoSave.value = !autoSave.value;
        break;
      case 'notifications':
        notifications.value = !notifications.value;
        break;
      case 'pushAlerts':
        pushAlerts.value = !pushAlerts.value;
        break;
      case 'highQuality':
        highQuality.value = !highQuality.value;
        break;
      case 'batteryMode':
        batteryMode.value = !batteryMode.value;
        break;
    }
  }
  
  /// Update volume
  void updateVolume(String type, double value) {
    switch (type) {
      case 'master':
        masterVolume.value = value;
        break;
      case 'sfx':
        sfxVolume.value = value;
        break;
      case 'music':
        musicVolume.value = value;
        break;
    }
  }
  
  /// Open language modal
  void openLanguageModal() {
    showLanguageModal.value = true;
  }
  
  /// Close language modal
  void closeLanguageModal() {
    showLanguageModal.value = false;
  }
  
  /// Select language
  void selectLanguage(String language) {
    selectedLanguage.value = language;
    closeLanguageModal();
  }
  
  /// Open reset confirmation
  void openResetConfirm() {
    showResetConfirm.value = true;
  }
  
  /// Close reset confirmation
  void closeResetConfirm() {
    showResetConfirm.value = false;
  }
  
  /// Reset all settings
  void resetAllSettings() {
    // Reset to defaults
    animations.value = true;
    masterVolume.value = 80.0;
    sfxVolume.value = 70.0;
    musicVolume.value = 60.0;
    vibration.value = true;
    showHints.value = true;
    autoSave.value = true;
    notifications.value = true;
    pushAlerts.value = false;
    highQuality.value = true;
    batteryMode.value = false;
    selectedLanguage.value = 'English';
    
    closeResetConfirm();
    
    Get.snackbar(
      'Settings Reset',
      'All settings have been restored to default values',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  /// Navigate back
  void goBack() {
    Get.back();
  }
}
