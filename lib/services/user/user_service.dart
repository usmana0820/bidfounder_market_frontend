import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../constants/api_endpoints.dart';
import '../../models/user_model.dart';
import '../api_service.dart';

/// User Service - Handles user profile related API calls
/// 
/// This service manages:
/// - Fetching user profile information
/// - Updating user profile (name, profile image)
/// 
/// All methods require authentication (Bearer token).
/// Tokens are automatically included from ApiService.
/// 
/// Note: This service is separate from AuthService to maintain
/// clear separation between authentication and user data operations.
class UserService {
  /// Get current user's profile information
  /// 
  /// Fetches the authenticated user's profile data from the server.
  /// Requires valid access token (automatically included).
  /// 
  /// Returns: User model object with profile data (id, name, email, phone, image, etc.)
  /// 
  /// Throws: ApiException if:
  /// - User is not authenticated (401)
  /// - Token is invalid or expired (401)
  /// - Server error (500)
  /// 
  /// Example:
  /// ```dart
  /// try {
  ///   final user = await UserService.getProfile();
  ///   print('Welcome ${user.fullName}');
  /// } catch (e) {
  ///   // Handle error - may need to re-authenticate
  /// }
  /// ```
  static Future<User> getProfile() async {
    try {
      debugPrint('📤 Get Profile API Request:');
      debugPrint('   Endpoint: ${ApiEndpoints.getProfile}');

      final response = await ApiService.get(
        ApiEndpoints.getProfile,
        includeAuth: true,
      );

      final data = ApiService.handleResponse(response);
      
      debugPrint('✅ Get Profile API Response:');
      debugPrint('   Data: $data');

      return User.fromJson(data);
    } catch (e) {
      debugPrint('❌ Get Profile API Error:');
      debugPrint('   $e');
      rethrow;
    }
  }

  /// Update current user's profile information
  /// 
  /// Updates user profile fields. Only provided fields are updated.
  /// Requires valid access token (automatically included).
  /// 
  /// Parameters:
  /// - fullName: Optional - New full name for the user
  /// - profileImage: Optional - File object for new profile image (will be uploaded)
  /// - profileImageUrl: Optional - URL string if image is already uploaded
  /// 
  /// Returns: Updated User model object with new profile data
  /// 
  /// Throws: ApiException if:
  /// - User is not authenticated (401)
  /// - Validation fails (400)
  /// - Server error (500)
  /// 
  /// Example:
  /// ```dart
  /// // With file upload
  /// final file = File('/path/to/image.jpg');
  /// final updatedUser = await UserService.updateProfile(
  ///   fullName: 'John Doe',
  ///   profileImage: file,
  /// );
  /// 
  /// // With URL (already uploaded)
  /// final updatedUser = await UserService.updateProfile(
  ///   fullName: 'John Doe',
  ///   profileImageUrl: 'https://example.com/avatar.png',
  /// );
  /// ```
  /// 
  /// Note: If both profileImage (File) and profileImageUrl are provided, profileImage takes precedence.
  static Future<User> updateProfile({
    String? fullName,
    File? profileImage,
    String? profileImageUrl,
  }) async {
    try {
      debugPrint('📤 Update Profile API Request:');
      debugPrint('   Endpoint: ${ApiEndpoints.updateProfile}');
      debugPrint('   Full Name: ${fullName ?? 'No change'}');
      debugPrint('   Profile Image: ${profileImage != null ? 'File upload' : profileImageUrl ?? 'No change'}');

      http.Response response;

      // If profileImage is a File, upload directly via multipart/form-data
      // No URL needed - file is uploaded directly from device
      if (profileImage != null) {
        final fields = <String, String>{};
        if (fullName != null) {
          fields['full_name'] = fullName;
        }

        debugPrint('   Uploading image directly from device (no URL required)');
        response = await ApiService.putMultipart(
          ApiEndpoints.updateProfile,
          file: profileImage,
          fields: fields.isNotEmpty ? fields : null,
          fileFieldName: 'profile_image',
          includeAuth: true,
        );
      } else {
        // Use regular JSON PUT request
        final body = <String, dynamic>{};
        if (fullName != null) body['full_name'] = fullName;
        // If profileImageUrl is provided, send it (can be empty string to clear image)
        if (profileImageUrl != null) {
          body['profile_image'] = profileImageUrl;
        }

        response = await ApiService.put(
          ApiEndpoints.updateProfile,
          body: body,
          includeAuth: true,
        );
      }

      final data = ApiService.handleResponse(response);
      
      debugPrint('✅ Update Profile API Response:');
      debugPrint('   Data: $data');

      return User.fromJson(data);
    } catch (e) {
      debugPrint('❌ Update Profile API Error:');
      debugPrint('   $e');
      rethrow;
    }
  }
}

