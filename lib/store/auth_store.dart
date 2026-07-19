import 'dart:io';

import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth/auth_service.dart';
import '../services/user/user_service.dart';
// import '../services/notifications/firebase_notification_service.dart';

/// Auth Store - Manages authentication state
class AuthStore extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;

  AuthStore() {
    _checkAuthStatus();
  }

  /// Check if user is authenticated
  /// 
  /// Checks if token exists and optionally validates it by loading profile.
  /// This is called on app startup to determine if user should see login or dashboard.
  Future<void> _checkAuthStatus() async {
    try {
      _isAuthenticated = await AuthService.isAuthenticated();
      // Don't load profile here automatically - let splash screen handle it
      // to avoid unnecessary API calls
    } catch (e) {
      debugPrint('Error checking auth status: $e');
      _isAuthenticated = false;
    }
    notifyListeners();
  }

  /// Load user profile
  /// 
  /// Fetches the current user's profile from the backend.
  /// Called after login/registration or when profile screen is opened.
  /// Updates _user and _isAuthenticated state.
  Future<void> loadProfile() async {
    try {
      _isLoading = true;
      notifyListeners();

      debugPrint('🔄 Loading user profile...');
      _user = await UserService.getProfile();
      _isAuthenticated = true;
      debugPrint('✅ Profile loaded successfully: ${_user?.fullName}');
      
      // Initialize notifications after successful profile load
      // await _initializeNotifications();
    } catch (e) {
      debugPrint('❌ Error loading profile: $e');
      _isAuthenticated = false;
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // /// Initialize notifications after login
  // /// 
  // /// Gets FCM token and saves it to backend
  // Future<void> _initializeNotifications() async {
  //   try {
  //     final token = await FirebaseNotificationService.getFCMToken();
  //     if (token != null) {
  //       await FirebaseNotificationService.saveTokenToBackend(token);
  //     }
  //   } catch (e) {
  //     debugPrint('Error initializing notifications: $e');
  //   }
  // }

  /// Update user profile
  /// 
  /// Updates the user's profile information.
  /// Supports both file uploads and URL strings for profile images.
  /// 
  /// Parameters:
  /// - fullName: Optional - New full name for the user
  /// - profileImage: Optional - File object for new profile image (will be uploaded via multipart)
  /// - profileImageUrl: Optional - URL string if image is already uploaded
  Future<bool> updateProfile({
    String? fullName,
    File? profileImage,
    String? profileImageUrl,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      _user = await UserService.updateProfile(
        fullName: fullName,
        profileImage: profileImage,
        profileImageUrl: profileImageUrl,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Set user after login/registration
  void setUser(User user) {
    _user = user;
    _isAuthenticated = true;
    notifyListeners();
  }

  /// Logout user
  Future<void> logout() async {
    // Clear notifications
    // await FirebaseNotificationService.deleteToken();
    
    // Logout from auth service
    await AuthService.logout();
    
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  /// Clear user data
  void clearUser() {
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}

