import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/splash_controller.dart';
import '../widgets/animated_orb.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/themes/dark/dark_colors.dart';
import '../../../core/themes/light/light_colors.dart';
import '../../../core/themes/theme_controller.dart';

/// Splash screen with glassmorphism effects and loading animations
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Find controllers
    final controller = Get.find<SplashController>();
    final themeController = Get.find<ThemeController>();
    
    return Scaffold(
      body: Obx(() {
        // Access observable value directly for reactivity to work
        final isDark = themeController.themeMode == ThemeMode.dark;
        
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
              // Animated Background Orbs
              _buildAnimatedOrbs(isDark),
              
              // Theme Toggle Button
              _buildThemeToggle(themeController, isDark),
              
              // Main Content
              _buildMainContent(controller, isDark),
            ],
          ),
        );
      }),
    );
  }

  /// Build animated background orbs
  Widget _buildAnimatedOrbs(bool isDark) {
    return Stack(
      children: [
        AnimatedOrb(
          size: 320.w,
          color: isDark ? DarkColors.orb1 : LightColors.orb1,
          top: -0.1.sh,
          right: -0.15.sw,
          animationDelay: Duration.zero,
        ),
        AnimatedOrb(
          size: 256.w,
          color: isDark ? DarkColors.orb2 : LightColors.orb2,
          bottom: 0.1.sh,
          left: -0.1.sw,
          animationDelay: const Duration(seconds: 1),
        ),
        AnimatedOrb(
          size: 192.w,
          color: isDark ? DarkColors.orb3 : LightColors.orb3,
          top: 0.4.sh,
          right: 0.1.sw,
          animationDelay: const Duration(seconds: 2),
        ),
      ],
    );
  }

  /// Build theme toggle button
  Widget _buildThemeToggle(ThemeController themeController, bool isDark) {
    return Positioned(
      top: 48.h,
      right: 20.w,
      child: GestureDetector(
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
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderColor:
              isDark ? null : LightColors.glassBorder.withOpacity(0.3),
          boxShadow: isDark
              ? [
                  BoxShadow(
                    color: DarkColors.accent.withOpacity(0.3),
                    blurRadius: 25,
                    spreadRadius: 3,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 25,
                    spreadRadius: 3,
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
    );
  }

  /// Build main content area
  Widget _buildMainContent(SplashController controller, bool isDark) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Container
            _buildLogo(controller, isDark),
            
            SizedBox(height: 32.h),
            
            // App Title
            _buildTitle(controller, isDark),
            
            SizedBox(height: 32.h),
            
            // Loading Panel
            _buildLoadingPanel(controller, isDark),
            
            SizedBox(height: 32.h),
            
            // Version Info
            _buildVersionInfo(controller, isDark),
          ],
        ),
      ),
    );
  }

  /// Build animated logo
  Widget _buildLogo(SplashController controller, bool isDark) {
    return Obx(() {
      return AnimatedOpacity(
        opacity: controller.logoVisible.value ? 1.0 : 0.0,
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut,
        child: AnimatedScale(
          scale: controller.logoVisible.value ? 1.0 : 0.8,
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut,
          child: GlassCard(
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
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: DarkColors.accent.withOpacity(0.4),
                      blurRadius: 50,
                      spreadRadius: 8,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 40,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: LightColors.primary.withOpacity(0.3),
                      blurRadius: 40,
                      spreadRadius: 6,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 35,
                      offset: const Offset(0, 10),
                    ),
                  ],
            child: Container(
              width: 112.w,
              height: 112.h,
              alignment: Alignment.center,
              child: Container(
                width: 64.w,
                height: 64.h,
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
                      spreadRadius: 2,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  '🎮',
                  style: TextStyle(fontSize: 32.sp),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  /// Build app title and subtitle
  Widget _buildTitle(SplashController controller, bool isDark) {
    return Obx(() {
      return AnimatedOpacity(
        opacity: controller.logoVisible.value ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOut,
        child: AnimatedSlide(
          offset: controller.logoVisible.value
              ? Offset.zero
              : const Offset(0, 0.2),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOut,
          child: Column(
            children: [
              Text(
                'Game Hub',
                style: GoogleFonts.poppins(
                  fontSize: 32.sp,
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
              SizedBox(height: 8.h),
              Text(
                'Your Ultimate Gaming Experience',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: isDark
                      ? DarkColors.textSecondary
                      : LightColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// Build loading panel with progress
  Widget _buildLoadingPanel(SplashController controller, bool isDark) {
    return Obx(() {
      return AnimatedOpacity(
        opacity: controller.showContent.value ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 700),
        child: AnimatedSlide(
          offset: controller.showContent.value
              ? Offset.zero
              : const Offset(0, 0.3),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOut,
          child: GlassCard(
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
            boxShadow: isDark
                ? [
                    const BoxShadow(
                      color: Colors.black38,
                      blurRadius: 40,
                      offset: Offset(0, 12),
                    ),
                    BoxShadow(
                      color: DarkColors.accent.withOpacity(0.08),
                      blurRadius: 35,
                      spreadRadius: 6,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 40,
                      offset: const Offset(0, 12),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.6),
                      blurRadius: 35,
                      spreadRadius: 6,
                    ),
                  ],
            padding: EdgeInsets.all(24.w),
            child: controller.loadingComplete.value
                ? _buildCompleteState(controller, isDark)
                : _buildLoadingState(controller, isDark),
          ),
        ),
      );
    });
  }

  /// Build loading state UI
  Widget _buildLoadingState(SplashController controller, bool isDark) {
    return Column(
      children: [
        // Circular Progress Indicator
        SizedBox(
          width: 64.w,
          height: 64.h,
          child: Obx(() {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring
                SizedBox(
                  width: 64.w,
                  height: 64.h,
                  child: CircularProgressIndicator(
                    value: controller.loadingProgress.value / 100,
                    strokeWidth: 4,
                    backgroundColor: isDark
                        ? DarkColors.glassBorder
                        : LightColors.glassBorder,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDark ? DarkColors.accent : LightColors.accent,
                    ),
                  ),
                ),
                // Percentage text
                Text(
                  '${controller.loadingProgress.value.round()}%',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? DarkColors.accent : LightColors.accent,
                  ),
                ),
              ],
            );
          }),
        ),
        
        SizedBox(height: 24.h),
        
        // Progress Bar
        Obx(() {
          return Container(
            height: 8.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.1),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: controller.loadingProgress.value / 100,
              child: Container(
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
                            color: DarkColors.accent.withOpacity(0.5),
                            blurRadius: 15,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          );
        }),
        
        SizedBox(height: 16.h),
        
        // Loading text
        Text(
          'Loading game assets...',
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            color: isDark
                ? DarkColors.textSecondary
                : LightColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Build complete/ready state UI
  Widget _buildCompleteState(SplashController controller, bool isDark) {
    return Column(
      children: [
        // Success checkmark with bounce animation
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: _BounceAnimation(
            child: Container(
              width: 64.w,
              height: 64.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF00E5FF), const Color(0xFF00B8D4)]
                      : [const Color(0xFF4CAF50), const Color(0xFF66BB6A)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? DarkColors.accent.withOpacity(0.5)
                        : LightColors.primary.withOpacity(0.4),
                    blurRadius: 30,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),
        
        SizedBox(height: 16.h),
        
        Text(
          'Ready to Play!',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? DarkColors.text : LightColors.text,
          ),
        ),
        
        SizedBox(height: 16.h),
        
        // Continue Button
        GestureDetector(
          onTap: () => controller.continueToApp(),
          child: Container(
            width: double.infinity,
            height: 48.h,
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
                      : LightColors.primary.withOpacity(0.4),
                  blurRadius: 25,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              'Continue to Dashboard →',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFF12121F) : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build version info
  Widget _buildVersionInfo(SplashController controller, bool isDark) {
    return Obx(() {
      return AnimatedOpacity(
        opacity: controller.showContent.value ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 500),
        child: Text(
          'Version 2.4.1 • © 2024 Game Hub',
          style: GoogleFonts.poppins(
            fontSize: 10.sp,
            color: isDark
                ? DarkColors.textSecondary
                : LightColors.textSecondary,
          ),
        ),
      );
    });
  }
}

/// Continuous bounce animation widget
class _BounceAnimation extends StatefulWidget {
  final Widget child;
  
  const _BounceAnimation({required this.child});

  @override
  State<_BounceAnimation> createState() => _BounceAnimationState();
}

class _BounceAnimationState extends State<_BounceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -10.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -10.0, end: 0.0)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
