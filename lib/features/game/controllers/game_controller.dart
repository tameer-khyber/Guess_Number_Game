import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import '../../dashboard/controllers/leaderboard_controller.dart';
import '../../dashboard/controllers/rewards_controller.dart';
import '../../profile/controllers/profile_controller.dart';

/// Controller for managing number guessing game logic
class GameController extends GetxController {
  // Game state
  final RxInt score = 0.obs;
  final RxInt lives = 5.obs;
  final RxInt timer = 60.obs;
  final RxInt targetNumber = 0.obs;
  final RxString currentGuess = ''.obs;
  final Rx<String?> hint = Rx<String?>(null);
  final Rx<int?> lastGuess = Rx<int?>(null);
  final RxInt streak = 0.obs;
  final RxBool isAnimating = false.obs;
  
  // Modal states
  final RxBool showPauseMenu = false.obs;
  final RxBool showWinModal = false.obs;
  final RxBool showLoseModal = false.obs;
  
  
  Timer? _gameTimer;
  
  @override
  void onInit() {
    super.onInit();
    _generateNewTarget();
    _startTimer();
  }
  
  @override
  void onClose() {
    _gameTimer?.cancel();
    super.onClose();
  }


  
  /// Generate new random target number
  void _generateNewTarget() {
    targetNumber.value = Random().nextInt(99) + 1; // 1-99
  }
  
  /// Start game timer
  void _startTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (this.timer.value > 0 && !showPauseMenu.value && !showWinModal.value && !showLoseModal.value) {
        this.timer.value--;
        
        // Check if time's up
        if (this.timer.value == 0) {
          _handleTimeUp();
        }
      }
    });
  }
  
  /// Handle time up event
  void _handleTimeUp() {
    showLoseModal.value = true;
    _gameTimer?.cancel();
    
    // Update Profile Stats (Loss)
    try {
      final profileController = Get.find<ProfileController>();
      profileController.updateGameStats(
        isWin: false, 
        score: 0, 
        timeSeconds: 60
      );
      streak.value = 0;
    } catch (e) {
      print('Error updating profile: $e');
    }
  }
  
  /// Handle number input from number pad
  void handleNumberInput(String num) {
    if (currentGuess.value.length < 2) {
      currentGuess.value += num;
    }
  }
  
  /// Clear current guess
  void handleClear() {
    currentGuess.value = '';
  }
  
  /// Backspace (remove last digit)
  void handleBackspace() {
    if (currentGuess.value.isNotEmpty) {
      currentGuess.value = currentGuess.value.substring(0, currentGuess.value.length - 1);
    }
  }
  
  /// Submit guess
  void handleSubmitGuess() {
    if (currentGuess.value.isEmpty) return;
    
    final guess = int.parse(currentGuess.value);
    lastGuess.value = guess;
    
    // Trigger animation
    isAnimating.value = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      isAnimating.value = false;
    });
    
    if (guess == targetNumber.value) {
      // Correct guess!
      _handleCorrectGuess();
    } else if (guess < targetNumber.value) {
      // Too low
      hint.value = 'higher';
      _loseLife();
    } else {
      // Too high
      hint.value = 'lower';
      _loseLife();
    }
    
    currentGuess.value = '';
  }
  
  /// Handle correct guess
  void _handleCorrectGuess() {
    score.value += 100;
    streak.value++;
    showWinModal.value = true;
    
    // Update leaderboard with current score
    try {
      final leaderboardController = Get.find<LeaderboardController>();
      leaderboardController.refreshLeaderboard();
    } catch (e) {
      // Leaderboard controller not initialized yet
    }
    
    // Update Profile Stats
    try {
      final profileController = Get.find<ProfileController>();
      profileController.updateGameStats(
        isWin: true, 
        score: 100, // Points for this single game
        timeSeconds: 60 - timer.value
      );
      // Sync streak
      streak.value = profileController.currentStreak.value;
    } catch (e) {
      print('Error updating profile: $e');
    }
  }
  
  /// Lose a life
  void _loseLife() {
    lives.value--;
    if (lives.value <= 0) {
      showLoseModal.value = true;
      _gameTimer?.cancel();
      
      // Update Profile Stats (Loss)
      try {
        final profileController = Get.find<ProfileController>();
        profileController.updateGameStats(
          isWin: false, 
          score: 0, 
          timeSeconds: 60 - timer.value
        );
        streak.value = 0;
      } catch (e) {
        print('Error updating profile: $e');
      }
    }
  }
  
  /// Add a life (from power-up)
  void addLife() {
    lives.value++;
  }
  
  /// Use hint power-up
  void useHintPowerUp() {
    try {
      final rewardsController = Get.find<RewardsController>();
      if (rewardsController.usePowerUp('hint')) {
        // hintPowerUps.value = rewardsController.hintPowerUps.value;
        
        // Give range hint
        final range = targetNumber.value > 50 ? '51-99' : '1-50';
        hint.value = 'range:$range';
      }
    } catch (e) {
      // Controller not found
    }
  }
  
  /// Use freeze power-up (adds time)
  void useFreezePowerUp() {
    try {
      final rewardsController = Get.find<RewardsController>();
      if (rewardsController.usePowerUp('freeze')) {
        // freezePowerUps.value = rewardsController.freezePowerUps.value;
        timer.value += 15;
      }
    } catch (e) {
      // Controller not found
    }
  }
  
  /// Use Add Life power-up (replaces skip)
  void useAddLifePowerUp() {
    try {
      final rewardsController = Get.find<RewardsController>();
      if (rewardsController.usePowerUp('life')) {
         // lifePowerUps.value = rewardsController.lifePowerUps.value;
         lives.value++;
      }
    } catch (e) {
      // Fallback
    }
  }
  

  
  /// Toggle pause menu
  void togglePauseMenu() {
    showPauseMenu.value = !showPauseMenu.value;
  }
  
  /// Start new game
  void handleNewGame() {
    _generateNewTarget();
    score.value = 0;
    currentGuess.value = '';
    hint.value = null;
    lastGuess.value = null;
    lives.value = 5;
    timer.value = 60;
    showWinModal.value = false;
    showPauseMenu.value = false;
    showLoseModal.value = false;
    _startTimer();
  }
  
  /// Return to dashboard
  void returnToDashboard() {
    _gameTimer?.cancel();
    Get.back();
  }
  
  /// Resume game
  void resumeGame() {
    showPauseMenu.value = false;
  }
}
