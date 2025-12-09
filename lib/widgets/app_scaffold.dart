import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_constants.dart';
import 'bottom_nav_bar.dart';
import 'hamburger_menu.dart';
import 'top_app_bar.dart';

/// AppScaffold - Single reusable scaffold widget with consistent design
/// Used by all screens to maintain uniform design (like Expo)
class AppScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final bool showBackButton;
  final bool showCart;
  final bool showGift;
  final bool showBottomNav;
  final int? currentTabIndex; // null = hide bottom nav
  final Function(int)? onTabTap;
  final Widget? floatingActionButton;
  final bool extendBodyBehindAppBar;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;
  final Widget? rightAction;
  final bool roundedCorners;

  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.showBackButton = false,
    this.showCart = false,
    this.showGift = false,
    this.showBottomNav = true,
    this.currentTabIndex,
    this.onTabTap,
    this.floatingActionButton,
    this.extendBodyBehindAppBar = false,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.rightAction,
    this.roundedCorners = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ??
        (isDark ? Color(AppColors.darkBackground) : Color(AppColors.background));

    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: bgColor,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: TopAppBar(
        title: title,
        showBackButton: showBackButton,
        showCart: showCart,
        showGift: showGift,
        rightAction: rightAction,
        roundedCorners: roundedCorners,
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        top: !extendBodyBehindAppBar,
        bottom: false,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: body,
        ),
      ),
      bottomNavigationBar: showBottomNav && currentTabIndex != null
          ? BottomNavBar(
              currentIndex: currentTabIndex!,
              onTap: onTabTap ?? (_) {},
            )
          : null,
      floatingActionButton: floatingActionButton,
    );
  }
}

/// Helper extension for easy navigation
extension AppScaffoldNavigation on BuildContext {
  void navigateToCart() {
    Navigator.pushNamed(this, '/cart');
  }

  void navigateToProductDetail({
    String? productId,
    String? title,
    String? price,
    dynamic image,
    String? category,
    String? location,
    String? startBid,
    String? currentBid,
    String? bidCount,
    String? sellerId,
    String? sellerName,
  }) {
    Navigator.pushNamed(
      this,
      '/product-detail',
      arguments: {
        'productId': productId,
        'title': title,
        'price': price,
        'image': image,
        'category': category,
        'location': location,
        'startBid': startBid,
        'currentBid': currentBid,
        'bidCount': bidCount,
        'sellerId': sellerId,
        'sellerName': sellerName,
      },
    );
  }

  void navigateToSearchResults({String? query}) {
    Navigator.pushNamed(
      this,
      '/search-results',
      arguments: {'query': query},
    );
  }
}

