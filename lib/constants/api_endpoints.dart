/// API Endpoints - Centralized endpoint definitions
class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'http://192.168.100.207:8000';

  // Authentication Endpoints
  static const String register = '/users/register/';
  static const String verifyOtp = '/users/verify-otp/';
  static const String login = '/users/login/';
  static const String refreshToken = '/users/token/refresh/';
  static const String forgotPassword = '/users/forgot-password/';
  static const String resetPassword = '/users/reset-password/';
  static const String logout = '/users/logout/';

  // User Profile Endpoints
  static const String getProfile = '/users/profile/';
  static const String updateProfile = '/users/profile/';

  // Notification Endpoints
  // static const String saveFCMToken = '/users/fcm-token/'; // TODO: Update with your actual endpoint
  // static const String notificationPreferences = '/users/notification-preferences/'; // TODO: Update with your actual endpoint

  // Products Endpoints
  static const String getCategories = '/products/categories/';
  static const String getSubcategories = '/products/subcategories/';
  // static const String getProducts = '/products/';
  // static const String getProductDetail = '/products/{id}/';
  
  // Cart Endpoints
  // static const String getCart = '/cart/';
  // static const String addToCart = '/cart/add/';
  
  // Orders Endpoints
  // static const String getOrders = '/orders/';
  // static const String createOrder = '/orders/';
}

