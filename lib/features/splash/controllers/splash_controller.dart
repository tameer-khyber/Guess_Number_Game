import 'package:get/get.dart';
import '../../dashboard/views/dashboard_view.dart';

/// Controller for managing splash screen logic and animations
class SplashController extends GetxController {
  // Reactive state variables
  final RxBool logoVisible = false.obs;
  final RxBool showContent = false.obs;
  final RxDouble loadingProgress = 0.0.obs;
  final RxBool loadingComplete = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _startAnimations();
  }
  
  /// Start the splash screen animations sequence
  void _startAnimations() async {
    // Show logo after 300ms
    await Future.delayed(const Duration(milliseconds: 300));
    logoVisible.value = true;
    
    // Show loading content after 800ms
    await Future.delayed(const Duration(milliseconds: 500));
    showContent.value = true;
    
    // Start loading progress
   _startLoadingProgress();
  }
  
  /// Simulate loading progress with random increments
  void _startLoadingProgress() async {
    while (loadingProgress.value < 100) {
      await Future.delayed(const Duration(milliseconds: 150));
      
      // Random increment between 2 and 10
      final increment = (2 + (8 * (DateTime.now().millisecond % 100) / 100)).toDouble();
      loadingProgress.value = (loadingProgress.value + increment).clamp(0, 100);
      
      if (loadingProgress.value >= 100) {
        // Wait a bit then mark as complete
        await Future.delayed(const Duration(milliseconds: 500));
        loadingComplete.value = true;
        break;
      }
    }
  }
  
  /// Navigate to the dashboard/home screen
  void continueToApp() {
    Get.off(
      () => const DashboardView(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 500),
    );
  }
}
