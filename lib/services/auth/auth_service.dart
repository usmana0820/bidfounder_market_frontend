import 'package:flutter/foundation.dart';

import '../../constants/api_endpoints.dart';
import '../api_service.dart';

/// Authentication Service - Handles all auth-related API calls
/// 
/// This service manages:
/// - User registration (email, phone, name, password)
/// - OTP verification for account activation
/// - User login with email and password
/// - Password reset flow (forgot password + reset)
/// - Token management (automatic saving after login/registration)
/// - Authentication status checking
/// 
/// All methods automatically handle:
/// - Token storage after successful authentication
/// - Error handling and propagation
/// - API response parsing
class AuthService {
  /// Register a new user account
  /// 
  /// Creates a new user account with the provided information.
  /// After registration, an OTP is sent to the user's email for verification.
  /// 
  /// Parameters:
  /// - email: User's email address
  /// - phoneNumber: User's phone number (10 digits, without country code)
  /// - fullName: User's full name
  /// - password: User's password (min 6 characters)
  /// 
  /// Returns: API response containing success message and user data
  /// 
  /// Throws: ApiException if registration fails (email exists, invalid data, etc.)
  /// 
  /// Flow: Register → Verify OTP → Login
  static Future<Map<String, dynamic>> register({
    required String email,
    required String phoneNumber,
    required String fullName,
    required String password,
  }) async {
    try {
      final response = await ApiService.post(
        ApiEndpoints.register,
        body: {
          'email': email,
          'phone_number': phoneNumber,
          'full_name': fullName,
          'password': password,
        },
      );

      return ApiService.handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Verify OTP code sent to user's email
  /// 
  /// Verifies the OTP code received via email after registration or password reset.
  /// On successful verification, access and refresh tokens are automatically saved.
  /// 
  /// Parameters:
  /// - email: User's email address (must match registration email)
  /// - code: 6-digit OTP code received via email
  /// 
  /// Returns: API response containing tokens (access, refresh) and user data
  /// 
  /// Throws: ApiException if OTP is invalid, expired, or email doesn't match
  /// 
  /// Note: Tokens are automatically saved to SharedPreferences for future requests
  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String code,
  }) async {
    try {
      final response = await ApiService.post(
        ApiEndpoints.verifyOtp,
        body: {
          'email': email,
          'code': code,
        },
      );

      final data = ApiService.handleResponse(response);
      
      // Save tokens if provided
      if (data['access'] != null) {
        await ApiService.saveAccessToken(data['access']);
      }
      if (data['refresh'] != null) {
        await ApiService.saveRefreshToken(data['refresh']);
      }

      return data;
    } catch (e) {
      rethrow;
    }
  }

  /// Login user with email and password
  /// 
  /// Authenticates an existing user and retrieves access/refresh tokens.
  /// Tokens are automatically saved for authenticated API requests.
  /// 
  /// Parameters:
  /// - email: User's registered email address
  /// - password: User's account password
  /// 
  /// Returns: API response containing tokens (access, refresh) and user data
  /// 
  /// Throws: ApiException if credentials are invalid or account doesn't exist
  /// 
  /// Note: Tokens are automatically saved to SharedPreferences
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post(
        ApiEndpoints.login,
        body: {
          'email': email,
          'password': password,
        },
      );

      final data = ApiService.handleResponse(response);
      
      // Save tokens
      if (data['access'] != null) {
        await ApiService.saveAccessToken(data['access']);
      }
      if (data['refresh'] != null) {
        await ApiService.saveRefreshToken(data['refresh']);
      }

      return data;
    } catch (e) {
      rethrow;
    }
  }

  /// Request password reset OTP
  /// 
  /// Initiates password reset flow by sending OTP to user's email.
  /// User must verify OTP before resetting password.
  /// 
  /// Parameters:
  /// - email: User's registered email address
  /// 
  /// Returns: API response with success message
  /// 
  /// Throws: ApiException if email doesn't exist or request fails
  /// 
  /// Flow: Forgot Password → Verify OTP → Reset Password
  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await ApiService.post(
        ApiEndpoints.forgotPassword,
        body: {
          'email': email,
        },
      );

      return ApiService.handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Reset user password after OTP verification
  /// 
  /// Changes user's password after successful OTP verification.
  /// Must be called after forgotPassword and verifyOtp.
  /// 
  /// Parameters:
  /// - email: User's registered email address
  /// - newPassword: New password to set (min 6 characters)
  /// 
  /// Returns: API response with success message
  /// 
  /// Throws: ApiException if email doesn't exist, OTP not verified, or validation fails
  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      final response = await ApiService.post(
        ApiEndpoints.resetPassword,
        body: {
          'email': email,
          'new_password': newPassword,
        },
      );

      return ApiService.handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Logout user and clear all tokens
  /// 
  /// Removes all stored authentication tokens from device.
  /// User will need to login again to access protected resources.
  /// 
  /// Note: This only clears local tokens. Backend session management
  /// may require additional API call if implemented.
  static Future<void> logout() async {
    await ApiService.clearTokens();
  }

  /// Refresh access token using refresh token
  /// 
  /// Gets a new access token using the stored refresh token.
  /// Automatically saves the new access token if refresh is successful.
  /// 
  /// Returns: API response containing new access token
  /// 
  /// Throws: ApiException if refresh token is invalid or expired
  /// 
  /// Note: New access token is automatically saved to SharedPreferences
  static Future<Map<String, dynamic>> refreshAccessToken() async {
    try {
      final refreshToken = await ApiService.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        throw ApiException(
          message: 'No refresh token available',
          statusCode: 401,
        );
      }

      debugPrint('🔄 Refreshing access token...');
      
      final response = await ApiService.post(
        ApiEndpoints.refreshToken,
        body: {
          'refresh': refreshToken,
        },
      );

      final data = ApiService.handleResponse(response);
      
      // Save new access token if provided
      if (data['access'] != null) {
        await ApiService.saveAccessToken(data['access']);
        debugPrint('✅ Access token refreshed successfully');
      }

      return data;
    } catch (e) {
      debugPrint('❌ Token refresh failed: $e');
      rethrow;
    }
  }

  /// Check if user is currently authenticated
  /// 
  /// Verifies if a valid access token exists in storage.
  /// Does not validate token expiry or backend validity.
  /// 
  /// Returns: true if access token exists, false otherwise
  /// 
  /// Use this to check authentication status before making protected API calls
  static Future<bool> isAuthenticated() async {
    final token = await ApiService.getAccessToken();
    return token != null && token.isNotEmpty;
  }
}

