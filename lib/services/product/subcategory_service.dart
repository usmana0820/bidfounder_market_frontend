import 'dart:convert';

import 'package:flutter/foundation.dart' hide Category;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/api_endpoints.dart';
import '../../models/subcategory_model.dart';
import '../api_service.dart';
import '../auth/auth_service.dart';

/// Subcategory Service - Handles subcategory API calls and caching
class SubcategoryService {
  static const String _cacheKey = 'cached_subcategories';
  static const String _cacheTimestampKey = 'cached_subcategories_timestamp';
  static const Duration _cacheValidDuration = Duration(hours: 24);

  /// Fetch subcategories from API with cache fallback
  /// 
  /// Handles pagination to fetch all subcategories.
  /// Optionally filters by categorySlug.
  /// 
  /// Parameters:
  /// - categorySlug: Optional slug to filter subcategories by category
  /// 
  /// Returns: List of Subcategory objects (all pages combined, optionally filtered)
  static Future<List<Subcategory>> getSubcategories({String? categorySlug}) async {
    try {
      debugPrint('📤 Fetching subcategories from API${categorySlug != null ? ' for category: $categorySlug' : ''}...');
      
      List<Subcategory> allSubcategories = [];
      String? nextUrl = ApiEndpoints.getSubcategories;
      int pageCount = 0;
      Map<String, String>? queryParams = categorySlug != null ? {'category__slug': categorySlug} : null;
      
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
          // Endpoint path - use ApiService with query params
          Map<String, String>? currentQueryParams = queryParams;
          if (pageCount > 1) {
            currentQueryParams = currentQueryParams ?? {};
            currentQueryParams['page'] = pageCount.toString();
          } else if (currentQueryParams != null) {
            currentQueryParams = Map.from(currentQueryParams);
          }
          
          response = await ApiService.get(
            nextUrl,
            includeAuth: true,
            queryParams: currentQueryParams,
          );
        }

        final data = ApiService.handleResponse(response);
        final subcategoriesResponse = SubcategoriesResponse.fromJson(data);

        allSubcategories.addAll(subcategoriesResponse.results);
        debugPrint('   Page $pageCount: ${subcategoriesResponse.results.length} subcategories (Total: ${allSubcategories.length})');

        // Check if there's a next page
        nextUrl = subcategoriesResponse.next;
        
        // If next is a full URL, keep it as is for next iteration
        // If it's a relative path, ensure it starts with /
        if (nextUrl != null && !nextUrl.startsWith('http') && !nextUrl.startsWith('/')) {
          nextUrl = '/$nextUrl';
        }
      }

      debugPrint('✅ Subcategories fetched: ${allSubcategories.length} from $pageCount page(s)');

      // Cache all subcategories
      await _cacheSubcategories(allSubcategories);

      // Filter by categorySlug if provided
      return categorySlug == null
          ? allSubcategories
          : allSubcategories
              .where((s) => s.categorySlug == categorySlug)
              .toList();
    } catch (e) {
      debugPrint('❌ Failed to fetch subcategories: $e');
      debugPrint('🔄 Attempting to load subcategories from cache...');

      final cached = await _getCachedSubcategories();
      if (cached.isNotEmpty) {
        debugPrint('✅ Loaded ${cached.length} subcategories from cache');
        return categorySlug == null
            ? cached
            : cached.where((s) => s.categorySlug == categorySlug).toList();
      }
      debugPrint('❌ No cached subcategories available');
      throw Exception('Failed to fetch subcategories and no cache available: $e');
    }
  }

  static Future<void> _cacheSubcategories(List<Subcategory> subcategories) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(subcategories.map((s) => s.toJson()).toList());
      await prefs.setString(_cacheKey, jsonString);
      await prefs.setInt(_cacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
      debugPrint('💾 Subcategories cached');
    } catch (e) {
      debugPrint('❌ Failed to cache subcategories: $e');
    }
  }

  static Future<List<Subcategory>> _getCachedSubcategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString(_cacheKey);
      final timestamp = prefs.getInt(_cacheTimestampKey);

      if (cachedJson == null || timestamp == null) return [];

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (DateTime.now().difference(cacheTime) > _cacheValidDuration) {
        debugPrint('⏰ Subcategory cache expired; using as fallback');
      }

      final List<dynamic> subcatsJson = jsonDecode(cachedJson);
      return subcatsJson
          .map((json) => Subcategory.fromJson(json as Map<String, dynamic>))
          .toList()
          .cast<Subcategory>();
    } catch (e) {
      debugPrint('❌ Failed to load cached subcategories: $e');
      return [];
    }
  }
}

