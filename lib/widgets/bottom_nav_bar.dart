import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

/// Bottom Navigation Bar - Convex bottom bar with special center button and animations
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(AppColors.primary);
    final secondaryColor = const Color(AppColors.secondary);
    final accentColor = const Color(AppColors.accent);
    final activeColor = Colors.white;

    // Gradient for bottom bar
    final bottomGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primaryColor,
        secondaryColor,
        accentColor,
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    return ConvexAppBar.builder(
      itemBuilder: _SmallIconBuilder(
        primaryColor: primaryColor,
        activeColor: activeColor,
      ),
      count: 5,
      initialActiveIndex: currentIndex,
      onTap: onTap,
      gradient: bottomGradient,
      curve: Curves.easeInOut,
      height: 60,
      top: -30,
      curveSize: 100,
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.2),
    );
  }
}

/// Custom builder for smaller icons with primary color
class _SmallIconBuilder extends DelegateBuilder {
  final Color primaryColor;
  final Color activeColor;

  _SmallIconBuilder({
    required this.primaryColor,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context, int index, bool active) {
    IconData icon;
    IconData activeIcon;
    String title;

    switch (index) {
      case 0:
        icon = Icons.home_outlined;
        activeIcon = Icons.home;
        title = AppStrings.home;
        break;
      case 1:
        icon = Icons.chat_bubble_outline;
        activeIcon = Icons.chat_bubble;
        title = AppStrings.chat;
        break;
      case 2:
        icon = Icons.add;
        activeIcon = Icons.add;
        title = AppStrings.sell;
        break;
      case 3:
        icon = Icons.description_outlined;
        activeIcon = Icons.description;
        title = AppStrings.myAds;
        break;
      case 4:
        icon = Icons.settings_outlined;
        activeIcon = Icons.settings;
        title = AppStrings.settings;
        break;
      default:
        icon = Icons.circle;
        activeIcon = Icons.circle;
        title = '';
    }

    // All icons in white color
    final iconColor = Colors.white;
    final textColor = Colors.white;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          active ? activeIcon : icon,
          color: iconColor,
          size: 20, // Smaller icon size
        ),
        if (title.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 10, // Smaller text size
              fontWeight: active ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ],
    );
  }

  @override
  bool fixed() => false; // reactCircle style is not fixed
}
