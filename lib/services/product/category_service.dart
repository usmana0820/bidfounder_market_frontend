import 'dart:convert';
import 'package:flutter/foundation.dart' hide Category;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/api_endpoints.dart';
import '../../models/category_model.dart';
import '../api_service.dart';
import '../auth/auth_service.dart';

/// Category Service - Handles category-related API calls and caching
/// 
/// This service provides:
/// - Fetching categories from the API
/// - Caching categories in SharedPreferences for offline access
/// - Fallback to cached data when API fails
class CategoryService {
  static const String _categoriesCacheKey = 'cached_categories';
  static const String _categoriesCacheTimestampKey = 'cached_categories_timestamp';
  static const Duration _cacheValidDuration = Duration(hours: 24); // Cache valid for 24 hours

  /// Get categories from API with fallback to cache
  /// 
  /// First tries to fetch from API (handles pagination to get all pages).
  /// If API fails or is unavailable, falls back to cached data from SharedPreferences.
  /// 
  /// Returns: List of Category objects (all pages combined)
  /// 
  /// Throws: Exception if both API and cache fail
  static Future<List<Category>> getCategories() async {
    try {
      debugPrint('📤 Fetching categories from API...');
      
      List<Category> allCategories = [];
      String? nextUrl = ApiEndpoints.getCategories;
      int pageCount = 0;
      
      // Fetch all pages
      while (nextUrl != null) {
        pageCount++;
        debugPrint('   Fetching page $pageCount...');
        
        http.Response response;
        
        // Handle full URL vs endpoint path
        if (nextUrl.startsWith('http://') || nextUrl.startsWith('https://')) {
          // Full URL - make direct HTTP request
          final uri = Uri.parse(nextUrl);
          final headers = await ApiService.getHeaders(includeAuth: true);
          response = await http.get(uri, headers: headers);
          
          // Check for token refresh on 401
          if (response.statusCode == 401) {
            try {
              await AuthService.refreshAccessToken();
              final newHeaders = await ApiService.getHeaders(includeAuth: true);
              response = await http.get(uri, headers: newHeaders);
            } catch (e) {
              debugPrint('   ❌ Token refresh failed: $e');
            }
          }
        } else {
          // Endpoint path - use ApiService
          response = await ApiService.get(
            nextUrl,
            includeAuth: true,
          );
        }

        final data = ApiService.handleResponse(response);
        final categoriesResponse = CategoriesResponse.fromJson(data);
        
        allCategories.addAll(categoriesResponse.results);
        debugPrint('   Page $pageCount: ${categoriesResponse.results.length} categories (Total: ${allCategories.length})');
        
        // Check if there's a next page
        nextUrl = categoriesResponse.next;
        
        // If next is a full URL, keep it as is for next iteration
        // If it's a relative path, ensure it starts with /
        if (nextUrl != null && !nextUrl.startsWith('http') && !nextUrl.startsWith('/')) {
          nextUrl = '/$nextUrl';
        }
      }
      
      debugPrint('✅ Categories fetched successfully: ${allCategories.length} categories from $pageCount page(s)');
      
      // Cache all categories
      await _cacheCategories(allCategories);
      
      return allCategories;
    } catch (e) {
      debugPrint('❌ Failed to fetch categories from API: $e');
      debugPrint('🔄 Attempting to load from cache...');
      
      // Fallback to cached data
      final cachedCategories = await _getCachedCategories();
      
      if (cachedCategories.isNotEmpty) {
        debugPrint('✅ Loaded ${cachedCategories.length} categories from cache');
        return cachedCategories;
      }
      
      // If cache is also empty, throw error
      debugPrint('❌ No cached categories available');
      throw Exception('Failed to fetch categories and no cache available: $e');
    }
  }

  /// Cache categories to SharedPreferences
  /// 
  /// Stores the categories list as JSON and saves the current timestamp
  static Future<void> _cacheCategories(List<Category> categories) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Convert categories to JSON
      final categoriesJson = categories.map((cat) => cat.toJson()).toList();
      final jsonString = jsonEncode(categoriesJson);
      
      // Save categories and timestamp
      await prefs.setString(_categoriesCacheKey, jsonString);
      await prefs.setInt(_categoriesCacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
      
      debugPrint('💾 Categories cached successfully');
    } catch (e) {
      debugPrint('❌ Failed to cache categories: $e');
    }
  }

  /// Get cached categories from SharedPreferences
  /// 
  /// Returns: List of Category objects from cache, or empty list if cache is invalid/expired
  static Future<List<Category>> _getCachedCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if cache exists
      final cachedJson = prefs.getString(_categoriesCacheKey);
      final timestamp = prefs.getInt(_categoriesCacheTimestampKey);
      
      if (cachedJson == null || timestamp == null) {
        debugPrint('📭 No cached categories found');
        return [];
      }
      
      // Check if cache is still valid
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final age = now.difference(cacheTime);
      
      if (age > _cacheValidDuration) {
        debugPrint('⏰ Cached categories expired (age: ${age.inHours} hours)');
        // Cache expired but still return it as fallback
        debugPrint('⚠️ Using expired cache as fallback');
      }
      
      // Parse cached JSON
      final List<dynamic> categoriesJson = jsonDecode(cachedJson);
      final categories = categoriesJson
          .map((json) => Category.fromJson(json as Map<String, dynamic>))
          .toList()
          .cast<Category>();
      
      return categories;
    } catch (e) {
      debugPrint('❌ Failed to load cached categories: $e');
      return [];
    }
  }

  /// Clear cached categories
  /// 
  /// Useful for forcing a fresh fetch on next request
  static Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_categoriesCacheKey);
      await prefs.remove(_categoriesCacheTimestampKey);
      debugPrint('🗑️ Categories cache cleared');
    } catch (e) {
      debugPrint('❌ Failed to clear categories cache: $e');
    }
  }

  /// Get categories synchronously from cache only
  /// 
  /// This is useful for immediate access without async operations.
  /// Returns empty list if cache is not available.
  static Future<List<Category>> getCachedCategoriesOnly() async {
    return await _getCachedCategories();
  }
}

