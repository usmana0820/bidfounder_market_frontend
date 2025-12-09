import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../main.dart';
import 'cart_icon.dart';
import 'gift_icon.dart';
import 'hamburger_menu.dart';

/// TopAppBar - Reusable top navigation bar with title, hamburger menu, and optional actions
class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final bool showCart;
  final bool showGift;
  final Widget? rightAction;
  final VoidCallback? onBackPress;
  final bool roundedCorners;

  const TopAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.showCart = false,
    this.showGift = false,
    this.rightAction,
    this.onBackPress,
    this.roundedCorners = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(AppColors.primary);
    final secondaryColor = const Color(AppColors.secondary);
    final accentColor = const Color(AppColors.accent);

    // Gradient for top bar
    final topGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primaryColor,
        secondaryColor,
        accentColor,
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    return Container(
      decoration: BoxDecoration(
        gradient: topGradient,
        borderRadius: roundedCorners
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: roundedCorners
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )
            : BorderRadius.zero,
        child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                onPressed: onBackPress ?? () {
                  // Simply pop back - don't create new MainScreen instances
                  final navigator = Navigator.of(context);
                  if (navigator.canPop()) {
                    navigator.pop();
                  } else {
                    // If we can't pop and stack is empty, switch to previous bottom tab
                    MainScreen.switchToPreviousTab();
                  }
                },
              )
            : const HamburgerMenu(),
        title: Text(
          title ?? AppStrings.welcome,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (rightAction != null)
            rightAction!
          else ...[
            // Show Prizes icon whenever Cart is shown, or if explicitly requested
            if (showCart || showGift) const GiftIcon(),
            // Show Cart icon
            if (showCart) const CartIcon(),
          ],
        ],
      ),
      ),
    );
  }
}

