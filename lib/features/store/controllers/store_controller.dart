import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/themes/theme_controller.dart';
import '../../game/controllers/game_controller.dart';
import '../../dashboard/controllers/rewards_controller.dart';

/// Item category enum
enum ItemCategory {
  powerups,
  themes,
  currency,
  special,
}

/// Store item model
class StoreItem {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int price;
  final ItemCategory category;
  final bool isPremium;
  final bool isOwned;
  final String? badge; // "HOT", "NEW", "SALE"

  StoreItem({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.price,
    required this.category,
    this.isPremium = false,
    this.isOwned = false,
    this.badge,
  });
}

/// Controller for managing store page logic
class StoreController extends GetxController {
  // User balance
  final RxInt balance = 0.obs;
  
  // Owned items (IDs of purchased items)
  final RxList<String> ownedItems = <String>[].obs;
  
  // Selected category
  final Rx<ItemCategory> selectedCategory = ItemCategory.powerups.obs;
  
  // Selected item for detail view
  final Rx<StoreItem?> selectedItem = Rx<StoreItem?>(null);
  
  // Modal states
  final RxBool showItemDetail = false.obs;
  final RxBool showPurchaseSuccess = false.obs;
  
  // Storage
  Box? _storeBox;
  
  @override
  void onInit() {
    super.onInit();
    _loadStoreData();
  }
  
  /// Load store data from Hive
  Future<void> _loadStoreData() async {
    try {
      _storeBox = await Hive.openBox('store');
      
      // Load balance (default 0 for first time)
      balance.value = _storeBox?.get('balance', defaultValue: 0) ?? 0;
      
      // Load owned items
      final List<dynamic>? owned = _storeBox?.get('ownedItems');
      if (owned != null) {
        ownedItems.value = owned.cast<String>();
      } else {
        // First time - add default owned themes (Light and Dark)
        ownedItems.value = ['light_theme', 'dark_theme'];
        await saveStoreData();
      }
    } catch (e) {
      // Handle error silently, use defaults
      ownedItems.value = ['light_theme', 'dark_theme'];
    }
  }
  
  /// Save store data to Hive
  Future<void> saveStoreData() async {
    try {
      await _storeBox?.put('balance', balance.value);
      await _storeBox?.put('ownedItems', ownedItems.toList());
    } catch (e) {
      // Handle error silently
    }
  }
  
