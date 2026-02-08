import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../controllers/dashboard_controller.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/themes/dark/dark_colors.dart';
import '../../../core/themes/light/light_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../profile/views/profile_view.dart';
import '../../settings/views/settings_view.dart';

/// Dashboard view with player profile, stats, and menu
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      body: Obx(() {
        final isDark = themeController.themeMode == ThemeMode.dark;

        return Stack(
          children: [
            // Background with gradient and orbs
            _buildBackground(isDark),

            // Main scrollable content
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  children: [
                    SizedBox(height: 60.h), // Space for top badges

                    // Profile Avatar
                    _buildProfileAvatar(controller, isDark),

                    SizedBox(height: 24.h),

                    // Player Info
                    _buildPlayerInfo(controller, isDark),

                    SizedBox(height: 24.h),

                    // Stats Panel
                    _buildStatsPanel(controller, isDark),

                    SizedBox(height:20.h),

                    // Menu Panel
                    _buildMenuPanel(controller, isDark),

                    SizedBox(height: 24.h),

                    // Version Info
                    _buildVersionInfo(isDark),
                  ],
                ),
              ),
            ),

            // Top Badges (Currency & Theme Toggle)
            _buildTopBadges(controller, themeController, isDark),

            // Overlay modals
            if (controller.activeOverlay.value != null)
              _buildOverlay(controller, isDark),
          ],
        );
      }),
    );
  }

  /// Build background with gradient and animated orbs
  Widget _buildBackground(bool isDark) {
    return GetBuilder<ThemeController>(
      builder: (themeCtrl) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: themeCtrl.backgroundGradient,
            ),
          ),
          child: Stack(
            children: [
              // Orb 1
              Positioned(
                top: -0.1.sh,
                right: -0.15.sw,
                child: Container(
                  width: 320.w,
                  height: 320.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeCtrl.accent.withOpacity(0.12),
                    boxShadow: [
                      BoxShadow(
                        color: themeCtrl.accent.withOpacity(0.1),
                        blurRadius: 80,
                        spreadRadius: 30,
                      ),
                    ],
                  ),
                ),
              ),
              // Orb 2
              Positioned(
                bottom: 0.1.sh,
                left: -0.1.sw,
                child: Container(
                  width: 256.w,
                  height: 256.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeCtrl.secondary.withOpacity(0.08),
                    boxShadow: [
                      BoxShadow(
                        color: themeCtrl.secondary.withOpacity(0.08),
                        blurRadius: 70,
                        spreadRadius: 25,
                      ),
                    ],
                  ),
                ),
              ),
              // Orb 3
              Positioned(
                top: 0.4.sh,
                right: 0.1.sw,
                child: Container(
                  width: 192.w,
                  height: 192.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeCtrl.primary.withOpacity(0.06),
                    boxShadow: [
                      BoxShadow(
                        color: themeCtrl.primary.withOpacity(0.06),
                        blurRadius: 60,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build top badges (currency and theme toggle)
  Widget _buildTopBadges(
    DashboardController controller,
    ThemeController themeController,
    bool isDark,
  ) {
    return Positioned(
      top: 48.h,
      left: 20.w,
      right: 20.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Currency Badge
          Obx(() {
            return GlassCard(
              borderRadius: 24.r,
              blurIntensity: 20.0,
              backgroundColor: isDark
                  ? DarkColors.glassBackground.withOpacity(0.15)
                  : LightColors.glassBackground.withOpacity(0.15),
              borderGradient: isDark
                  ? LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.3),
                        Colors.white.withOpacity(0.1),
                      ],
                    )
                  : null,
              borderColor:
                  isDark ? null : LightColors.glassBorder.withOpacity(0.3),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? DarkColors.accent.withOpacity(0.2)
                      : Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                ),
              ],
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('💎', style: TextStyle(fontSize: 18.sp)),
                    SizedBox(width: 8.w),
                    Text(
                      '${controller.currency.value}',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? DarkColors.accent : LightColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          // Theme Toggle
          GestureDetector(
            onTap: () => themeController.toggleTheme(),
            child: GlassCard(
              borderRadius: 24.r,
              blurIntensity: 20.0,
              backgroundColor: isDark
                  ? DarkColors.glassBackground.withOpacity(0.15)
                  : LightColors.glassBackground.withOpacity(0.15),
              borderGradient: isDark
                  ? LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.3),
                        Colors.white.withOpacity(0.1),
                      ],
                    )
                  : null,
              borderColor:
                  isDark ? null : LightColors.glassBorder.withOpacity(0.3),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? DarkColors.accent.withOpacity(0.3)
                      : Colors.black.withOpacity(0.15),
                  blurRadius: 25,
                ),
              ],
              child: Container(
                width: 48.w,
                height: 48.h,
                alignment: Alignment.center,
                child: Text(
                  isDark ? '☀️' : '🌙',
                  style: TextStyle(fontSize: 20.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build profile avatar
  Widget _buildProfileAvatar(DashboardController controller, bool isDark) {
    return GlassCard(
      borderRadius: 24.r,
      blurIntensity: 25.0,
      backgroundColor: isDark
          ? DarkColors.glassBackground.withOpacity(0.12)
          : LightColors.glassBackground.withOpacity(0.12),
      borderGradient: LinearGradient(
        colors: isDark
            ? [
                DarkColors.accent.withOpacity(0.4),
                Colors.white.withOpacity(0.2),
                DarkColors.accent.withOpacity(0.4),
              ]
            : [
                LightColors.primary.withOpacity(0.4),
                Colors.white.withOpacity(0.6),
                LightColors.primary.withOpacity(0.4),
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? DarkColors.accent.withOpacity(0.3)
              : LightColors.primary.withOpacity(0.25),
          blurRadius: 40,
          spreadRadius: 6,
        ),
      ],
      child: Container(
        width: 96.w,
        height: 96.h,
        alignment: Alignment.center,
        child: Container(
          width: 56.w,
          height: 56.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [const Color(0xFF00E5FF), const Color(0xFF00B8D4)]
                  : [const Color(0xFF4CAF50), const Color(0xFF81C784)],
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? DarkColors.accent.withOpacity(0.5)
                    : LightColors.primary.withOpacity(0.4),
                blurRadius: 25,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text('🎮', style: TextStyle(fontSize: 28.sp)),
        ),
      ),
    );
  }

  /// Build player info section
  Widget _buildPlayerInfo(DashboardController controller, bool isDark) {
    return Obx(() {
      return Column(
        children: [
          Text(
            controller.playerName.value,
            style: GoogleFonts.poppins(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? DarkColors.text : LightColors.text,
              shadows: isDark
                  ? [
                      Shadow(
                        color: DarkColors.accent.withOpacity(0.3),
                        blurRadius: 30,
                      ),
                    ]
                  : null,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Level ${controller.playerLevel.value} • ${controller.playerXP.value} XP',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: isDark
                  ? DarkColors.textSecondary
                  : LightColors.textSecondary,
            ),
          ),
        ],
      );
    });
  }

  /// Build stats panel
  Widget _buildStatsPanel(DashboardController controller, bool isDark) {
    return Obx(() {
      return GlassCard(
        borderRadius: 24.r,
        blurIntensity: 22.0,
        backgroundColor: isDark
            ? DarkColors.glassBackground.withOpacity(0.1)
            : LightColors.glassBackground.withOpacity(0.1),
        borderGradient: LinearGradient(
          colors: isDark
              ? [
                  Colors.white.withOpacity(0.25),
                  Colors.white.withOpacity(0.08),
                ]
              : [
                  Colors.white.withOpacity(0.5),
                  Colors.white.withOpacity(0.2),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black38 : Colors.black.withOpacity(0.15),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
        padding: EdgeInsets.all(20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              '${controller.totalGames.value}',
              'Games',
              isDark ? DarkColors.accent : LightColors.accent,
              isDark,
            ),
            _buildStatItem(
              '${controller.winRate.value}%',
              'Win Rate',
              isDark ? const Color(0xFF00E5FF) : const Color(0xFF4CAF50),
              isDark,
            ),
            _buildStatItem(
              '#${controller.playerRank.value}',
              'Rank',
              isDark ? const Color(0xFF00E5FF) : const Color(0xFFFFC107),
              isDark,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatItem(String value, String label, Color color, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10.sp,
            color: isDark
                ? DarkColors.textSecondary
                : LightColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Build menu panel with play button and menu grid
  Widget _buildMenuPanel(DashboardController controller, bool isDark) {
    return GlassCard(
      borderRadius: 24.r,
      blurIntensity: 22.0,
      backgroundColor: isDark
          ? DarkColors.glassBackground.withOpacity(0.1)
          : LightColors.glassBackground.withOpacity(0.1),
      borderGradient: LinearGradient(
        colors: isDark
            ? [
                Colors.white.withOpacity(0.25),
                Colors.white.withOpacity(0.08),
              ]
            : [
                Colors.white.withOpacity(0.5),
                Colors.white.withOpacity(0.2),
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
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
          // Play Now Button
          _buildPlayButton(controller, isDark),

          SizedBox(height: 16.h),

          // Menu Grid
          _buildMenuGrid(controller, isDark),
        ],
      ),
    );
  }

  Widget _buildPlayButton(DashboardController controller, bool isDark) {
    return Obx(() {
      final isHovered = controller.hoveredButton.value == 'play';

      return GestureDetector(
        onTap: () => controller.handlePlay(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..scale(isHovered ? 1.02 : 1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF00E5FF), const Color(0xFF00B8D4)]
                  : [const Color(0xFF4CAF50), const Color(0xFF66BB6A)],
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? DarkColors.accent.withOpacity(isHovered ? 0.6 : 0.4)
                    : LightColors.primary.withOpacity(isHovered ? 0.5 : 0.3),
                blurRadius: isHovered ? 35 : 20,
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('▶️', style: TextStyle(fontSize: 22.sp)),
              SizedBox(width: 12.w),
              Text(
                'Play Now',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFF12121F) : Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMenuGrid(DashboardController controller, bool isDark) {
    final menuItems = [
      {'id': 'store', 'icon': '🛒', 'label': 'Store'},
      {'id': 'leaderboard', 'icon': '🏆', 'label': 'Leaderboard'},
      {'id': 'settings', 'icon': '⚙️', 'label': 'Settings'},
      {'id': 'rewards', 'icon': '🎁', 'label': 'Rewards'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.0,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return _buildMenuItem(
          controller,
          item['id']!,
          item['icon']!,
          item['label']!,
          isDark,
        );
      },
    );
  }

  Widget _buildMenuItem(
    DashboardController controller,
    String id,
    String icon,
    String label,
    bool isDark,
  ) {
    return Obx(() {
      final isHovered = controller.hoveredButton.value == id;

      return GestureDetector(
        onTap: () => controller.handleMenuPress(id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..scale(isHovered ? 1.03 : 1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: isHovered
                ? (isDark
                    ? DarkColors.accent.withOpacity(0.15)
                    : LightColors.primary.withOpacity(0.2))
                : Colors.transparent,
            border: Border.all(
              color: isHovered
                  ? (isDark ? DarkColors.accent : LightColors.accent)
                  : (isDark
                      ? DarkColors.glassBorder
                      : LightColors.glassBorder),
              width: 1.5,
            ),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: isDark
                          ? DarkColors.accent.withOpacity(0.2)
                          : LightColors.primary.withOpacity(0.2),
                      blurRadius: 20,
                    ),
                  ]
                : null,
          ),
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: TextStyle(fontSize: 32.sp)),
              SizedBox(height: 8.h),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? DarkColors.text : LightColors.text,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildVersionInfo(bool isDark) {
    return Text(
      'Version 2.4.1 • © 2024 Game Hub',
      style: GoogleFonts.poppins(
        fontSize: 10.sp,
        color:
            isDark ? DarkColors.textSecondary : LightColors.textSecondary,
      ),
    );
  }

  /// Build overlay modal
  Widget _buildOverlay(DashboardController controller, bool isDark) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => controller.closeOverlay(),
        child: Container(
          color: Colors.black.withOpacity(0.6),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Center(
              child: GestureDetector(
                onTap: () {}, // Prevent closing when tapping modal
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.w),
                  constraints: BoxConstraints(maxHeight: 0.8.sh),
                  child: GlassCard(
                    borderRadius: 24.r,
                    blurIntensity: 30.0,
                    backgroundColor: isDark
                        ? const Color(0xFF12121F).withOpacity(0.95)
                        : Colors.white.withOpacity(0.95),
                    borderGradient: LinearGradient(
                      colors: isDark
                          ? [
                              DarkColors.accent.withOpacity(0.3),
                              Colors.white.withOpacity(0.1),
                            ]
                          : [
                              Colors.white.withOpacity(0.5),
                              Colors.white.withOpacity(0.2),
                            ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? DarkColors.accent.withOpacity(0.2)
                            : Colors.black.withOpacity(0.2),
                        blurRadius: 50,
                      ),
                    ],
                    padding: EdgeInsets.all(24.w),
                    child: SingleChildScrollView(
                      child: Obx(() {
                        final overlayId = controller.activeOverlay.value;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Content based on overlay type
                            if (overlayId == 'play')
                              _buildPlayOverlayContent(controller, isDark)
                            else if (overlayId == 'store')
                              _buildStoreOverlayContent(controller, isDark)
                            else if (overlayId == 'leaderboard')
                              _buildLeaderboardOverlayContent(controller, isDark)
                            else if (overlayId == 'settings')
                              _buildSettingsOverlayContent(controller, isDark)
                            else if (overlayId == 'rewards')
                              _buildRewardsOverlayContent(controller, isDark),

                            SizedBox(height: 16.h),

                            // Close Button
                            GestureDetector(
                              onTap: () => controller.closeOverlay(),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  color: isDark
                                      ? DarkColors.glassBackground
                                      : LightColors.glassBackground,
                                  border: Border.all(
                                    color: isDark
                                        ? DarkColors.glassBorder
                                        : LightColors.glassBorder,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Close',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? DarkColors.textSecondary
                                        : LightColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
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

  // Placeholder overlay content methods (to be implemented)
  Widget _buildPlayOverlayContent(DashboardController controller, bool isDark) {
    return Text('Play Modes Coming Soon',
        style: TextStyle(color: isDark ? Colors.white : Colors.black));
  }

  Widget _buildStoreOverlayContent(DashboardController controller, bool isDark) {
    return Text('Store Coming Soon',
        style: TextStyle(color: isDark ? Colors.white : Colors.black));
  }

  Widget _buildLeaderboardOverlayContent(
      DashboardController controller, bool isDark) {
    return Text('Leaderboard Coming Soon',
        style: TextStyle(color: isDark ? Colors.white : Colors.black));
  }

  Widget _buildSettingsOverlayContent(
      DashboardController controller, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '⚙️ Settings',
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? DarkColors.text : LightColors.text,
          ),
        ),
        SizedBox(height: 24.h),
        
        // Profile Button
        GestureDetector(
          onTap: () {
            controller.closeOverlay();
            Get.to(
              () => const ProfileView(),
              transition: Transition.fadeIn,
              duration: const Duration(milliseconds: 400),
            );
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: (isDark ? DarkColors.accent : LightColors.accent).withOpacity(0.15),
              border: Border.all(
                color: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('👤', style: TextStyle(fontSize: 20.sp)),
                SizedBox(width: 8.w),
                Text(
                  'View Profile',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? DarkColors.text : LightColors.text,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 12.h),

        // Settings Button
        GestureDetector(
          onTap: () {
            controller.closeOverlay();
            Get.to(
              () => const SettingsView(),
              transition: Transition.fadeIn,
              duration: const Duration(milliseconds: 400),
            );
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF00E5FF), const Color(0xFF00B8D4)]
                    : [const Color(0xFF4CAF50), const Color(0xFF66BB6A)],
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('⚙️', style: TextStyle(fontSize: 20.sp)),
                SizedBox(width: 8.w),
                Text(
                  'App Settings',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFF12121F) : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRewardsOverlayContent(
      DashboardController controller, bool isDark) {
    return Text('Rewards Coming Soon',
        style: TextStyle(color: isDark ? Colors.white : Colors.black));
  }
}
