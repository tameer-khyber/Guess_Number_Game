import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/themes/dark/dark_colors.dart';
import '../../../core/themes/light/light_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../controllers/leaderboard_controller.dart';

/// Leaderboard view showing top players
class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LeaderboardController());
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

                // Leaderboard List
                Expanded(
                  child: _buildLeaderboardList(controller, isDark),
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
  Widget _buildHeader(LeaderboardController controller, bool isDark) {
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
            '🏆 Leaderboard',
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

  /// Build leaderboard list
  Widget _buildLeaderboardList(LeaderboardController controller, bool isDark) {
    return Obx(() {
      if (controller.leaderboard.isEmpty) {
        return Center(
          child: Text(
            'No rankings yet',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
            ),
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.all(20.w),
        itemCount: controller.leaderboard.length,
        itemBuilder: (context, index) {
          final entry = controller.leaderboard[index];
          return _buildLeaderboardCard(entry, isDark);
        },
      );
    });
  }

  /// Build leaderboard card
  Widget _buildLeaderboardCard(dynamic entry, bool isDark) {
    final isTopThree = entry.rank <= 3;
    final isUser = entry.isCurrentUser;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: GlassCard(
        borderRadius: 20.r,
        blurIntensity: 18.0,
        backgroundColor: isUser
            ? (isDark ? DarkColors.accent : LightColors.accent).withOpacity(0.15)
            : isDark
                ? DarkColors.glassBackground.withOpacity(0.1)
                : LightColors.glassBackground.withOpacity(0.1),
        borderColor: isUser
            ? (isDark ? DarkColors.accent : LightColors.accent)
            : isTopThree
                ? _getRankColor(entry.rank)
                : isDark
                    ? DarkColors.glassBorder
                    : LightColors.glassBorder,
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            // Rank
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isTopThree
                    ? LinearGradient(
                        colors: [
                          _getRankColor(entry.rank),
                          _getRankColor(entry.rank).withOpacity(0.6),
                        ],
                      )
                    : null,
                color: isTopThree
                    ? null
                    : isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.05),
                boxShadow: isTopThree
                    ? [
                        BoxShadow(
                          color: _getRankColor(entry.rank).withOpacity(0.4),
                          blurRadius: 15,
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                entry.rank <= 3 ? _getRankEmoji(entry.rank) : '#${entry.rank}',
                style: GoogleFonts.poppins(
                  fontSize: isTopThree ? 20.sp : 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isTopThree
                      ? Colors.white
                      : isDark
                          ? DarkColors.text
                          : LightColors.text,
                ),
              ),
            ),

            SizedBox(width: 16.w),

            // Avatar
            Text(entry.avatar, style: TextStyle(fontSize: 32.sp)),

            SizedBox(width: 12.w),

            // Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.username,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: isUser ? FontWeight.bold : FontWeight.w600,
                      color: isDark ? DarkColors.text : LightColors.text,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isUser)
                    Text(
                      'You',
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        color: isDark ? DarkColors.accent : LightColors.accent,
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            // Score
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: (isDark ? DarkColors.accent : LightColors.accent)
                    .withOpacity(0.15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('⭐', style: TextStyle(fontSize: 14.sp)),
                  SizedBox(width: 4.w),
                  Text(
                    '${entry.score}',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? DarkColors.accent : LightColors.accent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.grey;
    }
  }

  String _getRankEmoji(int rank) {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '#$rank';
    }
  }
}
