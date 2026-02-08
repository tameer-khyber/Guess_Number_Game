import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../store/controllers/store_controller.dart';

/// Reward item model
class RewardItem {
  final String type; // 'diamonds', 'hint', 'freeze', 'life'
  final int quantity;
  final String icon;
  final String label;

  RewardItem({
    required this.type,
    required this.quantity,
    required this.icon,
    required this.label,
  });
}

/// Controller for managing daily and weekly rewards
class RewardsController extends GetxController {
  // Last claim timestamps
  final Rx<DateTime?> lastDailyClaim = Rx<DateTime?>(null);
  final Rx<DateTime?> lastWeeklyClaim = Rx<DateTime?>(null);
  
  // Current day in cycle (0-6)
  final RxInt currentDayStreak = 0.obs;
  
  // Current week milestone (0-6)
  final RxInt currentWeekMilestone = 0.obs;
  
  // Power-up inventory
  final RxInt hintPowerUps = 0.obs;
  final RxInt freezePowerUps = 0.obs;
  final RxInt lifePowerUps = 0.obs;
  
  // Tab index
  final RxInt selectedTab = 0.obs;
  
  // Storage
  Box? _rewardsBox;
  
  @override
  void onInit() {
    super.onInit();
    _loadData();
  }
  
  /// Load rewards data
  Future<void> _loadData() async {
    try {
      _rewardsBox = await Hive.openBox('rewards');
      
      // Load last claim times
      final dailyTimestamp = _rewardsBox?.get('lastDailyClaimTimestamp');
      if (dailyTimestamp != null) {
        lastDailyClaim.value = DateTime.fromMillisecondsSinceEpoch(dailyTimestamp);
      }
      
      final weeklyTimestamp = _rewardsBox?.get('lastWeeklyClaimTimestamp');
      if (weeklyTimestamp != null) {
        lastWeeklyClaim.value = DateTime.fromMillisecondsSinceEpoch(weeklyTimestamp);
      }
      
      // Load streaks
      currentDayStreak.value = _rewardsBox?.get('currentDayStreak', defaultValue: 0) ?? 0;
      currentWeekMilestone.value = _rewardsBox?.get('currentWeekMilestone', defaultValue: 0) ?? 0;
      
      // Load power-up inventory
      hintPowerUps.value = _rewardsBox?.get('hintPowerUps');
      freezePowerUps.value = _rewardsBox?.get('freezePowerUps');
      lifePowerUps.value = _rewardsBox?.get('lifePowerUps');

      // First run check - if null, set defaults
      if (hintPowerUps.value == null || freezePowerUps.value == null || lifePowerUps.value == null) {
        hintPowerUps.value = 2; // Default starting hints
        freezePowerUps.value = 1; // Default starting freezes
        lifePowerUps.value = 1; // Default starting lives
        _saveData();
      }
      
      // Check if streak should reset
      _checkDailyStreak();
    } catch (e) {
      // Use defaults
      print('Error loading rewards data: $e');
    }
  }
  
  /// Save rewards data
  Future<void> _saveData() async {
    try {
      await _rewardsBox?.put('lastDailyClaimTimestamp', lastDailyClaim.value?.millisecondsSinceEpoch);
      await _rewardsBox?.put('lastWeeklyClaimTimestamp', lastWeeklyClaim.value?.millisecondsSinceEpoch);
      await _rewardsBox?.put('currentDayStreak', currentDayStreak.value);
      await _rewardsBox?.put('currentWeekMilestone', currentWeekMilestone.value);
      await _rewardsBox?.put('hintPowerUps', hintPowerUps.value);
      await _rewardsBox?.put('freezePowerUps', freezePowerUps.value);
      await _rewardsBox?.put('lifePowerUps', lifePowerUps.value);
    } catch (e) {
      // Handle silently
    }
  }

  // ... (check daily streak unused methods omitted for brevity in search)

  // ...

  /// Add power-ups (called from store purchases)
  void addPowerUp(String type, int quantity) {
    switch (type) {
      case 'hint':
        hintPowerUps.value += quantity;
        break;
      case 'freeze':
        freezePowerUps.value += quantity;
        break;
      case 'life':
        lifePowerUps.value += quantity;
        break;
    }
    _saveData();
  }
  
  /// Check if daily streak should reset
  void _checkDailyStreak() {
    if (lastDailyClaim.value != null) {
      final now = DateTime.now();
      final difference = now.difference(lastDailyClaim.value!);
      
      // If more than 48 hours, reset streak
      if (difference.inHours >= 48) {
        currentDayStreak.value = 0;
        _saveData();
      }
    }
  }
  
  /// Get daily rewards structure
  List<RewardItem> get dailyRewards => [
    RewardItem(type: 'diamonds', quantity: 50, icon: '💎', label: '50 Diamonds'),
    RewardItem(type: 'hint', quantity: 1, icon: '💡', label: '1 Hint'),
    RewardItem(type: 'diamonds', quantity: 100, icon: '💎', label: '100 Diamonds'),
    RewardItem(type: 'freeze', quantity: 1, icon: '❄️', label: '1 Freeze'),
    RewardItem(type: 'diamonds', quantity: 150, icon: '💎', label: '150 Diamonds'),
    RewardItem(type: 'hint', quantity: 2, icon: '💡', label: '2 Hints'),
    RewardItem(type: 'diamonds', quantity: 500, icon: '💎', label: '500 Diamonds'),
  ];
  
