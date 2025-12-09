/// App Theme Colors - All colors used in the app
class AppColors {
  // Brand Colors
  static const int primary = 0xFF0C2B4E; // Main brand color, header, buttons
  static const int secondary = 0xFF1A3D64; // Secondary color, tabs, cards
  static const int accent = 0xFF1D546C; // Accent color, highlights
  static const int background = 0xFFF4F4F4; // App background

  // Standard Colors
  static const int white = 0xFFFFFFFF;
  static const int black = 0xFF000000;
  static const int grayLight = 0xFFF0F0F0;
  static const int grayMedium = 0xFF999999;
  static const int grayDark = 0xFF666666;
  static const int grayPlaceholder = 0xFF999999;

  // UI Colors
  static const int shadow = 0xFF000000;
  static const int textDark = 0xFF1a1a1a;

  // Dark Theme Colors
  static const int darkBackground = 0xFF000000;
  static const int darkText = 0xFFFFFFFF;
  static const int darkCard = 0xFF1a1a1a;
  static const int darkBorder = 0xFF333333;

  // Status Colors
  static const int error = 0xFFF44336;
  static const int success = 0xFF4CAF50;
  static const int warning = 0xFFFF9800;
}

/// App Strings - All text strings used in the app
class AppStrings {
  // App Info
  static const String appName = 'BidFounder Market';
  static const String welcome = 'Welcome';
  static const String welcomeBack = 'Welcome Back';

  // Navigation
  static const String home = 'Home';
  static const String chat = 'Chat';
  static const String sell = 'Sell';
  static const String myAds = 'My Ads';
  static const String settings = 'Settings';
  static const String accountSettings = 'Account Settings';
  static const String profile = 'Profile';
  static const String menu = 'Menu';
  static const String logout = 'Logout';

  // Login
  static const String login = 'Login';
  static const String loggingIn = 'Logging in...';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String phoneNumberLabel = 'Phone Number';
  static const String phoneNumberPlaceholder = '3001234567';
  static const String phoneNumberHint = 'Enter your 10-digit phone number';
  static const String next = 'Next';
  static const String otpVerification = 'OTP Verification';
  static const String otpTitle = 'Enter Verification Code';
  static const String otpSubtitle = 'We sent a 6-digit code to {phone}';
  static const String verify = 'Verify';
  static const String resendOtp = 'Resend OTP';
  static const String setPassword = 'Set Password';
  static const String setPasswordTitle = 'Create Your Password';
  static const String setPasswordSubtitle = 'Choose a strong password to secure your account';
  static const String confirmPassword = 'Confirm Password';
  static const String confirmPasswordPlaceholder = 'Re-enter your password';
  static const String passwordPlaceholder = 'Enter your password';
  static const String passwordHint = 'Password must be at least 6 characters';
  static const String show = 'Show';
  static const String hide = 'Hide';
  static const String createAccount = 'Create Account';

  // Dashboard
  static const String dashboardReady = 'Your dashboard is ready!';
  static const String quickStats = 'Quick Stats';
  static const String recentActivity = 'Recent Activity';
  static const String totalItems = 'Total Items';
  static const String activeBids = 'Active Bids';
  static const String noRecentActivity = 'No recent activity';
  static const String searchPlaceholder = 'Search for products...';
  static const String categories = 'Categories';
  static const String popularCategories = 'Popular Categories';
  static const String featuredProducts = 'Featured Products';
  static const String recentProducts = 'Recent Products';
  static const String allCategories = 'All Categories';
  static const String electronics = 'Electronics';
  static const String mobile = 'Mobile';
  static const String furniture = 'Furniture';
  static const String homeAppliances = 'Home Appliances';
  static const String vehicles = 'Vehicles';
  static const String filters = 'Filters';
  static const String sortBy = 'Sort By';
  static const String priceLowToHigh = 'Price: Low to High';
  static const String priceHighToLow = 'Price: High to Low';
  static const String newestFirst = 'Newest First';
  static const String oldestFirst = 'Oldest First';
  static const String sortByNearest = 'Nearest First';
  static const String applyFilters = 'Apply Filters';
  static const String clearFilters = 'Clear Filters';
  static const String locationPermissionTitle = 'Location Permission';
  static const String locationPermissionMessage = 'We need your location to show nearby products and services';
  static const String grantPermission = 'Grant Permission';
  static const String locationAccessDenied = 'Location access denied';
  static const String nearbyProducts = 'Nearby Products';
  static const String noProducts = 'No products available';
  static const String priceRange = 'Price Range';
  static const String minPrice = 'Min Price';
  static const String maxPrice = 'Max Price';
  static const String location = 'Location';
  static const String filterByLocation = 'Filter by Location';
  static const String locationPlaceholder = 'Enter city or postcode';

  // Category names
  static const String fashion = 'Fashion';
  static const String homeGarden = 'Home & Garden';
  static const String sportsOutdoors = 'Sports & Outdoors';
  static const String toysKidsBaby = 'Toys, Kids & Baby';
  static const String booksMusicMedia = 'Books, Music & Media';
  static const String healthBeauty = 'Health & Beauty';
  static const String collectiblesArt = 'Collectibles & Art';
  static const String petSupplies = 'Pet Supplies';
  static const String musicalInstruments = 'Musical Instruments';
  static const String industrialBusiness = 'Industrial & Business';
  static const String miscellaneous = 'Miscellaneous / Other';

  // Screens
  static const String chatDescription = 'Your conversations will appear here';
  static const String myAdsDescription = 'Your posted ads will appear here';
  static const String profileSettings = 'Profile Settings';
  static const String profileSettingsDesc = 'Manage your profile information';
  static const String security = 'Security';
  static const String securityDesc = 'Change password and security settings';
  static const String notifications = 'Notifications';
  static const String notificationsDesc = 'Manage notification preferences';
  static const String privacy = 'Privacy';

  // Loading
  static const String splashLoading = 'Loading...';

  // Cart
  static const String cartCount = '0';
  static const String addToCart = 'Add to Cart';
  static const String addedToCart = 'Added to Cart';
  static const String proceedToCheckout = 'Proceed to Checkout';
  static const String clearCart = 'Clear Cart';
  static const String yourCartIsEmpty = 'Your cart is empty';
  static const String addItemsToCart = 'Add items to your cart to see them here';
  static const String browseProducts = 'Browse Products';
  static const String totalItemsLabel = 'Total Items:';
  static const String subtotal = 'Subtotal:';
  static const String removeItem = 'Remove Item';
  static const String removeFromCart = 'Remove from cart?';

  // Profile
  static const String userName = 'User Name';
  static const String userEmail = 'user@example.com';

  // Help & Support
  static const String helpAndSupport = 'Help & Support';
  static const String faq = 'FAQ';
  static const String contactUs = 'Contact Us';
  static const String reportIssue = 'Report an Issue';

  // Sell Screen Tabs
  static const String categoriesTab = 'Categories';
  static const String draftsTab = 'Drafts';
  static const String activeListingsTab = 'Active Listings';
  static const String completedTab = 'Completed';
}

