import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../controllers/settings_controller.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/themes/dark/dark_colors.dart';
import '../../../core/themes/light/light_colors.dart';
import '../../../core/themes/theme_controller.dart';

/// Settings view with all app configurations
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      body: Obx(() {
        final isDark = themeController.themeMode == ThemeMode.dark;

        return Stack(
          children: [
            // Background
            _buildBackground(isDark),

            // Main content
            Column(
              children: [
                // Header
                _buildHeader(controller, isDark),

                // Scrollable content
                Expanded(
                  child: _buildScrollableContent(controller, themeController, isDark),
                ),
              ],
            ),

            // Language Modal
            if (controller.showLanguageModal.value)
              _buildLanguageModal(controller, isDark),

            // Reset Confirmation
            if (controller.showResetConfirm.value)
              _buildResetConfirm(controller, isDark),
          ],
        );
      }),
    );
  }

  /// Build background
  Widget _buildBackground(bool isDark) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? DarkColors.backgroundGradient
              : LightColors.backgroundGradient,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -0.05.sh,
            right: -0.1.sw,
            child: Container(
              width: 288.w,
              height: 288.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? const Color(0xFF00E5FF).withOpacity(0.1)
                    : const Color(0xFF4CAF50).withOpacity(0.15),
              ),
            ),
          ),
          Positioned(
            bottom: 0.2.sh,
            left: -0.08.sw,
            child: Container(
              width: 224.w,
              height: 224.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? const Color(0xFF00E5FF).withOpacity(0.08)
                    : const Color(0xFF2196F3).withOpacity(0.12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build header
  Widget _buildHeader(SettingsController controller, bool isDark) {
    return Container(
      padding: EdgeInsets.only(top: 48.h, bottom: 16.h, left: 20.w, right: 20.w),
      decoration: BoxDecoration(
        color: (isDark
                ? DarkColors.glassBackground
                : LightColors.glassBackground)
            .withOpacity(0.95),
        border: Border(
          bottom: BorderSide(
            color: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => controller.goBack(),
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: isDark
                    ? DarkColors.glassBackground
                    : LightColors.glassBackground,
                border: Border.all(
                  color: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
                ),
              ),
              alignment: Alignment.center,
              child: Text('←', style: TextStyle(fontSize: 18.sp)),
            ),
          ),
          Text(
            'Settings',
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? DarkColors.text : LightColors.text,
            ),
          ),
          SizedBox(width: 40.w),
        ],
      ),
    );
  }

  /// Build scrollable content
  Widget _buildScrollableContent(
    SettingsController controller,
    ThemeController themeController,
    bool isDark,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          // Appearance Section
          _buildAppearanceSection(controller, themeController, isDark),
          SizedBox(height: 16.h),

          // Audio Section
          _buildAudioSection(controller, isDark),
          SizedBox(height: 16.h),

          // Gameplay Section
          _buildGameplaySection(controller, isDark),
          SizedBox(height: 16.h),

          // Notifications Section
          _buildNotificationsSection(controller, isDark),
          SizedBox(height: 16.h),

          // Performance Section
          _buildPerformanceSection(controller, isDark),
          SizedBox(height: 16.h),

          // Language Section
          _buildLanguageSection(controller, isDark),
          SizedBox(height: 16.h),

          // Danger Zone
          _buildDangerZone(controller, isDark),
          SizedBox(height: 16.h),

          // App Info
          _buildAppInfo(isDark),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  /// Build appearance section
  Widget _buildAppearanceSection(
    SettingsController controller,
    ThemeController themeController,
    bool isDark,
  ) {
    return GlassCard(
      borderRadius: 24.r,
      blurIntensity: 22.0,
      backgroundColor: isDark
          ? DarkColors.glassBackground.withOpacity(0.1)
          : LightColors.glassBackground.withOpacity(0.1),
      borderColor: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎨 Appearance',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),

          // Theme toggle
          Obx(() {
            return _buildToggleItem(
              isDark ? '🌙' : '☀️',
              'Theme',
              isDark ? 'Dark Mode' : 'Light Mode',
              isDark,
              () => themeController.toggleTheme(),
              themeController.themeMode == ThemeMode.dark,
            );
          }),

          SizedBox(height: 16.h),

          // Animations toggle
          Obx(() {
            return _buildToggleItem(
              '✨',
              'Animations',
              'UI transitions',
              isDark,
              () => controller.toggleSetting('animations'),
              controller.animations.value,
            );
          }),
        ],
      ),
    );
  }

  /// Build audio section
  Widget _buildAudioSection(SettingsController controller, bool isDark) {
    return GlassCard(
      borderRadius: 24.r,
      blurIntensity: 22.0,
      backgroundColor: isDark
          ? DarkColors.glassBackground.withOpacity(0.1)
          : LightColors.glassBackground.withOpacity(0.1),
      borderColor: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🔊 Audio',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),

          // Volume sliders
          Obx(() => _buildVolumeSlider(
                '🎚️',
                'Master Volume',
                controller.masterVolume.value,
                (value) => controller.updateVolume('master', value),
                isDark,
              )),
          SizedBox(height: 16.h),

          Obx(() => _buildVolumeSlider(
                '💥',
                'Sound Effects',
                controller.sfxVolume.value,
                (value) => controller.updateVolume('sfx', value),
                isDark,
              )),
          SizedBox(height: 16.h),

          Obx(() => _buildVolumeSlider(
                '🎵',
                'Music',
                controller.musicVolume.value,
                (value) => controller.updateVolume('music', value),
                isDark,
              )),
          SizedBox(height: 16.h),

          // Vibration toggle
          Obx(() {
            return _buildToggleItem(
              '📳',
              'Vibration',
              'Haptic feedback',
              isDark,
              () => controller.toggleSetting('vibration'),
              controller.vibration.value,
            );
          }),
        ],
      ),
    );
  }

  /// Build gameplay section
  Widget _buildGameplaySection(SettingsController controller, bool isDark) {
    return GlassCard(
      borderRadius: 24.r,
      blurIntensity: 22.0,
      backgroundColor: isDark
          ? DarkColors.glassBackground.withOpacity(0.1)
          : LightColors.glassBackground.withOpacity(0.1),
      borderColor: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎮 Gameplay',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),

          Obx(() {
            return _buildToggleItem(
              '💡',
              'Show Hints',
              'In-game tips',
              isDark,
              () => controller.toggleSetting('showHints'),
              controller.showHints.value,
            );
          }),

          SizedBox(height: 16.h),

          Obx(() {
            return _buildToggleItem(
              '💾',
              'Auto Save',
              'Save progress automatically',
              isDark,
              () => controller.toggleSetting('autoSave'),
              controller.autoSave.value,
            );
          }),
        ],
      ),
    );
  }

  /// Build notifications section
  Widget _buildNotificationsSection(SettingsController controller, bool isDark) {
    return GlassCard(
      borderRadius: 24.r,
      blurIntensity: 22.0,
      backgroundColor: isDark
          ? DarkColors.glassBackground.withOpacity(0.1)
          : LightColors.glassBackground.withOpacity(0.1),
      borderColor: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🔔 Notifications',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),

          Obx(() {
            return _buildToggleItem(
              '🔔',
              'Notifications',
              'All notifications',
              isDark,
              () => controller.toggleSetting('notifications'),
              controller.notifications.value,
            );
          }),

          SizedBox(height: 16.h),

          Obx(() {
            return _buildToggleItem(
              '📱',
              'Push Alerts',
              'Receive push messages',
              isDark,
              () => controller.toggleSetting('pushAlerts'),
              controller.pushAlerts.value,
            );
          }),
        ],
      ),
    );
  }

  /// Build performance section
  Widget _buildPerformanceSection(SettingsController controller, bool isDark) {
    return GlassCard(
      borderRadius: 24.r,
      blurIntensity: 22.0,
      backgroundColor: isDark
          ? DarkColors.glassBackground.withOpacity(0.1)
          : LightColors.glassBackground.withOpacity(0.1),
      borderColor: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '⚡ Performance',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),

          Obx(() {
            return _buildToggleItem(
              '🖼️',
              'High Quality',
              'Better graphics',
              isDark,
              () => controller.toggleSetting('highQuality'),
              controller.highQuality.value,
            );
          }),

          SizedBox(height: 16.h),

          Obx(() {
            return _buildToggleItem(
              '🔋',
              'Battery Saver',
              'Reduce power usage',
              isDark,
              () => controller.toggleSetting('batteryMode'),
              controller.batteryMode.value,
            );
          }),
        ],
      ),
    );
  }

  /// Build language section
  Widget _buildLanguageSection(SettingsController controller, bool isDark) {
    return GlassCard(
      borderRadius: 24.r,
      blurIntensity: 22.0,
      backgroundColor: isDark
          ? DarkColors.glassBackground.withOpacity(0.1)
          : LightColors.glassBackground.withOpacity(0.1),
      borderColor: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🌐 Language & Region',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),

          GestureDetector(
            onTap: () => controller.openLanguageModal(),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: (isDark ? DarkColors.accent : LightColors.accent).withOpacity(0.15),
              ),
              child: Row(
                children: [
                  Text('🌍', style: TextStyle(fontSize: 24.sp)),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Language',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? DarkColors.text : LightColors.text,
                          ),
                        ),
                        Obx(() {
                          return Text(
                            controller.selectedLanguage.value,
                            style: GoogleFonts.poppins(
                              fontSize: 10.sp,
                              color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  Text(
                    '›',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build danger zone
  Widget _buildDangerZone(SettingsController controller, bool isDark) {
    return GlassCard(
      borderRadius: 24.r,
      blurIntensity: 22.0,
      backgroundColor: const Color(0xFFF44336).withOpacity(0.1),
      borderColor: const Color(0xFFF44336).withOpacity(0.3),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '⚠️ Danger Zone',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF44336),
            ),
          ),
          SizedBox(height: 16.h),

          GestureDetector(
            onTap: () => controller.openResetConfirm(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: const Color(0xFFF44336).withOpacity(0.2),
                border: Border.all(
                  color: const Color(0xFFF44336).withOpacity(0.4),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '🗑️ Reset All Settings',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF44336),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build app info
  Widget _buildAppInfo(bool isDark) {
    return Column(
      children: [
        Text(
          'Game Hub v2.4.1',
          style: GoogleFonts.poppins(
            fontSize: 10.sp,
            color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
          ),
        ),
        Text(
          '© 2024 Game Hub Inc.',
          style: GoogleFonts.poppins(
            fontSize: 10.sp,
            color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Build toggle item
  Widget _buildToggleItem(
    String icon,
    String title,
    String description,
    bool isDark,
    VoidCallback onToggle,
    bool isOn,
  ) {
    return Row(
      children: [
        Text(icon, style: TextStyle(fontSize: 24.sp)),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? DarkColors.text : LightColors.text,
                ),
              ),
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 10.sp,
                  color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        _buildNeumorphicToggle(isOn, onToggle, isDark),
      ],
    );
  }

  /// Build neumorphic toggle
  Widget _buildNeumorphicToggle(bool isOn, VoidCallback onToggle, bool isDark) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 56.w,
        height: 32.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: isOn
              ? LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF00E5FF), const Color(0xFF00B8D4)]
                      : [const Color(0xFF4CAF50), const Color(0xFF66BB6A)],
                )
              : null,
          color: isOn
              ? null
              : isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.1),
          boxShadow: isOn
              ? [
                  BoxShadow(
                    color: isDark
                        ? DarkColors.accent.withOpacity(0.4)
                        : LightColors.primary.withOpacity(0.4),
                    blurRadius: 15,
                  ),
                ]
              : null,
        ),
        padding: EdgeInsets.all(4.w),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOn
                  ? Colors.white
                  : isDark
                      ? const Color(0xFF4A4A5A)
                      : const Color(0xFFCCCCCC),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build volume slider
  Widget _buildVolumeSlider(
    String icon,
    String label,
    double value,
    Function(double) onChanged,
    bool isDark,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(icon, style: TextStyle(fontSize: 16.sp)),
                SizedBox(width: 8.w),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: isDark ? DarkColors.text : LightColors.text,
                  ),
                ),
              ],
            ),
            Text(
              '${value.toInt()}%',
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? DarkColors.accent : LightColors.accent,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Stack(
          children: [
            Container(
              height: 8.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.1),
              ),
            ),
            FractionallySizedBox(
              widthFactor: value / 100,
              child: Container(
                height: 8.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF00E5FF), const Color(0xFF00B8D4)]
                        : [const Color(0xFF4CAF50), const Color(0xFF81C784)],
                  ),
                  boxShadow: isDark
                      ? [
                          BoxShadow(
                            color: DarkColors.accent.withOpacity(0.4),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
            Positioned.fill(
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 0,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
                ),
                child: Slider(
                  value: value,
                  min: 0,
                  max: 100,
                  onChanged: onChanged,
                  activeColor: Colors.transparent,
                  inactiveColor: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build language modal
  Widget _buildLanguageModal(SettingsController controller, bool isDark) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => controller.closeLanguageModal(),
        child: Container(
          color: Colors.black.withOpacity(0.6),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Center(
              child: GestureDetector(
                onTap: () {}, // Prevent close on modal tap
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.w),
                  constraints: BoxConstraints(
                    maxWidth: 400.w,
                    maxHeight: 0.7.sh,
                  ),
                  child: GlassCard(
                    borderRadius: 24.r,
                    blurIntensity: 30.0,
                    backgroundColor: isDark
                        ? const Color(0xFF12121F).withOpacity(0.95)
                        : Colors.white.withOpacity(0.95),
                    borderColor: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '🌍 Select Language',
                          style: GoogleFonts.poppins(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? DarkColors.text : LightColors.text,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        Flexible(
                          child: SingleChildScrollView(
                            child: Obx(() {
                              return Column(
                                children: controller.languages.map((lang) {
                                  final isSelected = controller.selectedLanguage.value == lang;
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 8.h),
                                    child: GestureDetector(
                                      onTap: () => controller.selectLanguage(lang),
                                      child: Container(
                                        padding: EdgeInsets.all(16.w),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16.r),
                                          color: isSelected
                                              ? (isDark ? DarkColors.accent : LightColors.accent).withOpacity(0.15)
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: isSelected
                                                ? (isDark ? DarkColors.accent : LightColors.accent)
                                                : (isDark ? DarkColors.glassBorder : LightColors.glassBorder),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              lang,
                                              style: GoogleFonts.poppins(
                                                fontSize: 14.sp,
                                                color: isDark ? DarkColors.text : LightColors.text,
                                              ),
                                            ),
                                            if (isSelected)
                                              Text(
                                                '✓',
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: isDark ? DarkColors.accent : LightColors.accent,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            }),
                          ),
                        ),

                        SizedBox(height: 16.h),

                        GestureDetector(
                          onTap: () => controller.closeLanguageModal(),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: isDark
                                  ? DarkColors.glassBackground
                                  : LightColors.glassBackground,
                              border: Border.all(
                                color: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build reset confirmation
  Widget _buildResetConfirm(SettingsController controller, bool isDark) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => controller.closeResetConfirm(),
        child: Container(
          color: Colors.black.withOpacity(0.6),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Center(
              child: GestureDetector(
                onTap: () {}, // Prevent close on modal tap
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.w),
                  constraints: BoxConstraints(maxWidth: 400.w),
                  child: GlassCard(
                    borderRadius: 24.r,
                    blurIntensity: 30.0,
                    backgroundColor: isDark
                        ? const Color(0xFF12121F).withOpacity(0.95)
                        : Colors.white.withOpacity(0.95),
                    borderColor: const Color(0xFFF44336).withOpacity(0.3),
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('⚠️', style: TextStyle(fontSize: 48.sp)),
                        SizedBox(height: 16.h),

                        Text(
                          'Reset Settings?',
                          style: GoogleFonts.poppins(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? DarkColors.text : LightColors.text,
                          ),
                        ),

                        SizedBox(height: 8.h),

                        Text(
                          'This will restore all settings to default. This action cannot be undone.',
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 16.h),

                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => controller.closeResetConfirm(),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    color: isDark
                                        ? DarkColors.glassBackground
                                        : LightColors.glassBackground,
                                    border: Border.all(
                                      color: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? DarkColors.text : LightColors.text,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => controller.resetAllSettings(),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFF44336), Color(0xFFE53935)],
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Reset',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
