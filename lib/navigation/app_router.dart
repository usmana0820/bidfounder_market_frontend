import 'package:flutter/material.dart';

import '../main.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/otp_verify_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/buyer/cart/cart_screen.dart';
import '../screens/buyer/chat/chat_detail_screen.dart';
import '../screens/buyer/chat/chat_screen.dart';
import '../screens/buyer/payment/payment_gateway_screen.dart';
import '../screens/buyer/prizes/prizes_screen.dart';
import '../screens/buyer/products/product_detail_screen.dart';
import '../screens/buyer/search/search_results_screen.dart';
import '../screens/buyer/shipping/shipping_details_screen.dart';
import '../screens/buyer/shipping/shipping_track_screen.dart';
import '../screens/seller/bid_management_screen.dart';
import '../screens/seller/categories_selection_screen.dart';
import '../screens/seller/product_listing_screen.dart';
import '../screens/seller/products/my_ads_screen.dart';
import '../screens/seller/subcategories_screen.dart';
import '../screens/settings/account_settings_screen.dart';
import '../screens/settings/address_book_screen.dart';
import '../screens/settings/profile_screen.dart';
import '../screens/splash_screen.dart';

/// App Router - Handles all navigation routes
class AppRouter {
  static const String initialRoute = '/';

  // Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String otpVerify = '/otp-verify';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String dashboard = '/dashboard';
  static const String productDetail = '/product-detail';
  static const String searchResults = '/search-results';
  static const String cart = '/cart';
  static const String chat = '/chat';
  static const String chatDetail = '/chat-detail';
  static const String categoriesSelection = '/categories-selection';
  static const String subcategories = '/subcategories';
  static const String productListing = '/product-listing';
  static const String bidManagement = '/bid-management';
  static const String myAds = '/my-ads';
  static const String accountSettings = '/account-settings';
  static const String profile = '/profile';
  static const String addressBook = '/address-book';
  static const String paymentGateway = '/payment-gateway';
  static const String shippingDetails = '/shipping-details';
  static const String shippingTrack = '/shipping-track';
  static const String prizes = '/prizes';

  /// Generate routes
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );

      case otpVerify:
        return MaterialPageRoute(
          builder: (_) => OTPVerifyScreen(
            phoneNumber: args is Map<String, dynamic>
                ? args['phoneNumber'] as String?
                : null,
          ),
          settings: settings,
        );

      case forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
          settings: settings,
        );

      case resetPassword:
        return MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(
            email: args is Map<String, dynamic>
                ? args['email'] as String? ?? ''
                : '',
          ),
          settings: settings,
        );

      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
          settings: settings,
        );

      case productDetail:
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(
            productId: args is Map ? args['productId'] as String? : null,
            title: args is Map ? args['title'] as String? : null,
            price: args is Map ? args['price'] as String? : null,
            image: args is Map ? args['image'] : null,
            category: args is Map ? args['category'] as String? : null,
            location: args is Map ? args['location'] as String? : null,
            startBid: args is Map ? args['startBid'] as String? : null,
            currentBid: args is Map ? args['currentBid'] as String? : null,
            bidCount: args is Map ? args['bidCount'] as String? : null,
            sellerId: args is Map ? args['sellerId'] as String? : null,
            sellerName: args is Map ? args['sellerName'] as String? : null,
          ),
          settings: settings,
        );

      case searchResults:
        return MaterialPageRoute(
          builder: (_) => SearchResultsScreen(
            query: args is Map ? args['query'] as String? : null,
          ),
          settings: settings,
        );

      case cart:
        return MaterialPageRoute(
          builder: (_) => const CartScreen(),
          settings: settings,
        );

      case chat:
        return MaterialPageRoute(
          builder: (_) => const ChatScreen(),
          settings: settings,
        );

      case chatDetail:
        return MaterialPageRoute(
          builder: (_) => ChatDetailScreen(
            userId: args is Map ? args['userId'] as String? : null,
            userName: args is Map ? args['userName'] as String? : null,
            productId: args is Map ? args['productId'] as String? : null,
            productTitle: args is Map ? args['productTitle'] as String? : null,
          ),
          settings: settings,
        );

      case categoriesSelection:
        return MaterialPageRoute(
          builder: (_) => const CategoriesSelectionScreen(),
          settings: settings,
        );

      case subcategories:
        return MaterialPageRoute(
          builder: (_) => const SubcategoriesScreen(),
          settings: settings,
        );

      case productListing:
        return MaterialPageRoute(
          builder: (_) => ProductListingScreen(
            categoryName: args is Map ? args['categoryName'] as String? : null,
            subcategory: args is Map ? args['subcategory'] as String? : null,
          ),
          settings: settings,
        );

      case bidManagement:
        return MaterialPageRoute(
          builder: (_) => const BidManagementScreen(),
          settings: settings,
        );

      case myAds:
        return MaterialPageRoute(
          builder: (_) => const MyAdsScreen(),
          settings: settings,
        );

      case accountSettings:
        return MaterialPageRoute(
          builder: (_) => const AccountSettingsScreen(),
          settings: settings,
        );

      case profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
          settings: settings,
        );

      case addressBook:
        return MaterialPageRoute(
          builder: (_) => const AddressBookScreen(),
          settings: settings,
        );

      case paymentGateway:
        return MaterialPageRoute(
          builder: (_) => PaymentGatewayScreen(
            productId: args is Map ? args['productId'] as String? : null,
            productTitle: args is Map ? args['productTitle'] as String? : null,
            amount: args is Map ? args['amount'] as String? : null,
            sellerId: args is Map ? args['sellerId'] as String? : null,
            sellerName: args is Map ? args['sellerName'] as String? : null,
          ),
          settings: settings,
        );

      case shippingDetails:
        return MaterialPageRoute(
          builder: (_) => ShippingDetailsScreen(
            productId: args is Map ? args['productId'] as String? : null,
            productTitle: args is Map ? args['productTitle'] as String? : null,
            amount: args is Map ? args['amount'] as String? : null,
            paymentMethod: args is Map ? args['paymentMethod'] as String? : null,
            sellerId: args is Map ? args['sellerId'] as String? : null,
            sellerName: args is Map ? args['sellerName'] as String? : null,
          ),
          settings: settings,
        );

      case shippingTrack:
        return MaterialPageRoute(
          builder: (_) => const ShippingTrackScreen(),
          settings: settings,
        );

      case prizes:
        return MaterialPageRoute(
          builder: (_) => const PrizesScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route not found: ${settings.name}'),
            ),
          ),
          settings: settings,
        );
    }
  }
}
