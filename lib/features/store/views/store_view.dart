import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../controllers/store_controller.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/themes/dark/dark_colors.dart';
import '../../../core/themes/light/light_colors.dart';
import '../../../core/themes/theme_controller.dart';

/// Store view with premium glassmorphic items
class StoreView extends StatelessWidget {
  const StoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StoreController());
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      body: Obx(() {
        final isDark = themeController.themeMode == ThemeMode.dark;

        return Stack(
          children: [
            // Background
            _buildBackground(isDark),

            // Main content
            Column(
              children: [
                // Header
                _buildHeader(controller, themeController, isDark),

                // Category Selector
                _buildCategorySelector(controller, isDark),

                // Items Grid
                Expanded(
                  child: _buildItemsGrid(controller, isDark),
                ),
              ],
            ),

            // Item Detail Modal
            if (controller.showItemDetail.value && controller.selectedItem.value != null)
              _buildItemDetailModal(controller, isDark),

            // Purchase Success Modal
            if (controller.showPurchaseSuccess.value)
              _buildPurchaseSuccessModal(isDark),
          ],
        );
      }),
    );
  }

  /// Build background
  Widget _buildBackground(bool isDark) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? DarkColors.backgroundGradient
              : LightColors.backgroundGradient,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0.1.sh,
            right: -0.2.sw,
            child: Container(
              width: 300.w,
              height: 300.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? const Color(0xFF9C27B0).withOpacity(0.1)
                    : const Color(0xFFFF9800).withOpacity(0.15),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? const Color(0xFF9C27B0).withOpacity(0.05)
                        : const Color(0xFFFF9800).withOpacity(0.1),
                    blurRadius: 60,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -0.1.sh,
            left: -0.1.sw,
            child: Container(
              width: 250.w,
              height: 250.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? const Color(0xFF00E5FF).withOpacity(0.08)
                    : const Color(0xFF2196F3).withOpacity(0.12),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? const Color(0xFF00E5FF).withOpacity(0.05)
                        : const Color(0xFF2196F3).withOpacity(0.1),
                    blurRadius: 50,
                    spreadRadius: 15,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build header
  Widget _buildHeader(
    StoreController controller,
    ThemeController themeController,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.only(top: 48.h, bottom: 16.h, left: 20.w, right: 20.w),
      decoration: BoxDecoration(
        color: (isDark
                ? DarkColors.glassBackground
                : LightColors.glassBackground)
            .withOpacity(0.95),
        border: Border(
          bottom: BorderSide(
            color: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => controller.goBack(),
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: isDark
                    ? DarkColors.glassBackground
                    : LightColors.glassBackground,
                border: Border.all(
                  color: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
                ),
              ),
              alignment: Alignment.center,
              child: Text('←', style: TextStyle(fontSize: 18.sp)),
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            'Store',
            style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? DarkColors.text : LightColors.text,
            ),
          ),
          const Spacer(),
          
          // Balance pill
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: isDark
                  ? Colors.black.withOpacity(0.2)
                  : Colors.white.withOpacity(0.5),
              border: Border.all(
                color: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
              ),
            ),
            child: Row(
              children: [
                Text('💎', style: TextStyle(fontSize: 14.sp)),
                SizedBox(width: 6.w),
                Obx(() => Text(
                  '${controller.balance.value}',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? DarkColors.accent : LightColors.accent,
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build category selector
  Widget _buildCategorySelector(StoreController controller, bool isDark) {
    return Container(
      height: 60.h,
      margin: EdgeInsets.symmetric(vertical: 16.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: ItemCategory.values.length,
        itemBuilder: (context, index) {
          final category = ItemCategory.values[index];
          
          return Obx(() {
            final isSelected = controller.selectedCategory.value == category;
            
            return GestureDetector(
              onTap: () => controller.selectCategory(category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.only(right: 12.w),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r),
                  gradient: isSelected
                      ? LinearGradient(
                          colors: isDark
                              ? [const Color(0xFF00E5FF), const Color(0xFF00B8D4)]
                              : [const Color(0xFF4CAF50), const Color(0xFF66BB6A)],
                        )
                      : null,
                  color: isSelected
                      ? null
                      : (isDark
                          ? DarkColors.glassBackground
                          : LightColors.glassBackground),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : (isDark ? DarkColors.glassBorder : LightColors.glassBorder),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: isDark
                                ? DarkColors.accent.withOpacity(0.4)
                                : LightColors.primary.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text(
                      controller.getCategoryIcon(category),
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      controller.getCategoryName(category),
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? (isDark ? const Color(0xFF12121F) : Colors.white)
                            : (isDark ? DarkColors.text : LightColors.text),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  /// Build items grid
  Widget _buildItemsGrid(StoreController controller, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive grid count based on width
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        
        return Obx(() {
          final items = controller.filteredItems;
          
          return GridView.builder(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildItemCard(controller, item, isDark);
            },
          );
        });
      },
    );
  }

  /// Build individual item card
  Widget _buildItemCard(StoreController controller, StoreItem item, bool isDark) {
    return GestureDetector(
      onTap: () => controller.openItemDetail(item),
      child: GlassCard(
        borderRadius: 20.r,
        blurIntensity: 20.0,
        backgroundColor: isDark
            ? DarkColors.glassBackground.withOpacity(0.1)
            : LightColors.glassBackground.withOpacity(0.1),
        borderColor: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
        padding: EdgeInsets.all(12.w),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Icon
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.black.withOpacity(0.03),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      item.icon,
                      style: TextStyle(fontSize: 48.sp),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                
                // Item Name
                Text(
                  item.name,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? DarkColors.text : LightColors.text,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                
                // Item Price/Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (item.category == ItemCategory.currency)
                       Text(
                        'Real Money',
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          color: isDark ? Colors.greenAccent : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else if (item.isOwned)
                      Text(
                        'OWNED',
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      Row(
                        children: [
                          Text('💎', style: TextStyle(fontSize: 10.sp)),
                          SizedBox(width: 4.w),
                          Text(
                            '${item.price}',
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark ? DarkColors.accent : LightColors.accent,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
            
            // Badge (if exists)
            if (item.badge != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r),
                    ),
                    gradient: LinearGradient(
                      colors: item.badge == 'HOT' 
                          ? [Colors.orange, Colors.red]
                          : item.badge == 'NEW'
                              ? [Colors.lightBlue, Colors.blue]
                              : [Colors.purple, Colors.deepPurple],
                    ),
                  ),
                  child: Text(
                    item.badge!,
                    style: GoogleFonts.poppins(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build item detail modal
  Widget _buildItemDetailModal(StoreController controller, bool isDark) {
    final item = controller.selectedItem.value!;
    
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => controller.closeItemDetail(),
        child: Container(
          color: Colors.black.withOpacity(0.6),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Center(
              child: GestureDetector(
                onTap: () {}, // Prevent close when tapping modal
                child: Container(
                  margin: EdgeInsets.all(24.w),
                  constraints: BoxConstraints(maxWidth: 400.w, maxHeight: 0.8.sh),
                  child: GlassCard(
                    borderRadius: 24.r,
                    blurIntensity: 30.0,
                    backgroundColor: isDark
                        ? const Color(0xFF12121F).withOpacity(0.95)
                        : Colors.white.withOpacity(0.95),
                    borderColor: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? DarkColors.accent.withOpacity(0.3)
                            : Colors.black.withOpacity(0.2),
                        blurRadius: 50,
                      ),
                    ],
                    padding: EdgeInsets.all(24.w),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Large Icon
                          Container(
                            width: 120.w,
                            height: 120.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: isDark
                                    ? [DarkColors.glassBackground, DarkColors.accent.withOpacity(0.2)]
                                    : [LightColors.glassBackground, LightColors.primary.withOpacity(0.2)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? DarkColors.accent.withOpacity(0.2)
                                      : LightColors.primary.withOpacity(0.2),
                                  blurRadius: 30,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              item.icon,
                              style: TextStyle(fontSize: 64.sp),
                            ),
                          ),
                          SizedBox(height: 24.h),
                      
                          // Title & Badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? DarkColors.text : LightColors.text,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (item.isPremium) ...[
                                SizedBox(width: 8.w),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    color: Colors.amber,
                                  ),
                                  child: Text(
                                    'PREMIUM',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 12.h),
                      
                          // Description
                          Text(
                            item.description,
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 32.h),
                      
                          // Price
                          if (item.category != ItemCategory.currency && !item.isOwned)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Price: ', style: TextStyle(
                                  fontSize: 16.sp,
                                  color: isDark ? DarkColors.text : LightColors.text,
                                )),
                                Text('💎', style: TextStyle(fontSize: 18.sp)),
                                SizedBox(width: 4.w),
                                Text(
                                  '${item.price}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? DarkColors.accent : LightColors.accent,
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 32.h),
                      
                          // Buttons
                          if (item.isOwned)
                            Row(
                              children: [
                                Expanded(
                                  child: _buildModalButton(
                                    'Use',
                                    () => controller.useItem(item),
                                    isDark,
                                    isPrimary: true,
                                  ),
                                ),
                              ],
                            )
                          else
                            Row(
                              children: [
                                Expanded(
                                  child: _buildModalButton(
                                    'Share',
                                    () => controller.shareItem(item),
                                    isDark,
                                    isPrimary: false,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: _buildModalButton(
                                    'Buy',
                                    () => controller.purchaseItem(item),
                                    isDark,
                                    isPrimary: true,
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 16.h),
                          
                          GestureDetector(
                            onTap: () => controller.closeItemDetail(),
                            child: Text(
                              'Close',
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  /// Build purchase success modal
  Widget _buildPurchaseSuccessModal(bool isDark) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100.w,
                height: 100.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.check, color: Colors.white, size: 50),
              ),
              SizedBox(height: 24.h),
              Text(
                'Purchase Successful!',
                style: GoogleFonts.poppins(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper for modal buttons
  Widget _buildModalButton(
    String text,
    VoidCallback onTap,
    bool isDark, {
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: isPrimary
              ? LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF00E5FF), const Color(0xFF00B8D4)]
                      : [const Color(0xFF4CAF50), const Color(0xFF66BB6A)],
                )
              : null,
          color: isPrimary
              ? null
              : isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05),
          border: isPrimary
              ? null
              : Border.all(
                  color: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
                ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: isDark
                        ? DarkColors.accent.withOpacity(0.4)
                        : LightColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: isPrimary
                ? (isDark ? const Color(0xFF12121F) : Colors.white)
                : (isDark ? DarkColors.text : LightColors.text),
          ),
        ),
      ),
    );
  }
}
