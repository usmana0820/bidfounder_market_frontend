import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../navigation/app_router.dart';
import '../services/auth/auth_service.dart';
import '../store/auth_store.dart';

/// Splash Screen with animations
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;

  @override
  Widget build(BuildContext context) {
    // Splash screen always uses primary color background, so status bar should be light
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(AppColors.primary),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(AppColors.primary),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo
            ScaleTransition(
              scale: _logoScaleAnimation,
              child: FadeTransition(
                opacity: _logoFadeAnimation,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.2),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shopping_bag,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Animated App Name
            SlideTransition(
              position: _textSlideAnimation,
              child: FadeTransition(
                opacity: _textFadeAnimation,
                child: Text(
                  AppStrings.appName,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Loading indicator
            FadeTransition(
              opacity: _textFadeAnimation,
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Logo scale and fade animation
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Text fade and slide animation
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.8, curve: Curves.easeIn),
      ),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    // Check authentication and navigate after animation
    _checkAuthAndNavigate();
  }

  /// Check authentication status and navigate accordingly
  /// 
  /// Flow:
  /// 1. Check if token exists in SharedPreferences
  /// 2. If token exists, validate it by fetching user profile
  /// 3. If valid → Navigate to Dashboard (MainScreen)
  /// 4. If invalid/expired → Navigate to Login/Phone Number screen
  Future<void> _checkAuthAndNavigate() async {
    // Wait for splash animation to complete
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    try {
      // Check if user has a stored token
      final isAuthenticated = await AuthService.isAuthenticated();

      if (isAuthenticated) {
        // Token exists, validate it by fetching user profile
        try {
          final authStore = Provider.of<AuthStore>(context, listen: false);
          
          // Try to load user profile (this will validate the token)
          await authStore.loadProfile();

          // If profile loaded successfully, token is valid
          if (authStore.isAuthenticated && authStore.user != null) {
            // Token is valid, navigate to dashboard
            if (mounted) {
              Navigator.pushReplacementNamed(context, AppRouter.dashboard);
            }
            return;
          }
        } catch (e) {
          // Token is invalid or expired, clear it and go to login
          debugPrint('Token validation failed: $e');
          await AuthService.logout();
        }
      }

      // No token or invalid token, navigate to login screen for existing users
      // New users can access phone number screen from login screen
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRouter.login);
      }
    } catch (e) {
      // Error checking auth, navigate to login
      debugPrint('Error checking authentication: $e');
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRouter.login);
      }
    }
  }
}