  /// Get weekly milestones structure
  List<RewardItem> get weeklyMilestones => [
    RewardItem(type: 'hint', quantity: 2, icon: '💡', label: '2 Hints'),
    RewardItem(type: 'diamonds', quantity: 300, icon: '💎', label: '300 Diamonds'),
    RewardItem(type: 'freeze', quantity: 3, icon: '❄️', label: '3 Freeze'),
    RewardItem(type: 'diamonds', quantity: 500, icon: '💎', label: '500 Diamonds'),
    RewardItem(type: 'hint', quantity: 5, icon: '💡', label: '5 Hints'),
    RewardItem(type: 'mixed', quantity: 5, icon: '🎁', label: '5 Power-ups'),
    RewardItem(type: 'diamonds', quantity: 1000, icon: '💎', label: '1000 Diamonds'),
  ];

  // ... (keeping getters for canClaim etc) ...
  
  /// Can claim daily reward
  bool get canClaimDaily {
    if (lastDailyClaim.value == null) return true;
    
    final now = DateTime.now();
    final difference = now.difference(lastDailyClaim.value!);
    return difference.inHours >= 24;
  }
  
  /// Can claim weekly reward
  bool get canClaimWeekly {
    if (lastWeeklyClaim.value == null) return true;
    
    final now = DateTime.now();
    final difference = now.difference(lastWeeklyClaim.value!);
    return difference.inDays >= 7;
  }
  
  /// Time until next daily claim
  Duration get timeUntilDailyReset {
    if (lastDailyClaim.value == null) return Duration.zero;
    
    final nextClaim = lastDailyClaim.value!.add(const Duration(hours: 24));
    final now = DateTime.now();
    
    if (now.isAfter(nextClaim)) return Duration.zero;
    return nextClaim.difference(now);
  }
  
  /// Time until next weekly claim
  Duration get timeUntilWeeklyReset {
    if (lastWeeklyClaim.value == null) return Duration.zero;
    
    final nextClaim = lastWeeklyClaim.value!.add(const Duration(days: 7));
    final now = DateTime.now();
    
    if (now.isAfter(nextClaim)) return Duration.zero;
    return nextClaim.difference(now);
  }
  
  /// Claim daily reward
  void claimDailyReward() {
    if (!canClaimDaily) {
      Get.snackbar(
        'Too Soon!',
        'Come back in ${_formatDuration(timeUntilDailyReset)}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    final reward = dailyRewards[currentDayStreak.value];
    _giveReward(reward);
    
    lastDailyClaim.value = DateTime.now();
    currentDayStreak.value = (currentDayStreak.value + 1) % 7;
    _saveData();
    
    Get.snackbar(
      'Reward Claimed!',
      'You received ${reward.label}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  /// Claim weekly milestone
  void claimWeeklyMilestone() {
    if (!canClaimWeekly) {
      Get.snackbar(
        'Too Soon!',
        'Come back in ${_formatDuration(timeUntilWeeklyReset)}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    if (currentWeekMilestone.value >= weeklyMilestones.length) {
      Get.snackbar(
        'All Claimed!',
        'You\'ve claimed all weekly milestones',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    final reward = weeklyMilestones[currentWeekMilestone.value];
    _giveReward(reward);
    
    lastWeeklyClaim.value = DateTime.now();
    currentWeekMilestone.value++;
    _saveData();
    
    Get.snackbar(
      'Milestone Claimed!',
      'You received ${reward.label}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Give reward to player
  void _giveReward(RewardItem reward) {
    // Import StoreController for diamonds
    try {
      final storeController = Get.find<StoreController>();
      
      switch (reward.type) {
        case 'diamonds':
          storeController.balance.value += reward.quantity;
          storeController.saveStoreData();
          break;
        case 'hint':
          hintPowerUps.value += reward.quantity;
          break;
        case 'freeze':
          freezePowerUps.value += reward.quantity;
          break;
        case 'mixed':
          hintPowerUps.value += 3;
          freezePowerUps.value += 2;
          break;
      }
    } catch (e) {
      // Controllers not found
    }
  }
  

  
  /// Use power-up (called from game)
  bool usePowerUp(String type) {
    switch (type) {
      case 'hint':
        if (hintPowerUps.value > 0) {
          hintPowerUps.value--;
          _saveData();
          return true;
        }
        break;
      case 'freeze':
        if (freezePowerUps.value > 0) {
          freezePowerUps.value--;
          _saveData();
          return true;
        }
        break;
      case 'life':
        if (lifePowerUps.value > 0) {
          lifePowerUps.value--;
          _saveData();
          return true;
        }
        break;
    }
    return false;
  }
  
  /// Format duration
  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }
  
  /// Select tab
  void selectTab(int index) {
    selectedTab.value = index;
  }
  
  /// Navigate back
  void goBack() {
    Get.back();
  }
}
