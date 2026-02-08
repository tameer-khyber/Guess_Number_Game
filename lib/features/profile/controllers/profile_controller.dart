import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
  final RxString playerName = 'Guest'.obs;
  final RxString email = ''.obs;
  final RxInt level = 1.obs;
  final RxInt xp = 0.obs;
  final RxInt xpToNext = 1000.obs;
  
  // Stats
  final RxInt gamesPlayed = 0.obs;
  final RxInt gamesWon = 0.obs;
  final RxInt winRate = 0.obs;
  final RxInt bestStreak = 0.obs;
  final RxInt currentStreak = 0.obs;
  final RxInt totalScore = 0.obs;
  final RxString avgTime = '0s'.obs;
  final RxInt rank = 0.obs; // Rank is dynamic from LeaderboardController
  
  // Edit mode
  final RxBool isEditing = false.obs;
  final RxString editName = ''.obs;
  final RxString editEmail = ''.obs;
  
  // Modal states
  final RxBool showStatsModal = false.obs;
  final RxBool showLogoutConfirm = false.obs;
  
  // Achievements list
  final RxList<Achievement> achievements = <Achievement>[].obs;
  
  // Storage
  Box? _profileBox;

  @override
  void onInit() {
    super.onInit();
    _loadProfileData();
    editName.value = playerName.value;
    editEmail.value = email.value;
  }
  
  Future<void> _loadProfileData() async {
    _profileBox = await Hive.openBox('profile');
    
    playerName.value = _profileBox?.get('playerName', defaultValue: 'Guest');
    email.value = _profileBox?.get('email', defaultValue: '');
    level.value = _profileBox?.get('level', defaultValue: 1);
    xp.value = _profileBox?.get('xp', defaultValue: 0);
    xpToNext.value = _profileBox?.get('xpToNext', defaultValue: 1000);
    
    gamesPlayed.value = _profileBox?.get('gamesPlayed', defaultValue: 0);
    gamesWon.value = _profileBox?.get('gamesWon', defaultValue: 0);
    bestStreak.value = _profileBox?.get('bestStreak', defaultValue: 0);
    currentStreak.value = _profileBox?.get('currentStreak', defaultValue: 0);
    totalScore.value = _profileBox?.get('totalScore', defaultValue: 0);
    
    _calculateDerivedStats();
    _initializeAchievements();
  }
  
  void _calculateDerivedStats() {
    if (gamesPlayed.value > 0) {
      winRate.value = ((gamesWon.value / gamesPlayed.value) * 100).round();
    } else {
      winRate.value = 0;
    }
  }

  /// Update stats after a game
  void updateGameStats({required bool isWin, required int score, required int timeSeconds}) {
    gamesPlayed.value++;
    totalScore.value += score;
    xp.value += (score ~/ 10) + (isWin ? 50 : 10); // Basic XP formula
    
    if (isWin) {
      gamesWon.value++;
      currentStreak.value++;
      if (currentStreak.value > bestStreak.value) {
        bestStreak.value = currentStreak.value;
      }
    } else {
      currentStreak.value = 0;
    }
    
    // Check level up
    if (xp.value >= xpToNext.value) {
      level.value++;
      xp.value -= xpToNext.value;
      xpToNext.value = (xpToNext.value * 1.2).round();
    }
    
    _calculateDerivedStats();
    _saveProfileData();
  }
  
  void _saveProfileData() {
    _profileBox?.put('playerName', playerName.value);
    _profileBox?.put('email', email.value);
    _profileBox?.put('level', level.value);
    _profileBox?.put('xp', xp.value);
    _profileBox?.put('xpToNext', xpToNext.value);
    _profileBox?.put('gamesPlayed', gamesPlayed.value);
    _profileBox?.put('gamesWon', gamesWon.value);
    _profileBox?.put('bestStreak', bestStreak.value);
    _profileBox?.put('currentStreak', currentStreak.value);
    _profileBox?.put('totalScore', totalScore.value);
  }

  /// Initialize achievements
  void _initializeAchievements() {
    // Keep existing achievement definitions for now
    achievements.value = [
      Achievement(
        id: 1,
        icon: '🏆',
        title: 'First Victory',
        description: 'Win your first game',
        unlocked: gamesWon.value >= 1,
        rarity: AchievementRarity.common,
      ),
      Achievement(
        id: 2,
        icon: '🔥',
        title: 'On Fire',
        description: '10 win streak',
        unlocked: bestStreak.value >= 10,
        rarity: AchievementRarity.rare,
      ),
      // ... keep others locked for now or add logic
      Achievement(
        id: 3,
        icon: '⚡',
        title: 'Speed Demon',
        description: 'Win in under 10 seconds',
        unlocked: false, // Need to track best time
        rarity: AchievementRarity.epic,
      ),
      Achievement(
        id: 4,
        icon: '🎯',
        title: 'Perfect Guess',
        description: 'Guess correctly first try',
        unlocked: false, // Logic needed in controller
        rarity: AchievementRarity.rare,
      ),
      Achievement(
        id: 5,
        icon: '💎',
        title: 'Diamond Mind',
        description: 'Reach 50,000 points',
        unlocked: totalScore.value >= 50000,
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
      _saveProfileData();
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
