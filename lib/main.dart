import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/app_colors.dart';
import 'constants/app_constants.dart';
import 'navigation/app_router.dart';
import 'screens/buyer/chat/chat_screen.dart';
import 'screens/buyer/dashboard/dashboard_screen.dart';
import 'screens/seller/categories_selection_screen.dart';
import 'screens/seller/products/my_ads_screen.dart';
import 'screens/settings/account_settings_screen.dart';
import 'store/cart_store.dart';
import 'widgets/bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

/// Main Screen with Bottom Navigation and Stack Navigator
/// Uses IndexedStack to maintain tab state, and Navigator.pushNamed for stack navigation
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
  
  /// Switch to the previous tab (0->4, 1->0, 2->1, 3->2, 4->3)
  static void switchToPreviousTab() {
    _MainScreenState._instance?._switchToPreviousTab();
  }
  
  /// Switch to a specific tab by index
  /// Tab indices: 0=Dashboard, 1=Chat, 2=Sell, 3=MyAds, 4=Settings
  static void switchToTab(int index) {
    _MainScreenState._instance?._switchToTabInternal(index);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartStore(),
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppThemeColors.lightTheme,
        darkTheme: AppThemeColors.darkTheme,
        themeMode: ThemeMode.system,
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AppRouter.splash,
      ),
    );
  }
}

class _MainScreenState extends State<MainScreen> {
  static _MainScreenState? _instance;
  int _currentIndex = 0;
  
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildNavigator(0, const DashboardScreen()),
          _buildNavigator(1, const ChatScreen()),
          _buildNavigator(2, const CategoriesSelectionScreen()),
          _buildNavigator(3, const MyAdsScreen()),
          _buildNavigator(4, const AccountSettingsScreen()),
        ],
      ),
      // Bottom nav shows on all tabs (Dashboard, Chat, Sell, My Ads, Settings)
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
  
  @override
  void dispose() {
    _instance = null;
    super.dispose();
  }
  
  @override
  void initState() {
    super.initState();
    _instance = this;
  }

  Widget _buildNavigator(int index, Widget initialScreen) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) {
        // If it's the initial route, return the tab screen
        if (settings.name == '/') {
          return MaterialPageRoute(
            builder: (_) => initialScreen,
            settings: settings,
          );
        }
        // Otherwise, use the app router for other routes
        return AppRouter.generateRoute(settings);
      },
      initialRoute: '/',
    );
  }

  void _onTabTapped(int index) {
    // If tapping the same tab, pop to root if there are routes in stack
    if (_currentIndex == index) {
      final navigator = _navigatorKeys[index].currentState;
      if (navigator != null && navigator.canPop()) {
        navigator.popUntil((route) => route.isFirst);
      }
    } else {
      // Clear navigation stack of previous tab before switching
      final previousNavigator = _navigatorKeys[_currentIndex].currentState;
      if (previousNavigator != null && previousNavigator.canPop()) {
        previousNavigator.popUntil((route) => route.isFirst);
      }
      
      setState(() {
        _currentIndex = index;
      });
    }
  }

  /// Internal method to switch to previous tab - called from MainScreen.switchToPreviousTab
  void _switchToPreviousTab() {
    // Calculate previous tab index (0->4, 1->0, 2->1, 3->2, 4->3)
    final previousIndex = (_currentIndex - 1 + 5) % 5;
    _switchToTabInternal(previousIndex);
  }
  
  /// Internal method to switch tabs - called from MainScreen.switchToTab
  void _switchToTabInternal(int index) {
    // Clear navigation stack of previous tab before switching
    if (_currentIndex != index) {
      final previousNavigator = _navigatorKeys[_currentIndex].currentState;
      if (previousNavigator != null && previousNavigator.canPop()) {
        previousNavigator.popUntil((route) => route.isFirst);
      }
    }
    
    setState(() {
      _currentIndex = index;
      // Pop to root of the selected tab
      final navigator = _navigatorKeys[index].currentState;
      if (navigator != null && navigator.canPop()) {
        navigator.popUntil((route) => route.isFirst);
      }
    });
  }
}
