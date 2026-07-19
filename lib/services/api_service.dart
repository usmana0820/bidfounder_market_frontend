import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_endpoints.dart';
import 'auth/auth_service.dart';

/// Base API Service - Handles HTTP requests and token management
/// 
/// This service provides:
/// - Centralized HTTP request methods (GET, POST, PUT, PATCH, DELETE)
/// - Automatic token management (save, retrieve, clear)
/// - Request/response handling with error management
/// - Header management including authentication tokens
/// 
/// All API calls should go through this service to ensure:
/// - Consistent error handling
/// - Automatic token injection
/// - Centralized base URL management
class ApiService {
  static const String tokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';

  /// Get stored access token from SharedPreferences
  /// 
  /// Returns the saved access token if available, null otherwise.
  /// Used to check authentication status and include in API requests.
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  /// Get stored refresh token from SharedPreferences
  /// 
  /// Returns the saved refresh token if available, null otherwise.
  /// Used to refresh expired access tokens.
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(refreshTokenKey);
  }

  /// Save access token to SharedPreferences
  /// 
  /// Stores the JWT access token after successful login/registration.
  /// This token is automatically included in authenticated requests.
  static Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  /// Save refresh token to SharedPreferences
  /// 
  /// Stores the refresh token for token renewal when access token expires.
  /// Currently stored but refresh logic can be implemented here.
  static Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(refreshTokenKey, token);
  }

  /// Clear all tokens from SharedPreferences
  /// 
  /// Removes both access and refresh tokens.
  /// Called during logout to ensure user is fully signed out.
  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    await prefs.remove(refreshTokenKey);
  }

  /// Get headers with optional authentication
  /// 
  /// Builds HTTP headers for API requests:
  /// - Always includes Content-Type and Accept headers
  /// - Optionally includes Authorization Bearer token if includeAuth is true
  /// 
  /// Parameters:
  /// - includeAuth: If true, adds Authorization header with stored access token
  /// - isMultipart: If true, excludes Content-Type to let http package set it for multipart
  /// 
  /// Returns: Map of header key-value pairs
  static Future<Map<String, String>> getHeaders({
    bool includeAuth = false,
    bool isMultipart = false,
  }) async {
    final headers = <String, String>{};

    if (!isMultipart) {
      headers['Content-Type'] = 'application/json';
    }
    headers['Accept'] = 'application/json';

    if (includeAuth) {
      final token = await getAccessToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  /// Make GET request to the API
  /// 
  /// Sends a GET HTTP request to the specified endpoint.
  /// 
  /// Parameters:
  /// - endpoint: API endpoint path (e.g., '/users/profile/')
  /// - includeAuth: If true, includes Bearer token in headers
  /// - queryParams: Optional query parameters to append to URL
  /// 
  /// Returns: HTTP response object
  /// 
  /// Example:
  /// ```dart
  /// final response = await ApiService.get('/users/profile/', includeAuth: true);
  /// ```
  static Future<http.Response> get(
    String endpoint, {
    bool includeAuth = false,
    Map<String, String>? queryParams,
  }) async {
    var uri = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    var response = await http.get(
      uri,
      headers: await getHeaders(includeAuth: includeAuth),
    );

    // Check if token expired and retry with refreshed token
    if (response.statusCode == 401 && includeAuth) {
      debugPrint('🔄 Token expired, attempting to refresh...');
      try {
        await AuthService.refreshAccessToken();
        
        // Retry the request with new token
        debugPrint('🔄 Retrying GET request with refreshed token...');
        response = await http.get(
          uri,
          headers: await getHeaders(includeAuth: includeAuth),
        );
        debugPrint('✅ Retry successful: ${response.statusCode}');
      } catch (refreshError) {
        debugPrint('❌ Token refresh failed: $refreshError');
        // If refresh fails, return original 401 response
      }
    }

    return response;
  }

  /// Make POST request to the API
  /// 
  /// Sends a POST HTTP request with JSON body to the specified endpoint.
  /// Used for creating resources or sending data (register, login, etc.).
  /// 
  /// Parameters:
  /// - endpoint: API endpoint path
  /// - body: Optional JSON-serializable data to send in request body
  /// - includeAuth: If true, includes Bearer token in headers
  /// 
  /// Returns: HTTP response object
  /// 
  /// Example:
  /// ```dart
  /// final response = await ApiService.post('/users/login/', 
  ///   body: {'email': 'user@example.com', 'password': 'password123'});
  /// ```
  static Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = false,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
      headers: await getHeaders(includeAuth: includeAuth),
      body: body != null ? json.encode(body) : null,
    );

    return response;
  }

  /// Make PUT request to the API
  /// 
  /// Sends a PUT HTTP request to update/replace a resource.
  /// Typically requires authentication (includeAuth defaults to true).
  /// 
  /// Parameters:
  /// - endpoint: API endpoint path
  /// - body: JSON-serializable data to send in request body
  /// - includeAuth: If true, includes Bearer token (default: true)
  /// 
  /// Returns: HTTP response object
  /// 
  /// Example:
  /// ```dart
  /// final response = await ApiService.put('/users/profile/', 
  ///   body: {'full_name': 'John Doe'});
  /// ```
  static Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    var response = await http.put(
      Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
      headers: await getHeaders(includeAuth: includeAuth),
      body: body != null ? json.encode(body) : null,
    );

    // Check if token expired and retry with refreshed token
    if (response.statusCode == 401 && includeAuth) {
      debugPrint('🔄 Token expired, attempting to refresh...');
      try {
        await AuthService.refreshAccessToken();
        
        // Retry the request with new token
        debugPrint('🔄 Retrying PUT request with refreshed token...');
        response = await http.put(
          Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
          headers: await getHeaders(includeAuth: includeAuth),
          body: body != null ? json.encode(body) : null,
        );
        debugPrint('✅ Retry successful: ${response.statusCode}');
      } catch (refreshError) {
        debugPrint('❌ Token refresh failed: $refreshError');
        // If refresh fails, return original 401 response
      }
    }

    return response;
  }

  /// Make PATCH request to the API
  /// 
  /// Sends a PATCH HTTP request for partial updates to a resource.
  /// Similar to PUT but typically used for partial updates.
  /// 
  /// Parameters:
  /// - endpoint: API endpoint path
  /// - body: JSON-serializable data for partial update
  /// - includeAuth: If true, includes Bearer token (default: true)
  /// 
  /// Returns: HTTP response object
  static Future<http.Response> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    final response = await http.patch(
      Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
      headers: await getHeaders(includeAuth: includeAuth),
      body: body != null ? json.encode(body) : null,
    );

    return response;
  }

  /// Make DELETE request to the API
  /// 
  /// Sends a DELETE HTTP request to remove a resource.
  /// Typically requires authentication (includeAuth defaults to true).
  /// 
  /// Parameters:
  /// - endpoint: API endpoint path
  /// - includeAuth: If true, includes Bearer token (default: true)
  /// 
  /// Returns: HTTP response object
  static Future<http.Response> delete(
    String endpoint, {
    bool includeAuth = true,
  }) async {
    final response = await http.delete(
      Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
      headers: await getHeaders(includeAuth: includeAuth),
    );

    return response;
  }

  /// Upload file using multipart/form-data
  /// 
  /// Uploads a file to the specified endpoint using multipart/form-data.
  /// Used for image/file uploads that require multipart encoding.
  /// 
  /// Parameters:
  /// - endpoint: API endpoint path for file upload
  /// - file: File object to upload
  /// - fieldName: Form field name for the file (default: 'file')
  /// - additionalFields: Optional additional form fields to include
  /// - includeAuth: If true, includes Bearer token (default: true)
  /// 
  /// Returns: HTTP response object with upload result
  /// 
  /// Example:
  /// ```dart
  /// final file = File('/path/to/image.jpg');
  /// final response = await ApiService.uploadFile(
  ///   '/upload/image/',
  ///   file,
  ///   fieldName: 'profile_image',
  /// );
  /// ```
  static Future<http.Response> uploadFile(
    String endpoint,
    File file, {
    String fieldName = 'file',
    Map<String, String>? additionalFields,
    bool includeAuth = true,
  }) async {
    try {
      final uri = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
      final request = http.MultipartRequest('POST', uri);

      // Add headers (without Content-Type for multipart)
      final headers = await getHeaders(includeAuth: includeAuth, isMultipart: true);
      request.headers.addAll(headers);

      // Add file
      final fileStream = http.ByteStream(file.openRead());
      final fileLength = await file.length();
      final multipartFile = http.MultipartFile(
        fieldName,
        fileStream,
        fileLength,
        filename: file.path.split('/').last,
      );
      request.files.add(multipartFile);

      // Add additional fields if provided
      if (additionalFields != null) {
        request.fields.addAll(additionalFields);
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return response;
    } catch (e) {
      throw ApiException(
        message: 'File upload failed: $e',
        statusCode: 0,
      );
    }
  }

  /// Update profile with multipart/form-data (for file uploads)
  /// 
  /// Updates user profile using multipart/form-data to support direct file uploads.
  /// The file is uploaded directly from the device without requiring a URL.
  /// Automatically handles token refresh on 401 errors.
  /// 
  /// Parameters:
  /// - endpoint: API endpoint path
  /// - file: File to upload directly from device (gallery/camera)
  /// - fields: Map of additional form fields (e.g., full_name)
  /// - includeAuth: If true, includes Bearer token (default: true)
  /// 
  /// Returns: HTTP response object
  /// 
  /// Note: This method uploads the file directly via multipart/form-data.
  /// No URL is required - the file is sent directly from the device.
  /// If token expires (401), it will automatically refresh and retry once.
  static Future<http.Response> putMultipart(
    String endpoint, {
    File? file,
    Map<String, String>? fields,
    String fileFieldName = 'profile_image',
    bool includeAuth = true,
  }) async {
    try {
      if (file == null) {
        throw ApiException(
          message: 'File is required for multipart upload',
          statusCode: 400,
        );
      }

      debugPrint('📤 Multipart Upload Request:');
      debugPrint('   Endpoint: ${ApiEndpoints.baseUrl}$endpoint');
      debugPrint('   File: ${file.path}');
      debugPrint('   File Size: ${await file.length()} bytes');
      debugPrint('   File Field Name: $fileFieldName');
      debugPrint('   Additional Fields: $fields');

      final uri = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
      final request = http.MultipartRequest('PUT', uri);

      // Add headers (without Content-Type for multipart - http package sets it automatically)
      final headers = await getHeaders(includeAuth: includeAuth, isMultipart: true);
      request.headers.addAll(headers);

      // Add file - upload directly from device
      final fileStream = http.ByteStream(file.openRead());
      final fileLength = await file.length();
      final multipartFile = http.MultipartFile(
        fileFieldName,
        fileStream,
        fileLength,
        filename: file.path.split('/').last,
      );
      request.files.add(multipartFile);

      // Add additional fields if provided
      if (fields != null && fields.isNotEmpty) {
        request.fields.addAll(fields);
      }

      // Send request - file is uploaded directly
      debugPrint('   Uploading file directly from device...');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('✅ Multipart Upload Response:');
      debugPrint('   Status Code: ${response.statusCode}');
      debugPrint('   Response: ${response.body}');

      // Check if token expired and retry with refreshed token
      if (response.statusCode == 401 && includeAuth) {
        debugPrint('🔄 Token expired, attempting to refresh...');
        try {
          await AuthService.refreshAccessToken();
          
          // Retry the request with new token
          debugPrint('🔄 Retrying multipart upload with refreshed token...');
          final retryRequest = http.MultipartRequest('PUT', uri);
          final retryHeaders = await getHeaders(includeAuth: includeAuth, isMultipart: true);
          retryRequest.headers.addAll(retryHeaders);
          
          // Re-add file (need to create new stream)
          final retryFileStream = http.ByteStream(file.openRead());
          final retryMultipartFile = http.MultipartFile(
            fileFieldName,
            retryFileStream,
            fileLength,
            filename: file.path.split('/').last,
          );
          retryRequest.files.add(retryMultipartFile);
          
          if (fields != null && fields.isNotEmpty) {
            retryRequest.fields.addAll(fields);
          }
          
          final retryStreamedResponse = await retryRequest.send();
          final retryResponse = await http.Response.fromStream(retryStreamedResponse);
          
          debugPrint('✅ Retry Response:');
          debugPrint('   Status Code: ${retryResponse.statusCode}');
          debugPrint('   Response: ${retryResponse.body}');
          
          return retryResponse;
        } catch (refreshError) {
          debugPrint('❌ Token refresh failed: $refreshError');
          // If refresh fails, return original 401 response
          return response;
        }
      }

      return response;
    } catch (e) {
      debugPrint('❌ Multipart Upload Error:');
      debugPrint('   $e');
      throw ApiException(
        message: 'Multipart update failed: $e',
        statusCode: 0,
      );
    }
  }

  /// Handle API response and convert to JSON
  /// 
  /// Processes HTTP responses:
  /// - Success (2xx): Parses JSON body and returns data
  /// - Error (4xx/5xx): Extracts error message and throws ApiException
  /// - Empty body: Returns success indicator
  /// 
  /// Parameters:
  /// - response: HTTP response object from API call
  /// 
  /// Returns: Parsed JSON data as Map
  /// 
  /// Throws: ApiException if response status indicates an error
  /// 
  /// Example:
  /// ```dart
  /// try {
  ///   final data = ApiService.handleResponse(response);
  ///   // Use data
  /// } catch (e) {
  ///   // Handle error
  /// }
  /// ```
  static Map<String, dynamic> handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      return json.decode(response.body);
    } else {
      try {
        final error = json.decode(response.body);
        throw ApiException(
          message: error['message'] ?? error['detail'] ?? 'An error occurred',
          statusCode: response.statusCode,
        );
      } catch (e) {
        throw ApiException(
          message: 'An error occurred: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    }
  }
}

/// API Exception class
/// 
/// Custom exception for API errors that includes:
/// - Error message from API response
/// - HTTP status code for error handling
/// 
/// Used throughout the app to handle API errors consistently.
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({required this.message, required this.statusCode});

  @override
  String toString() => message;
}

