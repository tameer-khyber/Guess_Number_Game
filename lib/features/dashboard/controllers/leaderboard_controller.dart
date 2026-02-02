import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../profile/controllers/profile_controller.dart';

/// Model for leaderboard entry
class LeaderboardEntry {
  final String username;
  final int score;
  final int rank;
  final bool isCurrentUser;
  final String avatar;

  LeaderboardEntry({
    required this.username,
    required this.score,
    required this.rank,
    required this.isCurrentUser,
    required this.avatar,
  });
}

/// Controller for managing leaderboard logic
class LeaderboardController extends GetxController {
  // Observable leaderboard list
  final RxList<LeaderboardEntry> leaderboard = <LeaderboardEntry>[].obs;
  
  // User's best score
  final RxInt userBestScore = 0.obs;
  
  // Storage
  Box? _leaderboardBox;
  
  @override
  void onInit() {
    super.onInit();
    _loadData();
  }
  
  /// Load leaderboard data
  Future<void> _loadData() async {
    try {
      _leaderboardBox = await Hive.openBox('leaderboard');
      
      // Load user's best score
      userBestScore.value = _leaderboardBox?.get('userBestScore', defaultValue: 0) ?? 0;
      
      // Build leaderboard with mock data
      _buildLeaderboard();
    } catch (e) {
      // Use defaults
      _buildLeaderboard();
    }
  }
  
  /// Save user's best score
  Future<void> _saveUserScore() async {
    try {
      await _leaderboardBox?.put('userBestScore', userBestScore.value);
    } catch (e) {
      // Handle silently
    }
  }
  
  /// Build leaderboard with mock data and user
  void _buildLeaderboard() {
    // Mock leaderboard data (sorted by score descending)
    final mockPlayers = [
      {'username': 'ShadowNinja', 'score': 8500, 'avatar': '🥷'},
      {'username': 'MasterChief', 'score': 7800, 'avatar': '⚔️'},
      {'username': 'PhoenixRising', 'score': 7200, 'avatar': '🔥'},
      {'username': 'IceQueen', 'score': 6900, 'avatar': '👑'},
      {'username': 'ThunderBolt', 'score': 6500, 'avatar': '⚡'},
      {'username': 'DragonSlayer', 'score': 6000, 'avatar': '🐲'},
      {'username': 'StarGazer', 'score': 5500, 'avatar': '⭐'},
      {'username': 'NeonKnight', 'score': 5100, 'avatar': '🌟'},
      {'username': 'CyberPunk', 'score': 4800, 'avatar': '🤖'},
      {'username': 'MysticMage', 'score': 4500, 'avatar': '🧙'},
    ];
    
    // Get user's name from ProfileController or use default
    String userName = 'You';
    try {
      final profileController = Get.find<ProfileController>();
      userName = profileController.playerName.value;
    } catch (e) {
      // Profile controller not found, use default
    }
    
    // Combine mock players with user (if user has score)
    List<Map<String, dynamic>> allPlayers = List.from(mockPlayers);
    
    if (userBestScore.value > 0) {
      allPlayers.add({
        'username': userName,
        'score': userBestScore.value,
        'avatar': '🎮',
        'isUser': true,
      });
    }
    
    // Sort by score descending
    allPlayers.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
    
    // Take top 10
    allPlayers = allPlayers.take(10).toList();
    
    // Build leaderboard entries with ranks
    leaderboard.value = allPlayers.asMap().entries.map((entry) {
      final index = entry.key;
      final player = entry.value;
      
      return LeaderboardEntry(
        username: player['username'] as String,
        score: player['score'] as int,
        rank: index + 1,
        isCurrentUser: player['isUser'] == true,
        avatar: player['avatar'] as String,
      );
    }).toList();
  }
  
  /// Update user's score (called from game)
  void updateUserScore(int newScore) {
    if (newScore > userBestScore.value) {
      userBestScore.value = newScore;
      _saveUserScore();
      _buildLeaderboard();
    }
  }
  
  /// Navigate back
  void goBack() {
    Get.back();
  }
}
