import 'package:get/get.dart';

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
  final RxInt balance = 2500.obs;
  
  // Selected category
  final Rx<ItemCategory> selectedCategory = ItemCategory.powerups.obs;
  
  // Selected item for detail view
  final Rx<StoreItem?> selectedItem = Rx<StoreItem?>(null);
  
  // Modal states
  final RxBool showItemDetail = false.obs;
  final RxBool showPurchaseSuccess = false.obs;
  
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
      id: 'skip_level',
      name: 'Skip Level',
      description: 'Skip any level instantly. Great for when you\'re stuck!',
      icon: '⏭️',
      price: 200,
      category: ItemCategory.powerups,
    ),
    StoreItem(
      id: 'double_xp',
      name: 'Double XP',
      description: 'Earn 2x XP for the next 3 games. Level up faster!',
      icon: '⚡',
      price: 250,
      category: ItemCategory.powerups,
      badge: 'NEW',
    ),
    
    // Themes
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
    
    // Currency
    StoreItem(
      id: 'small_pack',
      name: 'Small Pack',
      description: '500 gems to spend in the store. Great starter pack!',
      icon: '💎',
      price: 0, // Real money item
      category: ItemCategory.currency,
      badge: 'SALE',
    ),
    StoreItem(
      id: 'medium_pack',
      name: 'Medium Pack',
      description: '1,200 gems with 20% bonus! Best value for regular players.',
      icon: '💎',
      price: 0,
      category: ItemCategory.currency,
      badge: 'POPULAR',
    ),
    StoreItem(
      id: 'large_pack',
      name: 'Large Pack',
      description: '2,500 gems with 25% bonus! For serious gamers.',
      icon: '💎',
      price: 0,
      category: ItemCategory.currency,
    ),
    StoreItem(
      id: 'mega_pack',
      name: 'Mega Pack',
      description: '5,000 gems with 30% bonus! Ultimate value pack!',
      icon: '💎',
      price: 0,
      category: ItemCategory.currency,
      isPremium: true,
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
  
  /// Get filtered items by category
  List<StoreItem> get filteredItems {
    return items.where((item) => item.category == selectedCategory.value).toList();
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
    
    // Show success
    showPurchaseSuccess.value = true;
    closeItemDetail();
    
    Future.delayed(const Duration(seconds: 2), () {
      showPurchaseSuccess.value = false;
    });
    
    Get.snackbar(
      'Purchase Successful!',
      'You bought ${item.name} for ${item.price} gems',
      snackPosition: SnackPosition.BOTTOM,
    );
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
