import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../controllers/profile_controller.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/themes/dark/dark_colors.dart';
import '../../../core/themes/light/light_colors.dart';
import '../../../core/themes/theme_controller.dart';

/// Profile view with achievements and stats
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
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
                _buildHeader(controller, themeController, isDark),

                // Scrollable content
                Expanded(
                  child: _buildScrollableContent(controller, isDark),
                ),
              ],
            ),

            // Stats Modal
            if (controller.showStatsModal.value)
              _buildStatsModal(controller, isDark),

            // Logout Confirmation
            if (controller.showLogoutConfirm.value)
              _buildLogoutConfirm(controller, isDark),
          ],
        );
      }),
    );
  }

  /// Build background with gradient and orbs
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
          // Orb 1
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
          // Orb 2
          Positioned(
            bottom: 0.3.sh,
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
  Widget _buildHeader(
    ProfileController controller,
    ThemeController themeController,
    bool isDark,
  ) {
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
          // Back button
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

          // Title
          Text(
            'Profile',
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? DarkColors.text : LightColors.text,
            ),
          ),

          // Theme toggle
          GestureDetector(
            onTap: () => themeController.toggleTheme(),
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
              child: Text(
                isDark ? '☀️' : '🌙',
                style: TextStyle(fontSize: 18.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build scrollable content
  Widget _buildScrollableContent(ProfileController controller, bool isDark) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Card
          _buildProfileCard(controller, isDark),

          SizedBox(height: 20.h),

          // Quick Stats
          _buildQuickStats(controller, isDark),

          SizedBox(height: 20.h),

          // Achievements Section
          _buildAchievementsSection(controller, isDark),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  /// Build profile card
  Widget _buildProfileCard(ProfileController controller, bool isDark) {
    return Obx(() {
      return GlassCard(
        borderRadius: 24.r,
        blurIntensity: 22.0,
        backgroundColor: isDark
            ? DarkColors.glassBackground.withOpacity(0.1)
            : LightColors.glassBackground.withOpacity(0.1),
        borderColor: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black38 : Colors.black.withOpacity(0.15),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            // Avatar & Basic Info
            Row(
              children: [
                // Avatar
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    gradient: LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF00E5FF), const Color(0xFF00B8D4)]
                          : [const Color(0xFF4CAF50), const Color(0xFF81C784)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? DarkColors.accent.withOpacity(0.4)
                            : LightColors.primary.withOpacity(0.3),
                        blurRadius: 25,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text('🎮', style: TextStyle(fontSize: 36.sp)),
                ),

                SizedBox(width: 16.w),

                // Name & Email
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.isEditing.value)
                        TextField(
                          onChanged: (value) => controller.updateEditName(value),
                          controller: TextEditingController(text: controller.editName.value)
                            ..selection = TextSelection.collapsed(offset: controller.editName.value.length),
                          style: GoogleFonts.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? DarkColors.text : LightColors.text,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                            filled: true,
                            fillColor: isDark
                                ? Colors.black.withOpacity(0.3)
                                : Colors.white.withOpacity(0.5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: isDark ? DarkColors.accent : LightColors.accent,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: isDark ? DarkColors.accent : LightColors.accent,
                              ),
                            ),
                          ),
                        )
                      else
                        Text(
                          controller.playerName.value,
                          style: GoogleFonts.poppins(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? DarkColors.text : LightColors.text,
                          ),
                        ),
                      
                      SizedBox(height: 4.h),

                      if (controller.isEditing.value)
                        TextField(
                          onChanged: (value) => controller.updateEditEmail(value),
                          controller: TextEditingController(text: controller.editEmail.value)
                            ..selection = TextSelection.collapsed(offset: controller.editEmail.value.length),
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            filled: true,
                            fillColor: isDark
                                ? Colors.black.withOpacity(0.3)
                                : Colors.white.withOpacity(0.5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
                              ),
                            ),
                          ),
                        )
                      else
                        Text(
                          controller.email.value,
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Level Progress
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Level ${controller.level.value}',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? DarkColors.text : LightColors.text,
                      ),
                    ),
                    Text(
                      '${controller.xp.value} / ${controller.xpToNext.value} XP',
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    height: 12.h,
                    width: double.infinity,
                    color: isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.1),
                    child: FractionallySizedBox(
                      widthFactor: controller.xpProgress / 100,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? [const Color(0xFF00E5FF), const Color(0xFF00B8D4)]
                                : [const Color(0xFF4CAF50), const Color(0xFF81C784)],
                          ),
                          boxShadow: isDark
                              ? [
                                  BoxShadow(
                                    color: DarkColors.accent.withOpacity(0.5),
                                    blurRadius: 10,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    controller.isEditing.value ? '✓ Save' : '✏️ Edit',
                    () => controller.toggleEdit(),
                    isDark,
                    isPrimary: controller.isEditing.value,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildActionButton(
                    '📊 Stats',
                    () => controller.openStatsModal(),
                    isDark,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildActionButton(
                    '🚪 Logout',
                    () => controller.openLogoutConfirm(),
                    isDark,
                    isDanger: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildActionButton(
    String text,
    VoidCallback onTap,
    bool isDark, {
    bool isPrimary = false,
    bool isDanger = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: isPrimary
              ? LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF00E5FF), const Color(0xFF00B8D4)]
                      : [const Color(0xFF4CAF50), const Color(0xFF66BB6A)],
                )
              : null,
          color: isDanger
              ? const Color(0xFFF44336).withOpacity(0.15)
              : isPrimary
                  ? null
                  : (isDark ? DarkColors.accent : LightColors.accent).withOpacity(0.15),
          border: Border.all(
            color: isDanger
                ? const Color(0xFFF44336).withOpacity(0.3)
                : isPrimary
                    ? (isDark ? DarkColors.accent : LightColors.accent)
                    : (isDark ? DarkColors.glassBorder : LightColors.glassBorder),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: isDanger
                ? const Color(0xFFF44336)
                : isPrimary
                    ? (isDark ? const Color(0xFF12121F) : Colors.white)
                    : (isDark ? DarkColors.text : LightColors.text),
          ),
        ),
      ),
    );
  }

  /// Build quick stats
  Widget _buildQuickStats(ProfileController controller, bool isDark) {
    return Obx(() {
      final stats = [
        {'value': '${controller.gamesPlayed.value}', 'label': 'Played', 'icon': '🎮'},
        {'value': '${controller.winRate.value}%', 'label': 'Win Rate', 'icon': '📈'},
        {'value': '#${controller.rank.value}', 'label': 'Rank', 'icon': '🏅'},
        {'value': '${controller.bestStreak.value}', 'label': 'Best', 'icon': '🔥'},
      ];

      return Row(
        children: stats.map((stat) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: stats.last == stat ? 0 : 8.w),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: isDark
                    ? DarkColors.glassBackground
                    : LightColors.glassBackground,
                border: Border.all(
                  color: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
                ),
              ),
              child: Column(
                children: [
                  Text(stat['icon']!, style: TextStyle(fontSize: 18.sp)),
                  SizedBox(height: 4.h),
                  Text(
                    stat['value']!,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? DarkColors.accent : LightColors.accent,
                    ),
                  ),
                  Text(
                    stat['label']!,
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  /// Build achievements section
  Widget _buildAchievementsSection(ProfileController controller, bool isDark) {
    return Obx(() {
      return Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '🏆 Achievements',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? DarkColors.text : LightColors.text,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: (isDark ? DarkColors.accent : LightColors.accent).withOpacity(0.15),
                ),
                child: Text(
                  '${controller.unlockedCount} / ${controller.achievements.length}',
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? DarkColors.accent : LightColors.accent,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Achievement Cards
          ...controller.achievements.map((achievement) {
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: achievement.unlocked
                    ? _getRarityColor(achievement.rarity, isDark).withOpacity(0.2)
                    : isDark
                        ? DarkColors.glassBackground
                        : LightColors.glassBackground,
                border: Border.all(
                  color: achievement.unlocked
                      ? _getRarityBorderColor(achievement.rarity)
                      : isDark
                          ? DarkColors.glassBorder
                          : LightColors.glassBorder,
                ),
                boxShadow: achievement.unlocked && isDark
                    ? [
                        BoxShadow(
                          color: _getRarityColor(achievement.rarity, isDark).withOpacity(0.3),
                          blurRadius: 20,
                        ),
                      ]
                    : null,
              ),
              child: Opacity(
                opacity: achievement.unlocked ? 1.0 : 0.6,
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 56.w,
                      height: 56.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: achievement.unlocked
                            ? _getRarityColor(achievement.rarity, isDark).withOpacity(0.3)
                            : isDark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.black.withOpacity(0.05),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        achievement.unlocked ? achievement.icon : '🔒',
                        style: TextStyle(fontSize: 24.sp),
                      ),
                    ),

                    SizedBox(width: 16.w),

                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  achievement.title,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? DarkColors.text : LightColors.text,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: _getRarityColor(achievement.rarity, isDark).withOpacity(0.2),
                                ),
                                child: Text(
                                  achievement.rarity.name.toUpperCase(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.bold,
                                    color: _getRarityBorderColor(achievement.rarity),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            achievement.description,
                            style: GoogleFonts.poppins(
                              fontSize: 10.sp,
                              color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (achievement.unlocked)
                      Text('✅', style: TextStyle(fontSize: 20.sp)),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      );
    });
  }

  Color _getRarityColor(AchievementRarity rarity, bool isDark) {
    switch (rarity) {
      case AchievementRarity.common:
        return const Color(0xFF9E9E9E);
      case AchievementRarity.rare:
        return const Color(0xFF2196F3);
      case AchievementRarity.epic:
        return const Color(0xFF9C27B0);
      case AchievementRarity.legendary:
        return const Color(0xFFFFC107);
    }
  }

  Color _getRarityBorderColor(AchievementRarity rarity) {
    return _getRarityColor(rarity, false);
  }

  /// Build stats modal
  Widget _buildStatsModal(ProfileController controller, bool isDark) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => controller.closeStatsModal(),
        child: Container(
          color: Colors.black.withOpacity(0.6),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                constraints: BoxConstraints(
                  maxWidth: 400.w,
                  maxHeight: 0.8.sh, // Added max height
                ),
                child: GlassCard(
                  borderRadius: 24.r,
                  blurIntensity: 30.0,
                  backgroundColor: isDark
                      ? const Color(0xFF12121F).withOpacity(0.95)
                      : Colors.white.withOpacity(0.95),
                  borderColor: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? DarkColors.accent.withOpacity(0.2)
                          : Colors.black.withOpacity(0.2),
                      blurRadius: 50,
                    ),
                  ],
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      // Title
                      Text(
                        '📊 Detailed Stats',
                        style: GoogleFonts.poppins(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? DarkColors.text : LightColors.text,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Scrollable achievement list
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: controller.achievements.map((achievement) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 8.h),
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  color: (isDark ? DarkColors.accent : LightColors.accent).withOpacity(0.15),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Text(achievement.icon, style: TextStyle(fontSize: 16.sp)),
                                          SizedBox(width: 8.w),
                                          Expanded(
                                            child: Text(
                                              achievement.title,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12.sp,
                                                color: isDark ? DarkColors.text : LightColors.text,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      achievement.unlocked ? '✅' : '🔒',
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Close button
                      GestureDetector(
                        onTap: () => controller.closeStatsModal(),
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
                            'Close',
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
    );
  }

  /// Build logout confirmation
  Widget _buildLogoutConfirm(ProfileController controller, bool isDark) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => controller.closeLogoutConfirm(),
        child: Container(
          color: Colors.black.withOpacity(0.6),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                constraints: BoxConstraints(maxWidth: 400.w),
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
                      Text('👋', style: TextStyle(fontSize: 48.sp)),

                      SizedBox(height: 16.h),

                      Text(
                        'Logout?',
                        style: GoogleFonts.poppins(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? DarkColors.text : LightColors.text,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      Text(
                        'Are you sure you want to logout?',
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
                              onTap: () => controller.closeLogoutConfirm(),
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
                              onTap: () => controller.logout(),
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
                                  'Logout',
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
    );
  }
}
