import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../main.dart';
import '../navigation/app_router.dart';

/// Drawer Widget - Professional side navigation drawer
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(AppColors.darkCard)
        : const Color(AppColors.white);
    final borderColor = isDark
        ? const Color(AppColors.darkBorder)
        : const Color(AppColors.grayLight);
    final textColor = isDark
        ? const Color(AppColors.darkText)
        : const Color(AppColors.black);
    final primaryColor = const Color(AppColors.primary);
    final backgroundColor = isDark
        ? const Color(AppColors.darkBackground)
        : const Color(AppColors.background);

    return Drawer(
      backgroundColor: cardColor,
      child: Column(
        children: [
          // Header Section with User Info
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 30,
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor,
                  primaryColor.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.menu,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // User Avatar
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppStrings.userEmail,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                _buildMenuItem(
                  context: context,
                  icon: Icons.home_rounded,
                  title: AppStrings.home,
                  onTap: () => _navigateToTab(context, 0),
                  textColor: textColor,
                  borderColor: borderColor,
                  primaryColor: primaryColor,
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.description_rounded,
                  title: AppStrings.myAds,
                  onTap: () => _navigateToTab(context, 3),
                  textColor: textColor,
                  
                  borderColor: borderColor,
                  primaryColor: primaryColor,
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.chat_bubble_outline_rounded,
                  title: AppStrings.chat,
                  onTap: () => _navigateToTab(context, 1),
                  textColor: textColor,
                  borderColor: borderColor,
                  primaryColor: primaryColor,
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.person_outline_rounded,
                  title: AppStrings.profile,
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate within the current navigator, not pushing new MainScreen
                    final navigator = Navigator.of(context);
                    if (navigator.canPop()) {
                      // Find the root navigator (MainScreen's navigator)
                      navigator.pushNamed(AppRouter.profile);
                    } else {
                      // If we're at root, navigate normally
                      Navigator.pushNamed(context, AppRouter.profile);
                    }
                  },
                  textColor: textColor,
                  borderColor: borderColor,
                  primaryColor: primaryColor,
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.local_shipping_outlined,
                  title: 'Track Orders',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate within the current navigator, not pushing new MainScreen
                    final navigator = Navigator.of(context);
                    if (navigator.canPop()) {
                      // Find the root navigator (MainScreen's navigator)
                      navigator.pushNamed(AppRouter.shippingTrack);
                    } else {
                      // If we're at root, navigate normally
                      Navigator.pushNamed(context, AppRouter.shippingTrack);
                    }
                  },
                  textColor: textColor,
                  borderColor: borderColor,
                  primaryColor: primaryColor,
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.settings_outlined,
                  title: AppStrings.accountSettings,
                  onTap: () => _navigateToTab(context, 4),
                  textColor: textColor,
                  borderColor: borderColor,
                  primaryColor: primaryColor,
                ),
                const SizedBox(height: 10),
                Divider(
                  color: borderColor,
                  thickness: 1,
                  height: 1,
                ),
                const SizedBox(height: 10),
                // Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(AppColors.error).withValues(alpha: 0.1)
                          : const Color(AppColors.error).withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(AppColors.error).withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.logout_rounded,
                        color: Color(AppColors.error),
                      ),
                      title: Text(
                        AppStrings.logout,
                        style: const TextStyle(
                          color: Color(AppColors.error),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _showLogoutDialog(context);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // App Version / Footer
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: borderColor, width: 1),
              ),
            ),
            child: Column(
              children: [
                Text(
                  AppStrings.appName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color textColor,
    required Color borderColor,
    required Color primaryColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: primaryColor,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: textColor.withValues(alpha: 0.5),
          size: 20,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
    );
  }

  /// Navigate to a tab by switching tabs in MainScreen
  void _navigateToTab(BuildContext context, int tabIndex) {
    Navigator.pop(context); // Close drawer first
    
    // Since the drawer is opened from screens inside MainScreen (Dashboard, Chat, Sell, My Ads, Settings),
    // we should always be in MainScreen context. Just switch tabs directly.
    // This avoids creating new MainScreen instances.
    MainScreen.switchToTab(tabIndex);
    
    // Note: MainScreen.switchToTab uses a static instance reference, so it will work
    // as long as MainScreen exists in the widget tree (which it should when drawer is open).
    // No need for additional navigation - just switching tabs is sufficient.
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final cardColor = isDark
            ? const Color(AppColors.darkCard)
            : const Color(AppColors.white);
        final textColor = isDark
            ? const Color(AppColors.darkText)
            : const Color(AppColors.black);

        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(AppColors.error).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Color(AppColors.error),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppStrings.logout,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, AppRouter.login);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(AppColors.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Hamburger Menu - Side drawer menu
class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu, color: Colors.white),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    );
  }
}
