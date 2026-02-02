import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/themes/dark/dark_colors.dart';
import '../../../core/themes/light/light_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../controllers/rewards_controller.dart';

/// Rewards view with daily and weekly tabs
class RewardsView extends StatelessWidget {
  const RewardsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RewardsController());
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

                // Tabs
                _buildTabs(controller, isDark),

                // Content
                Expanded(
                  child: controller.selectedTab.value == 0
                      ? _buildDailyRewards(controller, isDark)
                      : _buildWeeklyMilestones(controller, isDark),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  /// Build background
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
              Positioned(
                top: -0.05.sh,
                right: -0.1.sw,
                child: Container(
                  width: 288.w,
                  height: 288.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeCtrl.accent.withOpacity(0.1),
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
                    color: themeCtrl.secondary.withOpacity(0.08),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build header
  Widget _buildHeader(RewardsController controller, bool isDark) {
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
            '🎁 Daily Rewards',
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

  /// Build tabs
  Widget _buildTabs(RewardsController controller, bool isDark) {
    return Obx(() {
      return Container(
        margin: EdgeInsets.all(20.w),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: isDark
              ? DarkColors.glassBackground
              : LightColors.glassBackground,
          border: Border.all(
            color: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildTabButton(
                controller,
                0,
                '📅 Daily',
                isDark,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: _buildTabButton(
                controller,
                1,
                '🏆 Weekly',
                isDark,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTabButton(
    RewardsController controller,
    int index,
    String label,
    bool isDark,
  ) {
    final isSelected = controller.selectedTab.value == index;

    return GestureDetector(
      onTap: () => controller.selectTab(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: isSelected
              ? LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF00E5FF), const Color(0xFF00B8D4)]
                      : [const Color(0xFF4CAF50), const Color(0xFF66BB6A)],
                )
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? (isDark ? const Color(0xFF12121F) : Colors.white)
                : isDark
                    ? DarkColors.text
                    : LightColors.text,
          ),
        ),
      ),
    );
  }

  /// Build daily rewards
  Widget _buildDailyRewards(RewardsController controller, bool isDark) {
    return Obx(() {
      return SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info card
            GlassCard(
              borderRadius: 16.r,
              backgroundColor: (isDark ? DarkColors.accent : LightColors.accent)
                  .withOpacity(0.1),
              borderColor: isDark ? DarkColors.accent : LightColors.accent,
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Text('ℹ️', style: TextStyle(fontSize: 24.sp)),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Claim rewards every 24 hours! Streak resets after 48 hours.',
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        color: isDark ? DarkColors.text : LightColors.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Daily rewards calendar
            ...List.generate(controller.dailyRewards.length, (index) {
              final reward = controller.dailyRewards[index];
              final isToday = index == controller.currentDayStreak.value;
              final isPast = index < controller.currentDayStreak.value;

              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                child: _buildRewardCard(
                  'Day ${index + 1}',
                  reward,
                  isToday,
                  isPast,
                  controller.canClaimDaily && isToday,
                  () => controller.claimDailyReward(),
                  controller.timeUntilDailyReset,
                  isDark,
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  /// Build weekly milestones
  Widget _buildWeeklyMilestones(RewardsController controller, bool isDark) {
    return Obx(() {
      return SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info card
            GlassCard(
              borderRadius: 16.r,
              backgroundColor: (isDark ? DarkColors.accent : LightColors.accent)
                  .withOpacity(0.1),
              borderColor: isDark ? DarkColors.accent : LightColors.accent,
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Text('ℹ️', style: TextStyle(fontSize: 24.sp)),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Complete weekly milestones for premium rewards!',
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        color: isDark ? DarkColors.text : LightColors.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Weekly milestones
            ...List.generate(controller.weeklyMilestones.length, (index) {
              final reward = controller.weeklyMilestones[index];
              final isCurrent = index == controller.currentWeekMilestone.value;
              final isPast = index < controller.currentWeekMilestone.value;

              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                child: _buildRewardCard(
                  'Week ${index + 1}',
                  reward,
                  isCurrent,
                  isPast,
                  controller.canClaimWeekly && isCurrent,
                  () => controller.claimWeeklyMilestone(),
                  controller.timeUntilWeeklyReset,
                  isDark,
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  /// Build reward card
  Widget _buildRewardCard(
    String title,
    dynamic reward,
    bool isCurrent,
    bool isClaimed,
    bool canClaim,
    VoidCallback onClaim,
    Duration timeUntilReset,
    bool isDark,
  ) {
    return GlassCard(
      borderRadius: 20.r,
      backgroundColor: isCurrent
          ? (isDark ? DarkColors.accent : LightColors.accent).withOpacity(0.15)
          : isDark
              ? DarkColors.glassBackground.withOpacity(0.1)
              : LightColors.glassBackground.withOpacity(0.1),
      borderColor: isCurrent
          ? (isDark ? DarkColors.accent : LightColors.accent)
          : isClaimed
              ? const Color(0xFF4CAF50)
              : isDark
                  ? DarkColors.glassBorder
                  : LightColors.glassBorder,
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          // Icon
          Container(
            width: 56.w,
            height: 56.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: isClaimed
                  ? const Color(0xFF4CAF50).withOpacity(0.2)
                  : (isDark ? DarkColors.accent : LightColors.accent)
                      .withOpacity(0.2),
            ),
            alignment: Alignment.center,
            child: Text(
              isClaimed ? '✅' : reward.icon,
              style: TextStyle(fontSize: 28.sp),
            ),
          ),

          SizedBox(width: 16.w),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? DarkColors.text : LightColors.text,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  reward.label,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Button
          if (isCurrent && !isClaimed)
            GestureDetector(
              onTap: canClaim ? onClaim : null,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  gradient: canClaim
                      ? LinearGradient(
                          colors: isDark
                              ? [const Color(0xFF00E5FF), const Color(0xFF00B8D4)]
                              : [const Color(0xFF4CAF50), const Color(0xFF66BB6A)],
                        )
                      : null,
                  color: canClaim
                      ? null
                      : Colors.grey.withOpacity(0.2),
                ),
                child: Text(
                  canClaim
                      ? 'Claim'
                      : '${timeUntilReset.inHours}h ${timeUntilReset.inMinutes % 60}m',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: canClaim
                        ? (isDark ? const Color(0xFF12121F) : Colors.white)
                        : Colors.grey,
                  ),
                ),
              ),
            )
          else if (isClaimed)
            Text(
              '✓',
              style: TextStyle(
                fontSize: 24.sp,
                color: const Color(0xFF4CAF50),
              ),
            ),
        ],
      ),
    );
  }
}
