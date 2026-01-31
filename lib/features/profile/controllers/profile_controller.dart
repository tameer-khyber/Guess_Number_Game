import 'package:get/get.dart';

/// Model for achievement data
class Achievement {
  final int id;
  final String icon;
  final String title;
  final String description;
  final bool unlocked;
  final AchievementRarity rarity;

  Achievement({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    required this.unlocked,
    required this.rarity,
  });
}

/// Achievement rarity levels
enum AchievementRarity {
  common,
  rare,
  epic,
  legendary,
}

/// Controller for managing profile page logic
class ProfileController extends GetxController {
  // Profile data
  final RxString playerName = 'Player123'.obs;
  final RxString email = 'player123@game.com'.obs;
  final RxInt level = 24.obs;
  final RxInt xp = 12450.obs;
  final RxInt xpToNext = 15000.obs;
  
  // Edit mode
  final RxBool isEditing = false.obs;
  final RxString editName = ''.obs;
  final RxString editEmail = ''.obs;
  
  // Modal states
  final RxBool showStatsModal = false.obs;
  final RxBool showLogoutConfirm = false.obs;
  
  // Stats
  final RxInt gamesPlayed = 156.obs;
  final RxInt gamesWon = 139.obs;
  final RxInt winRate = 89.obs;
  final RxInt bestStreak = 15.obs;
  final RxInt totalScore = 12450.obs;
  final RxString avgTime = '23s'.obs;
  final RxInt rank = 42.obs;
  
  // Achievements list
  final RxList<Achievement> achievements = <Achievement>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    _initializeAchievements();
    editName.value = playerName.value;
    editEmail.value = email.value;
  }
  
  /// Initialize achievements
  void _initializeAchievements() {
    achievements.value = [
      Achievement(
        id: 1,
        icon: '🏆',
        title: 'First Victory',
        description: 'Win your first game',
        unlocked: true,
        rarity: AchievementRarity.common,
      ),
      Achievement(
        id: 2,
        icon: '🔥',
        title: 'On Fire',
        description: '10 win streak',
        unlocked: true,
        rarity: AchievementRarity.rare,
      ),
      Achievement(
        id: 3,
        icon: '⚡',
        title: 'Speed Demon',
        description: 'Win in under 10 seconds',
        unlocked: true,
        rarity: AchievementRarity.epic,
      ),
      Achievement(
        id: 4,
        icon: '🎯',
        title: 'Perfect Guess',
        description: 'Guess correctly first try',
        unlocked: true,
        rarity: AchievementRarity.rare,
      ),
      Achievement(
        id: 5,
        icon: '💎',
        title: 'Diamond Mind',
        description: 'Reach 50,000 points',
        unlocked: false,
        rarity: AchievementRarity.legendary,
      ),
      Achievement(
        id: 6,
        icon: '👑',
        title: 'Champion',
        description: 'Reach #1 on leaderboard',
        unlocked: false,
        rarity: AchievementRarity.legendary,
      ),
    ];
  }
  
  /// Get unlocked achievements count
  int get unlockedCount => achievements.where((a) => a.unlocked).length;
  
  /// Get XP progress percentage
  double get xpProgress => (xp.value / xpToNext.value) * 100;
  
  /// Toggle edit mode
  void toggleEdit() {
    if (isEditing.value) {
      // Save changes
      playerName.value = editName.value;
      email.value = editEmail.value;
    } else {
      // Enter edit mode - copy current values
      editName.value = playerName.value;
      editEmail.value = email.value;
    }
    isEditing.value = !isEditing.value;
  }
  
  /// Update edit name
  void updateEditName(String value) {
    editName.value = value;
  }
  
  /// Update edit email
  void updateEditEmail(String value) {
    editEmail.value = value;
  }
  
  /// Open stats modal
  void openStatsModal() {
    showStatsModal.value = true;
  }
  
  /// Close stats modal
  void closeStatsModal() {
    showStatsModal.value = false;
  }
  
  /// Open logout confirmation
  void openLogoutConfirm() {
    showLogoutConfirm.value = true;
  }
  
  /// Close logout confirmation
  void closeLogoutConfirm() {
    showLogoutConfirm.value = false;
  }
  
  /// Handle logout
  void logout() {
    closeLogoutConfirm();
    // Navigate back to login or dashboard
    Get.back();
    Get.snackbar(
      'Logged Out',
      'You have been logged out successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  /// Navigate back
  void goBack() {
    Get.back();
  }
}
