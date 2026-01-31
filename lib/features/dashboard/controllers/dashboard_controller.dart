import 'package:get/get.dart';
import '../../game/views/game_view.dart';
import '../../store/views/store_view.dart';

/// Controller for managing dashboard state and interactions
class DashboardController extends GetxController {
  // Player stats
  final RxString playerName = 'Player123'.obs;
  final RxInt playerLevel = 24.obs;
  final RxInt playerXP = 12450.obs;
  final RxInt currency = 2450.obs;
  
  // Stats
  final RxInt totalGames = 156.obs;
  final RxInt winRate = 89.obs;
  final RxInt playerRank = 42.obs;
  
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