  // Store items
  final RxList<StoreItem> items = <StoreItem>[
    // Power-ups
    StoreItem(
      id: 'hint_pack',
      name: 'Hint Pack',
      description: 'Get 5 hints to help you solve puzzles faster. Perfect for tricky levels!',
      icon: '💡',
      price: 100,
      category: ItemCategory.powerups,
      badge: 'HOT',
    ),
    StoreItem(
      id: 'time_freeze',
      name: 'Time Freeze',
      description: 'Stop the timer for 30 seconds. Use it when you need more time to think!',
      icon: '⏱️',
      price: 150,
      category: ItemCategory.powerups,
    ),
    StoreItem(
      id: 'get_life',
      name: 'Get Life',
      description: 'Add an extra heart to your lives. Keep playing longer!',
      icon: '❤️',
      price: 200,
      category: ItemCategory.powerups,
      badge: 'NEW',
    ),
    StoreItem(
      id: 'shield',
      name: 'Shield',
      description: 'Protect from one wrong guess. Your safety net!',
      icon: '🛡️',
      price: 250,
      category: ItemCategory.powerups,
      badge: 'HOT',
    ),
    
    // Themes - Default themes (Free)
    StoreItem(
      id: 'light_theme',
      name: 'Light Theme',
      description: 'Classic light color scheme. Clean and bright default theme.',
      icon: '☀️',
      price: 0,
      category: ItemCategory.themes,
      badge: 'DEFAULT',
    ),
    StoreItem(
      id: 'dark_theme',
      name: 'Dark Theme',
      description: 'Classic dark color scheme. Easy on the eyes default theme.',
      icon: '🌙',
      price: 0,
      category: ItemCategory.themes,
      badge: 'DEFAULT',
    ),
    
    // Premium Themes
    StoreItem(
      id: 'neon_theme',
      name: 'Neon Dreams',
      description: 'Vibrant neon colors with glowing effects. Stand out from the crowd!',
      icon: '🌈',
      price: 500,
      category: ItemCategory.themes,
      isPremium: true,
      badge: 'PREMIUM',
    ),
    StoreItem(
      id: 'ocean_theme',
      name: 'Ocean Breeze',
      description: 'Calm blue tones inspired by the ocean. Relaxing and beautiful.',
      icon: '🌊',
      price: 400,
      category: ItemCategory.themes,
    ),
    StoreItem(
      id: 'sunset_theme',
      name: 'Sunset Glow',
      description: 'Warm orange and pink gradients. Perfect for evening gaming.',
      icon: '🌅',
      price: 400,
      category: ItemCategory.themes,
    ),
    StoreItem(
      id: 'galaxy_theme',
      name: 'Galaxy Stars',
      description: 'Deep space theme with stars and nebulas. Out of this world!',
      icon: '🌌',
      price: 600,
      category: ItemCategory.themes,
      isPremium: true,
    ),
    StoreItem(
      id: 'forest_theme',
      name: 'Forest Green',
      description: 'Nature-inspired greens and earth tones. Fresh and calming.',
      icon: '🌲',
      price: 400,
      category: ItemCategory.themes,
    ),
    StoreItem(
      id: 'royal_theme',
      name: 'Royal Purple',
      description: 'Premium purple and gold accents. Luxurious and elegant.',
      icon: '👑',
      price: 600,
      category: ItemCategory.themes,
      isPremium: true,
      badge: 'NEW',
    ),
    
    // Currency
    StoreItem(
      id: 'starter_pack',
      name: 'Starter Pack',
      description: '100 diamonds | Perfect for beginners | \$0.99',
      icon: '💎',
      price: 0, // Real money item
      category: ItemCategory.currency,
    ),
    StoreItem(
      id: 'small_pack',
      name: 'Small Pack',
      description: '500 diamonds | +10% bonus | \$4.99',
      icon: '💎',
      price: 0,
      category: ItemCategory.currency,
      badge: 'SALE',
    ),
    StoreItem(
      id: 'medium_pack',
      name: 'Medium Pack',
      description: '1,200 diamonds | +20% bonus | \$9.99',
      icon: '💎',
      price: 0,
      category: ItemCategory.currency,
      badge: 'POPULAR',
    ),
    StoreItem(
      id: 'large_pack',
      name: 'Large Pack',
      description: '2,800 diamonds | +25% bonus | \$19.99',
      icon: '💎',
      price: 0,
      category: ItemCategory.currency,
    ),
    StoreItem(
      id: 'mega_pack',
      name: 'Mega Pack',
      description: '6,500 diamonds | +30% bonus | \$49.99',
      icon: '💎',
      price: 0,
      category: ItemCategory.currency,
      isPremium: true,
      badge: 'BEST VALUE',
    ),
    StoreItem(
      id: 'ultimate_pack',
      name: 'Ultimate Pack',
      description: '14,000 diamonds | +40% bonus | \$99.99',
      icon: '💎',
      price: 0,
      category: ItemCategory.currency,
      isPremium: true,
    ),
    StoreItem(
      id: 'treasure_chest',
      name: 'Treasure Chest',
      description: '30,000 diamonds | +50% bonus | Limited Time | \$199.99',
      icon: '💎',
      price: 0,
      category: ItemCategory.currency,
      isPremium: true,
      badge: 'LIMITED',
    ),
    
    // Special
    StoreItem(
      id: 'vip_pass',
      name: 'VIP Pass',
      description: 'Exclusive VIP status for 30 days. Get daily rewards, special badge, and more!',
      icon: '👑',
      price: 1000,
      category: ItemCategory.special,
      isPremium: true,
      badge: 'EXCLUSIVE',
    ),
    StoreItem(
      id: 'ad_free',
      name: 'Remove Ads',
      description: 'Remove all ads forever! Enjoy uninterrupted gaming experience.',
      icon: '🚫',
      price: 800,
      category: ItemCategory.special,
      isPremium: true,
    ),
  ].obs;
  
  /// Get filtered items by category with ownership status
  List<StoreItem> get filteredItems {
    return items
        .where((item) => item.category == selectedCategory.value)
        .map((item) => StoreItem(
              id: item.id,
              name: item.name,
              description: item.description,
              icon: item.icon,
              price: item.price,
              category: item.category,
              isPremium: item.isPremium,
              isOwned: ownedItems.contains(item.id),
              badge: item.badge,
            ))
        .toList();
  }
  
