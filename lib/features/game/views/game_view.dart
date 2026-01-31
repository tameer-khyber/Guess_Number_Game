import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../controllers/game_controller.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/themes/dark/dark_colors.dart';
import '../../../core/themes/light/light_colors.dart';
import '../../../core/themes/theme_controller.dart';

/// Main game view with number guessing gameplay
class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GameController());
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
                // HUD - Top Bar
                _buildHUD(controller, themeController, isDark),

                // Game Area
                Expanded(
                  child: _buildGameArea(controller, isDark),
                ),

                // Power-ups Bar
                _buildPowerUpsBar(controller, isDark),
              ],
            ),

            // Pause Menu Modal
            if (controller.showPauseMenu.value)
              _buildPauseMenu(controller, isDark),

            // Win Modal
            if (controller.showWinModal.value)
              _buildWinModal(controller, isDark),

            // Lose Modal
            if (controller.showLoseModal.value)
              _buildLoseModal(controller, isDark),
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
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? const Color(0xFF00E5FF).withOpacity(0.08)
                        : const Color(0xFF4CAF50).withOpacity(0.12),
                    blurRadius: 70,
                  ),
                ],
              ),
            ),
          ),
          // Orb 2
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
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? const Color(0xFF00E5FF).withOpacity(0.06)
                        : const Color(0xFF2196F3).withOpacity(0.1),
                    blurRadius: 60,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build HUD (top bar)
  Widget _buildHUD(
    GameController controller,
    ThemeController themeController,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.only(top: 48.h, bottom: 12.h, left: 16.w, right: 16.w),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top row: Pause, Score, Theme
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Pause Button
                _buildHUDButton(
                  '⏸️',
                  () => controller.togglePauseMenu(),
                  isDark,
                ),

                // Score
                Obx(() {
                  return GlassCard(
                    borderRadius: 16.r,
                    blurIntensity: 18.0,
                    backgroundColor: isDark
                        ? DarkColors.glassBackground
                        : LightColors.glassBackground,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('⭐', style: TextStyle(fontSize: 18.sp)),
                        SizedBox(width: 8.w),
                        Text(
                          '${controller.score.value}',
                          style: GoogleFonts.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? DarkColors.accent : LightColors.accent,
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                // Theme Toggle
                _buildHUDButton(
                  isDark ? '☀️' : '🌙',
                  () => themeController.toggleTheme(),
                  isDark,
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Second row: Lives, Timer, Streak
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Lives
                _buildLives(controller, isDark),

                // Timer
                _buildTimer(controller, isDark),

                // Streak
                _buildStreak(controller, isDark),
              ],
            ),
          ],
        ),
      );
    }

  Widget _buildHUDButton(String emoji, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
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
        child: Text(emoji, style: TextStyle(fontSize: 18.sp)),
      ),
    );
  }

  Widget _buildLives(GameController controller, bool isDark) {
    return Obx(() {
      return Row(
        children: List.generate(5, (index) {
          return Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: Text(
              '❤️',
              style: TextStyle(
                fontSize: 18.sp,
                color: index < controller.lives.value
                    ? null
                    : Colors.grey.withOpacity(0.3),
              ),
            ),
          );
        }),
      );
    });
  }

  Widget _buildTimer(GameController controller, bool isDark) {
    return Obx(() {
      final isLowTime = controller.timer.value <= 10;
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: isLowTime
              ? (isDark ? DarkColors.danger : LightColors.danger).withOpacity(0.2)
              : (isDark ? DarkColors.accent : LightColors.accent).withOpacity(0.15),
          border: Border.all(
            color: isLowTime
                ? (isDark ? DarkColors.danger : LightColors.danger)
                : (isDark ? DarkColors.glassBorder : LightColors.glassBorder),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('⏱️', style: TextStyle(fontSize: 12.sp)),
            SizedBox(width: 4.w),
            Text(
              '${controller.timer.value}s',
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: isLowTime
                    ? (isDark ? DarkColors.danger : LightColors.danger)
                    : (isDark ? DarkColors.text : LightColors.text),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStreak(GameController controller, bool isDark) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: (isDark ? DarkColors.accent : LightColors.accent).withOpacity(0.15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🔥', style: TextStyle(fontSize: 12.sp)),
            SizedBox(width: 4.w),
            Text(
              '${controller.streak.value}',
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? DarkColors.accent : LightColors.accent,
              ),
            ),
          ],
        ),
      );
    });
  }

  /// Build game area (display + number pad)
  Widget _buildGameArea(GameController controller, bool isDark) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        children: [
          // Title
          Text(
            'Guess the number between 1-99',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
            ),
          ),

          SizedBox(height: 16.h),

          // Main Display Panel
          _buildDisplayPanel(controller, isDark),

          SizedBox(height: 16.h),

          // Number Pad
          _buildNumberPad(controller, isDark),
        ],
      ),
    );
  }

  Widget _buildDisplayPanel(GameController controller, bool isDark) {
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
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          // Current Guess Display
          Obx(() {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 80.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
                border: Border.all(
                  color: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..scale(controller.isAnimating.value ? 1.02 : 1.0),
              child: Text(
                controller.currentGuess.value.isEmpty
                    ? '??'
                    : controller.currentGuess.value,
                style: GoogleFonts.poppins(
                  fontSize: 48.sp,
                  fontWeight: FontWeight.bold,
                  color: controller.currentGuess.value.isEmpty
                      ? (isDark ? DarkColors.textSecondary : LightColors.textSecondary)
                      : (isDark ? DarkColors.accent : LightColors.accent),
                  shadows: isDark && controller.currentGuess.value.isNotEmpty
                      ? [
                          Shadow(
                            color: DarkColors.accent.withOpacity(0.5),
                            blurRadius: 20,
                          ),
                        ]
                      : null,
                ),
              ),
            );
          }),

          // Hint Display
          Obx(() {
            if (controller.hint.value == null) return const SizedBox.shrink();

            return Container(
              margin: EdgeInsets.only(top: 16.h),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: _getHintColor(controller.hint.value!, isDark).withOpacity(0.15),
                border: Border.all(
                  color: _getHintColor(controller.hint.value!, isDark),
                ),
              ),
              child: Text(
                _getHintText(controller.hint.value!, controller.lastGuess.value),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: _getHintColor(controller.hint.value!, isDark),
                ),
              ),
            );
          }),

          SizedBox(height: 16.h),

          // Submit Button
          Obx(() {
            final hasGuess = controller.currentGuess.value.isNotEmpty;

            return GestureDetector(
              onTap: hasGuess ? () => controller.handleSubmitGuess() : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  gradient: hasGuess
                      ? LinearGradient(
                          colors: isDark
                              ? [const Color(0xFF00E5FF), const Color(0xFF00B8D4)]
                              : [const Color(0xFF4CAF50), const Color(0xFF66BB6A)],
                        )
                      : null,
                  color: hasGuess ? null : (isDark ? DarkColors.glassBackground : LightColors.glassBackground),
                  boxShadow: hasGuess
                      ? [
                          BoxShadow(
                            color: isDark
                                ? DarkColors.accent.withOpacity(0.4)
                                : LightColors.primary.withOpacity(0.3),
                            blurRadius: 25,
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  'Submit Guess',
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: hasGuess
                        ? (isDark ? const Color(0xFF12121F) : Colors.white)
                        : (isDark ? DarkColors.textSecondary : LightColors.textSecondary),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getHintColor(String hint, bool isDark) {
    if (hint == 'higher') return const Color(0xFF2196F3);
    if (hint == 'lower') return const Color(0xFFFF9800);
    return const Color(0xFF9C27B0);
  }

  String _getHintText(String hint, int? lastGuess) {
    if (hint == 'higher') return '⬆️ Go Higher! Last guess: $lastGuess';
    if (hint == 'lower') return '⬇️ Go Lower! Last guess: $lastGuess';
    if (hint.startsWith('range:')) {
      final range = hint.split(':')[1];
      return '💡 Number is in range: $range';
    }
    return '';
  }

  /// Build number pad
  Widget _buildNumberPad(GameController controller, bool isDark) {
    return GlassCard(
      borderRadius: 24.r,
      blurIntensity: 20.0,
      backgroundColor: isDark
          ? DarkColors.glassBackground.withOpacity(0.1)
          : LightColors.glassBackground.withOpacity(0.1),
      borderColor: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Numbers 1-9
          ...List.generate(3, (row) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: List.generate(3, (col) {
                  final num = row * 3 + col + 1;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: _buildNumberButton(
                        num.toString(),
                        () => controller.handleNumberInput(num.toString()),
                        isDark,
                      ),
                    ),
                  );
                }),
              ),
            );
          }),

          // Bottom row: CLR, 0, Backspace
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: _buildNumberButton(
                    'CLR',
                    () => controller.handleClear(),
                    isDark,
                    isSpecial: true,
                    isDanger: true,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: _buildNumberButton(
                    '0',
                    () => controller.handleNumberInput('0'),
                    isDark,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: _buildNumberButton(
                    '⌫',
                    () => controller.handleBackspace(),
                    isDark,
                    isSpecial: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(
    String text,
    VoidCallback onTap,
    bool isDark, {
    bool isSpecial = false,
    bool isDanger = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: isDanger
              ? (isDark ? DarkColors.danger : LightColors.danger).withOpacity(0.15)
              : (isDark ? DarkColors.accent : LightColors.accent).withOpacity(0.15),
          border: Border.all(
            color: isDanger
                ? (isDark ? DarkColors.danger : LightColors.danger)
                : (isDark ? DarkColors.glassBorder : LightColors.glassBorder),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: isSpecial ? 14.sp : 20.sp,
            fontWeight: FontWeight.bold,
            color: isDanger
                ? (isDark ? DarkColors.danger : LightColors.danger)
                : (isDark ? DarkColors.text : LightColors.text),
          ),
        ),
      ),
    );
  }

  /// Build power-ups bar
  Widget _buildPowerUpsBar(GameController controller, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: (isDark
                ? DarkColors.glassBackground
                : LightColors.glassBackground)
            .withOpacity(0.95),
        border: Border(
          top: BorderSide(
            color: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPowerUpButton(
            controller,
            '💡',
            'Hint',
            controller.hintPowerUps,
            () => controller.useHintPowerUp(),
            isDark,
          ),
          _buildPowerUpButton(
            controller,
            '❄️',
            '+15s',
            controller.freezePowerUps,
            () => controller.useFreezePowerUp(),
            isDark,
          ),
          _buildPowerUpButton(
            controller,
            '⏭️',
            'Skip',
            controller.skipPowerUps,
            () => controller.useSkipPowerUp(),
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildPowerUpButton(
    GameController controller,
    String icon,
    String label,
    RxInt count,
    VoidCallback onTap,
    bool isDark,
  ) {
    return Obx(() {
      final hasCount = count.value > 0;

      return GestureDetector(
        onTap: hasCount ? onTap : null,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: hasCount
                    ? (isDark ? DarkColors.accent : LightColors.accent).withOpacity(0.15)
                    : Colors.transparent,
                border: hasCount
                    ? Border.all(
                        color: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
                      )
                    : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    icon,
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: hasCount ? null : Colors.grey.withOpacity(0.4),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Count badge
            if (hasCount)
              Positioned(
                top: -4.h,
                right: -4.w,
                child: Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? DarkColors.accent : LightColors.accent,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${count.value}',
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? const Color(0xFF12121F) : Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  /// Build pause menu modal
  Widget _buildPauseMenu(GameController controller, bool isDark) {
    return _buildModalOverlay(
      isDark,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '⏸️ Paused',
              style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? DarkColors.text : LightColors.text,
              ),
            ),

            SizedBox(height: 24.h),

            // Buttons
            _buildModalButton(
              '▶️ Resume',
              () => controller.resumeGame(),
              isDark,
              isPrimary: true,
            ),

            SizedBox(height: 12.h),

            _buildModalButton(
              '🔄 New Game',
              () => controller.handleNewGame(),
              isDark,
            ),

            SizedBox(height: 12.h),

            _buildModalButton(
              '🏠 Main Menu',
              () => controller.returnToDashboard(),
              isDark,
            ),

            SizedBox(height: 24.h),

            // Stats
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: (isDark ? DarkColors.accent : LightColors.accent).withOpacity(0.15),
              ),
              child: Column(
                children: [
                  Text(
                    'Current Session',
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('${controller.score.value}', 'Score', isDark),
                      _buildStatItem('${controller.streak.value}', 'Streak', isDark),
                      _buildStatItem('${controller.lives.value}', 'Lives', isDark),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build win modal
  Widget _buildWinModal(GameController controller, bool isDark) {
    return _buildModalOverlay(
      isDark,
      child: GlassCard(
        borderRadius: 24.r,
        blurIntensity: 30.0,
        backgroundColor: isDark
            ? const Color(0xFF12121F).withOpacity(0.95)
            : Colors.white.withOpacity(0.95),
        borderGradient: LinearGradient(
          colors: [
            (isDark ? DarkColors.success : LightColors.success).withOpacity(0.5),
            (isDark ? DarkColors.accent : LightColors.accent).withOpacity(0.3),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? DarkColors.accent : LightColors.success).withOpacity(0.3),
            blurRadius: 60,
          ),
        ],
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🎉', style: TextStyle(fontSize: 64.sp)),

            SizedBox(height: 16.h),

            Text(
              'Correct!',
              style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? DarkColors.success : LightColors.success,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              'The number was ${controller.targetNumber.value}',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
              ),
            ),

            SizedBox(height: 24.h),

            // Rewards
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: (isDark ? DarkColors.accent : LightColors.accent).withOpacity(0.15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        '+100',
                        style: GoogleFonts.poppins(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? DarkColors.accent : LightColors.accent,
                        ),
                      ),
                      Text(
                        'Points',
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '🔥 ${controller.streak.value}',
                        style: GoogleFonts.poppins(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFC107),
                        ),
                      ),
                      Text(
                        'Streak',
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            _buildModalButton(
              'Next Round →',
              () => controller.handleNewGame(),
              isDark,
              isPrimary: true,
            ),
          ],
        ),
      ),
    );
  }

  /// Build lose modal
  Widget _buildLoseModal(GameController controller, bool isDark) {
    return _buildModalOverlay(
      isDark,
      child: GlassCard(
        borderRadius: 24.r,
        blurIntensity: 30.0,
        backgroundColor: isDark
            ? const Color(0xFF12121F).withOpacity(0.95)
            : Colors.white.withOpacity(0.95),
        borderGradient: LinearGradient(
          colors: [
            (isDark ? DarkColors.danger : LightColors.danger).withOpacity(0.4),
            Colors.white.withOpacity(0.2),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? DarkColors.danger : LightColors.danger).withOpacity(0.3),
            blurRadius: 60,
          ),
        ],
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('😢', style: TextStyle(fontSize: 64.sp)),

            SizedBox(height: 16.h),

            Text(
              'Game Over!',
              style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? DarkColors.danger : LightColors.danger,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              'The number was ${controller.targetNumber.value}',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
              ),
            ),

            SizedBox(height: 24.h),

            _buildModalButton(
              'Try Again',
              () => controller.handleNewGame(),
              isDark,
              isPrimary: true,
            ),

            SizedBox(height: 12.h),

            _buildModalButton(
              '🏠 Main Menu',
              () => controller.returnToDashboard(),
              isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModalOverlay(bool isDark, {required Widget child}) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {}, // Prevent closing by tapping outside
        child: Container(
          color: Colors.black.withOpacity(0.6),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                constraints: BoxConstraints(maxWidth: 400.w),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModalButton(
    String text,
    VoidCallback onTap,
    bool isDark, {
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: isPrimary
              ? LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF00E5FF), const Color(0xFF00B8D4)]
                      : [const Color(0xFF4CAF50), const Color(0xFF66BB6A)],
                )
              : null,
          color: isPrimary ? null : (isDark ? DarkColors.glassBackground : LightColors.glassBackground),
          border: isPrimary
              ? null
              : Border.all(
                  color: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
                ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: isDark
                        ? DarkColors.accent.withOpacity(0.4)
                        : LightColors.primary.withOpacity(0.3),
                    blurRadius: 25,
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: isPrimary
                ? (isDark ? const Color(0xFF12121F) : Colors.white)
                : (isDark ? DarkColors.text : LightColors.text),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? DarkColors.accent : LightColors.accent,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10.sp,
            color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
