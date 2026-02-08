import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/themes/theme_controller.dart';
import 'core/themes/light/light_theme.dart';
import 'core/themes/dark/dark_theme.dart';
import 'features/splash/controllers/splash_controller.dart';

import 'features/splash/views/splash_view.dart';
import 'features/dashboard/controllers/rewards_controller.dart';
import 'features/store/controllers/store_controller.dart';
import 'features/dashboard/controllers/leaderboard_controller.dart';
import 'features/profile/controllers/profile_controller.dart';
import 'features/dashboard/controllers/dashboard_controller.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // Initialize GetX controllers before app starts
  Get.put(ThemeController());
  Get.put(RewardsController());
  Get.put(ProfileController());
  Get.put(DashboardController());
  Get.put(StoreController());
  Get.put(LeaderboardController());
  Get.put(SplashController());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers are already initialized in main()
    final themeController = Get.find<ThemeController>();
    
    return ScreenUtilInit(
      // Base design size (standard mobile design)
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Obx(() {
          return GetMaterialApp(
            title: 'Game Hub',
            debugShowCheckedModeBanner: false,
            
            // Theme configuration
            theme: LightTheme.theme,
            darkTheme: DarkTheme.theme,
            themeMode: themeController.themeMode,
            
            // Initial route
            home: SplashView(),
            
            // GetX configuration
            enableLog: true,
            defaultTransition: Transition.fadeIn,
            transitionDuration: const Duration(milliseconds: 300),
          );
        });
      },
    );
  }
}
