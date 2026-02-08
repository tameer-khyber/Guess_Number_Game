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
  
  /// Time remaining until season ends
  RxString seasonTimeRemaining = ''.obs;

  /// Build leaderboard with mock data and user
  Future<void> _buildLeaderboard() async {
    _leaderboardBox ??= await Hive.openBox('leaderboard');
    
    final lastUpdateMillis = _leaderboardBox?.get('lastLeaderboardUpdate', defaultValue: 0) ?? 0;
    final seasonStartMillis = _leaderboardBox?.get('seasonStartDate', defaultValue: 0) ?? 0;
    
    DateTime lastUpdate = DateTime.fromMillisecondsSinceEpoch(lastUpdateMillis);
    DateTime seasonStart = DateTime.fromMillisecondsSinceEpoch(seasonStartMillis);
    final now = DateTime.now();

    // Initialize season start if not set
    if (seasonStartMillis == 0) {
      seasonStart = now;
      await _leaderboardBox?.put('seasonStartDate', now.millisecondsSinceEpoch);
    }
    
    // Calculate season end
    final seasonEnd = seasonStart.add(const Duration(days: 30));
    final daysLeft = seasonEnd.difference(now).inDays;
    seasonTimeRemaining.value = '$daysLeft days';

    List<Map<dynamic, dynamic>> mockPlayers = [];
    
    // 1. Check for Season Reset (30 days)
    if (now.difference(seasonStart).inDays >= 30) {
      // New Season! Reset everything
      mockPlayers = _generateMockPlayers();
      await _leaderboardBox?.put('mockPlayers', mockPlayers);
      await _leaderboardBox?.put('seasonStartDate', now.millisecondsSinceEpoch);
      await _leaderboardBox?.put('lastLeaderboardUpdate', now.millisecondsSinceEpoch);
      
      // Optional: Reset user's monthly score, distinct from all-time best
      // For now, we keep user's best score as is, or we could reset it too if that's desired behavior.
      // Let's assume user best score is permanent for now unless specified otherwise.
    } 
    // 2. Check for Daily Update (24 hours) - Fluctuation
    else if (now.difference(lastUpdate).inHours >= 24 || !_leaderboardBox!.containsKey('mockPlayers')) {
      if (_leaderboardBox!.containsKey('mockPlayers')) {
         // Load existing and fluctuate
         final storedList = _leaderboardBox?.get('mockPlayers');
         mockPlayers = List<Map<dynamic, dynamic>>.from(storedList);
         mockPlayers = _simulateDailyActivity(mockPlayers);
      } else {
         // No data, generate new
         mockPlayers = _generateMockPlayers();
      }
      
      await _leaderboardBox?.put('mockPlayers', mockPlayers);
      await _leaderboardBox?.put('lastLeaderboardUpdate', now.millisecondsSinceEpoch);
    } else {
      // Load existing mock players without change
      final storedList = _leaderboardBox?.get('mockPlayers');
      if (storedList != null) {
        mockPlayers = List<Map<dynamic, dynamic>>.from(storedList);
      } else {
        mockPlayers = _generateMockPlayers();
      }
    }
    
    // 3. Get user's name
    String userName = 'You';
    try {
      final profileController = Get.find<ProfileController>();
      userName = profileController.playerName.value;
    } catch (e) {
      // Profile controller not found
    }
    
    // 4. Combine mock players with user
    List<Map<String, dynamic>> allPlayers = [];
    
    // Convert hive data to typed map
    for (var player in mockPlayers) {
      allPlayers.add({
        'username': player['username'].toString(),
        'score': player['score'] as int,
        'avatar': player['avatar'].toString(),
        'isUser': false,
      });
    }
    
    // Add user if they have a score
    if (userBestScore.value > 0) {
      allPlayers.add({
        'username': userName,
        'score': userBestScore.value,
        'avatar': '🎮',
        'isUser': true,
      });
    }
    
    // 5. Sort by score descending
    allPlayers.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
    
    // 6. Assign ranks and build Entry objects
    List<LeaderboardEntry> entries = [];
    int userRank = 0;

    for (int i = 0; i < allPlayers.length; i++) {
        final player = allPlayers[i];
        final rank = i + 1;
        final isMe = player['isUser'] == true;

        if (isMe) {
          userRank = rank;
        }

        entries.add(LeaderboardEntry(
          username: player['username'] as String,
          score: player['score'] as int,
          rank: rank,
          isCurrentUser: isMe,
          avatar: player['avatar'] as String,
        ));
    }
    
    leaderboard.value = entries;
    
    // Update Profile Rank
    try {
      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().rank.value = userRank;
      }
    } catch (e) {
      // Ignore
    }
  }
  
  /// Simulate daily activity (fluctuate scores)
  List<Map<dynamic, dynamic>> _simulateDailyActivity(List<Map<dynamic, dynamic>> currentPlayers) {
    // Random is generic, better to use dart:math but avoiding imports if not needed, however
    // for fluctuation we need randomness.
    // Since we don't import dart:math at top, let's just use DateTime for pseudo-random or basic logic
    final now = DateTime.now().millisecondsSinceEpoch;
    
    List<Map<dynamic, dynamic>> updatedPlayers = [];
    
    for (int i = 0; i < currentPlayers.length; i++) {
      var player = Map<dynamic, dynamic>.from(currentPlayers[i]);
      int score = player['score'] as int;
      
      // Pseudo-random change based on index and time
      // Range: -500 to +800
      int change = (now % 1300) - 500; 
      // Add more variance based on index to avoid all players changing same amount
      change += (i * 17) % 300; 
      
      // Apply change
      score += change;
      if (score < 0) score = 0; // Prevent negative
      
      player['score'] = score;
      updatedPlayers.add(player);
    }
    
    return updatedPlayers;
  }

  /// Generate 50 mock players
  List<Map<String, dynamic>> _generateMockPlayers() {
     final List<String> avatars = ['🥷', '⚔️', '🔥', '👑', '⚡', '🐲', '⭐', '🌟', '🤖', '🧙', '🧟', '🧛', '🧚', '🧞', '🧜', '🦄'];
     final List<String> prefixes = ['Super', 'Mega', 'Hyper', 'Ultra', 'Shadow', 'Dark', 'Light', 'Cyber', 'Neon', 'Iron', 'Golden', 'Silver', 'Mystic', 'Cosmic'];
     final List<String> suffixes = ['Ninja', 'Warrior', 'Mage', 'Knight', 'King', 'Queen', 'Slayer', 'Master', 'Legend', 'Hero', 'Ghost', 'Phantom', 'Wolf', 'Eagle', 'Tiger'];
     
     List<Map<String, dynamic>> players = [];
     
     // Generate 50 players
     for (int i = 0; i < 50; i++) {
       final random = DateTime.now().microsecondsSinceEpoch + i;
       final prefix = prefixes[random % prefixes.length];
       final suffix = suffixes[(random + 5) % suffixes.length];
       final randomNum = random % 999;
       
       String name = '$prefix$suffix$randomNum';
       if (i < 10) name = '$prefix$suffix'; // McLeaner names for top
       
       // Score distribution
       int score;
       if (i < 5) {
         score = 10000 + (random % 2000); 
       } else if (i < 15) {
          score = 7000 + (random % 3000);
       } else {
          score = 2000 + (random % 5000);
       }

       players.add({
         'username': name,
         'score': score,
         'avatar': avatars[random % avatars.length],
         'isUser': false,
       });
     }
     return players;
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
