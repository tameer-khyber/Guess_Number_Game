import 'package:get/get.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../game/views/game_view.dart';
import '../../store/views/store_view.dart';
import '../views/leaderboard_view.dart';
import '../views/rewards_view.dart';

/// Controller for managing dashboard state and interactions
class DashboardController extends GetxController {
  // Player stats
  // Player stats - from ProfileController
  RxString get playerName => Get.find<ProfileController>().playerName;
  RxInt get playerLevel => Get.find<ProfileController>().level;
  RxInt get playerXP => Get.find<ProfileController>().xp;
  
  // Currency is still managed here as source of truth for now, or could move to Profile
  // Keeping currency here as per previous strict instruction, but good to know
  final RxInt currency = 0.obs;
  
  // Stats - from ProfileController
  RxInt get totalGames => Get.find<ProfileController>().gamesPlayed;
  RxInt get winRate => Get.find<ProfileController>().winRate;
  RxInt get playerRank => Get.find<ProfileController>().rank;
  
  // Active overlay
  final Rx<String?> activeOverlay = Rx<String?>(null);
  
  // Hovered button
  final Rx<String?> hoveredButton = Rx<String?>(null);
  
  @override
  void onInit() {
    super.onInit();
    _loadPlayerData();
  }
  
  /// Load player data (could be from API or local storage)
  Future<void> _loadPlayerData() async {
    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 500));
    // Data is already initialized above
  }
  
  /// Open menu overlay
  void openOverlay(String overlayId) {
    activeOverlay.value = overlayId;
  }
  
  /// Close active overlay
  void closeOverlay() {
    activeOverlay.value = null;
  }
  
  /// Set hovered button
  void setHoveredButton(String? buttonId) {
    hoveredButton.value = buttonId;
  }
  
  /// Handle play button press - navigate directly to game
  void handlePlay() {
    Get.to(
      () => const GameView(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 400),
    );
  }
  
  /// Handle menu item press
  void handleMenuPress(String menuId) {
    if (menuId == 'play') {
      handlePlay();
    } else if (menuId == 'store') {
      Get.to(
        () => const StoreView(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 400),
      );
    } else if (menuId == 'leaderboard') {
      Get.to(
        () => const LeaderboardView(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 400),
      );
    } else if (menuId == 'rewards') {
      Get.to(
        () => const RewardsView(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 400),
      );
    } else {
      openOverlay(menuId);
    }
  }
  
  /// Select game mode - navigate to game
  void selectGameMode(String mode) {
    closeOverlay();
    Get.to(
      () => const GameView(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 400),
    );
  }
  
  /// Update currency
  void updateCurrency(int amount) {
    currency.value += amount;
  }
}