  /// Select category
  void selectCategory(ItemCategory category) {
    selectedCategory.value = category;
  }
  
  /// Open item detail
  void openItemDetail(StoreItem item) {
    selectedItem.value = item;
    showItemDetail.value = true;
  }
  
  /// Close item detail
  void closeItemDetail() {
    showItemDetail.value = false;
    selectedItem.value = null;
  }
  
  /// Purchase item
  void purchaseItem(StoreItem item) {
    // Currency items use real money (not implemented)
    if (item.category == ItemCategory.currency) {
      Get.snackbar(
        'Coming Soon',
        'In-app purchases will be available soon!',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    // Check if already owned
    if (item.isOwned) {
      Get.snackbar(
        'Already Owned',
        'You already own this item!',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    // Check balance
    if (balance.value < item.price) {
      Get.snackbar(
        'Insufficient Balance',
        'You need ${item.price - balance.value} more gems!',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    // Deduct balance
    balance.value -= item.price;
    
    // Add to owned items
    if (!ownedItems.contains(item.id)) {
      ownedItems.add(item.id);
    }
    
    // Save data to Hive
    saveStoreData();
    
    // Handle theme purchase - activate theme
    if (item.category == ItemCategory.themes) {
      try {
        final themeController = Get.find<ThemeController>();
        themeController.setTheme(item.id);
      } catch (e) {
        // ThemeController not found
      }
    }
    

    
    // Handle power-up purchases - increment inventory
    try {
      final rewardsController = Get.find<RewardsController>();
      if (item.id == 'hint_pack') {
        rewardsController.addPowerUp('hint', 5);
      } else if (item.id == 'time_freeze') {
        rewardsController.addPowerUp('freeze', 1);
      } else if (item.id == 'get_life') {
        rewardsController.addPowerUp('life', 1);
      }
    } catch (e) {
      // RewardsController not initialized yet
    }
    
    // Show success
    showPurchaseSuccess.value = true;
    closeItemDetail();
    
    Future.delayed(const Duration(seconds: 2), () {
      showPurchaseSuccess.value = false;
    });
    
    Get.snackbar(
      'Purchase Successful!',
      'You bought ${item.name} for ${item.price} diamonds',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  /// Use/Activate theme
  void useTheme(StoreItem item) {
    if (!ownedItems.contains(item.id)) {
      Get.snackbar(
        'Not Owned',
        'Purchase this theme first!',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    try {
      final themeController = Get.find<ThemeController>();
      
      // Handle Light/Dark theme switching (no variant)
      if (item.id == 'light_theme') {
        themeController.setThemeMode(ThemeMode.light);
        themeController.setTheme(null); // Clear variant
        Get.snackbar(
          'Theme Activated!',
          'Switched to Light Theme',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (item.id == 'dark_theme') {
        themeController.setThemeMode(ThemeMode.dark);
        themeController.setTheme(null); // Clear variant
        Get.snackbar(
          'Theme Activated!',
          'Switched to Dark Theme',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // Handle theme variants
        themeController.setTheme(item.id);
        Get.snackbar(
          'Theme Activated!',
          '${item.name} is now active',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      // ThemeController not found
    }
  }
  
  /// Use item (for power-ups)
  void useItem(StoreItem item) {
    if (!item.isOwned) {
      Get.snackbar(
        'Not Owned',
        'Purchase this item first!',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    closeItemDetail();
    Get.snackbar(
      'Item Used!',
      '${item.name} activated',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  /// Share item
  void shareItem(StoreItem item) {
    closeItemDetail();
    Get.snackbar(
      'Shared!',
      'Shared ${item.name} with friends',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  /// Navigate back
  void goBack() {
    Get.back();
  }
  
  /// Get category name
  String getCategoryName(ItemCategory category) {
    switch (category) {
      case ItemCategory.powerups:
        return 'Power-ups';
      case ItemCategory.themes:
        return 'Themes';
      case ItemCategory.currency:
        return 'Currency';
      case ItemCategory.special:
        return 'Special';
    }
  }
  
  /// Get category icon
  String getCategoryIcon(ItemCategory category) {
    switch (category) {
      case ItemCategory.powerups:
        return '⚡';
      case ItemCategory.themes:
        return '🎨';
      case ItemCategory.currency:
        return '💎';
      case ItemCategory.special:
        return '⭐';
    }
  }
}
