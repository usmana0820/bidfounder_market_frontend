import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

import 'constants/app_colors.dart';
import 'constants/app_constants.dart';
// import 'firebase_options.dart';
import 'navigation/app_router.dart';
import 'screens/buyer/chat/chat_screen.dart';
import 'screens/buyer/dashboard/dashboard_screen.dart';
import 'screens/seller/categories_selection_screen.dart';
import 'screens/seller/products/my_ads_screen.dart';
import 'screens/settings/account_settings_screen.dart';
// import 'services/notifications/firebase_notification_service.dart';
import 'store/auth_store.dart';
import 'store/cart_store.dart';
import 'widgets/bottom_nav_bar.dart';

// /// Background message handler - must be top-level function
// /// 
// /// This is called when app is in background and a notification is received.
// /// Note: This function is already defined in firebase_notification_service.dart
// /// but we need to register it here for background message handling.
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   debugPrint('📩 Background message received: ${message.messageId}');
//   // Additional background handling can be added here
//   // Main handler is in firebase_notification_service.dart
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase initialization is commented out until google-services.json is added
  // TODO: Uncomment when Firebase is configured
  // try {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  //   debugPrint('✅ Firebase initialized successfully');
  //   
  //   // Initialize Firebase notifications
  //   await FirebaseNotificationService.initialize();
  //   
  //   // Register background message handler
  //   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // } catch (e) {
  //   debugPrint('❌ Error initializing Firebase: $e');
  //   debugPrint('⚠️ Please update firebase_options.dart with your Firebase project credentials');
  // }
  
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthStore()),
        ChangeNotifierProvider(create: (_) => CartStore()),
      ],
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
