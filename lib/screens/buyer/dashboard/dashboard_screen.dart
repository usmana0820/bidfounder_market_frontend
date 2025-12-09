import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as geo;

import '../../../constants/app_constants.dart';
import '../../../models/product_model.dart';
import '../../../navigation/app_router.dart';
import '../../../widgets/app_scaffold.dart';
import '../../../widgets/product_card.dart';
import '../../../widgets/search_bar.dart' as search_widget;

List<Product> _generateMockProducts() {
  final categories = ['electronics', 'fashion', 'home-garden', 'vehicles'];
  final locations = ['Lahore', 'Karachi', 'Islamabad', 'Faisalabad'];
  final categoryImages = {
    'electronics': 'assets/images/Electronics.jpg',
    'fashion': 'assets/images/Fashion.jpg',
    'home-garden': 'assets/images/Home & Garden.jpg',
    'vehicles': 'assets/images/Vehicles.jpg',
  };

  return List.generate(20, (index) {
    final category = categories[index % categories.length];
    return Product(
      id: '${index + 1}',
      title: 'Product ${index + 1}',
      price: '\$${(Random().nextInt(900) + 100).toString()}',
      image: categoryImages[category] ?? 'assets/images/Electronics.jpg',
      category: category,
      location: locations[index % locations.length],
    );
  });
}

/// Dashboard Screen - Main home screen with categories, ads, and products
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _adPageController = PageController();
  int _currentAdIndex = 0;
  String _searchQuery = '';
  String? _selectedCategory;
  bool _showFilters = false;
  String? _sortBy;
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _locationFilterController = TextEditingController();
  String? _userLocationName;

  final List<Product> _allProducts = _generateMockProducts();
  List<Product> _filteredProducts = [];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 45) / 2;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(AppColors.darkCard)
        : const Color(AppColors.white);
    final textColor = isDark
        ? const Color(AppColors.darkText)
        : const Color(AppColors.black);

    return AppScaffold(
      title: AppStrings.home,
      showBackButton: false, // Show hamburger on dashboard
      showCart: true,
      showGift: true,
      showBottomNav: false, // Bottom nav is handled by MainScreen
      currentTabIndex: null,
      roundedCorners: true, // Rounded corners only for dashboard
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
              // Search Bar
              search_widget.AppSearchBar(
                value: _searchQuery,
                onChangeText: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                  _applyFilters();
                },
                onPress: () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.searchResults,
                    arguments: {'query': _searchQuery},
                  );
                },
                onFilterPress: () {
                  setState(() {
                    _showFilters = true;
                  });
                },
                placeholder: _userLocationName != null
                    ? 'You Are In $_userLocationName...'
                    : AppStrings.searchPlaceholder,
                editable: false,
              ),

              // Ads Carousel
              _buildAdsCarousel(screenWidth, cardColor),

              // Categories
              _buildCategories(cardColor, textColor),

              // Products Grid
              _filteredProducts.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox,
                              size: 48,
                              color: const Color(AppColors.grayMedium),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppStrings.noProducts,
                              style: TextStyle(
                                fontSize: 16,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(15),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 0.68, // Adjusted to prevent overflow
                      ),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: _filteredProducts[index],
                          width: itemWidth,
                        );
                      },
                    ),
              ],
            ),
          ),
          // Filters Modal
          if (_showFilters) _buildFiltersModal(context),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _adPageController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _locationFilterController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _filteredProducts = _allProducts;
    _requestLocationPermission();
  }

  void _applyFilters() {
    setState(() {
      var filtered = List<Product>.from(_allProducts);

      // Filter by category
      if (_selectedCategory != null) {
        filtered = filtered
            .where((p) => p.category == _selectedCategory)
            .toList();
      }

      // Filter by search query
      if (_searchQuery.trim().isNotEmpty) {
        filtered = filtered
            .where((p) =>
                p.title.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();
      }

      // Filter by price range
      final minPrice = _minPriceController.text;
      final maxPrice = _maxPriceController.text;
      if (minPrice.isNotEmpty || maxPrice.isNotEmpty) {
        filtered = filtered.where((p) {
          final price = _parsePrice(p.price);
          final min = minPrice.isEmpty ? 0.0 : double.tryParse(minPrice) ?? 0.0;
          final max = maxPrice.isEmpty
              ? double.infinity
              : double.tryParse(maxPrice) ?? double.infinity;
          return price >= min && price <= max;
        }).toList();
      }

      // Filter by location
      final locationFilter = _locationFilterController.text;
      if (locationFilter.trim().isNotEmpty) {
        filtered = filtered
            .where((p) => p.location
                .toLowerCase()
                .contains(locationFilter.toLowerCase()))
            .toList();
      }

      // Sort products
      if (_sortBy != null) {
        filtered.sort((a, b) {
          switch (_sortBy) {
            case AppStrings.priceLowToHigh:
              return _parsePrice(a.price).compareTo(_parsePrice(b.price));
            case AppStrings.priceHighToLow:
              return _parsePrice(b.price).compareTo(_parsePrice(a.price));
            default:
              return 0;
          }
        });
      }

      _filteredProducts = filtered;
    });
  }

  Widget _buildAdsCarousel(double width, Color cardColor) {
    final ads = [
      'assets/images/Special Offer.jpg',
      'assets/images/Flash Sale.jpg',
      'assets/images/Best Deals.jpg',
      'assets/images/Special Offer1.jpg',
      'assets/images/Flash Sale1.jpg',
      'assets/images/Best Deals1.jpg',
    ];

    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          PageView.builder(
            controller: _adPageController,
            onPageChanged: (index) {
              setState(() {
                _currentAdIndex = index;
              });
            },
            itemCount: ads.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    ads[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(AppColors.grayLight),
                        child: const Icon(Icons.image, size: 50),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          // Indicators
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(ads.length, (index) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentAdIndex == index
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(Color cardColor, Color textColor) {
    final categories = [
      {'id': 'electronics', 'name': AppStrings.electronics, 'image': 'assets/images/Electronics.jpg'},
      {'id': 'fashion', 'name': AppStrings.fashion, 'image': 'assets/images/Fashion.jpg'},
      {'id': 'home-garden', 'name': AppStrings.homeGarden, 'image': 'assets/images/Home & Garden.jpg'},
      {'id': 'vehicles', 'name': AppStrings.vehicles, 'image': 'assets/images/Vehicles.jpg'},
      {'id': 'sports-outdoors', 'name': AppStrings.sportsOutdoors, 'image': 'assets/images/Sports & Outdoors.jpg'},
      {'id': 'toys-kids-baby', 'name': AppStrings.toysKidsBaby, 'image': 'assets/images/Toys, Kids & Baby.jpg'},
      {'id': 'books-music-media', 'name': AppStrings.booksMusicMedia, 'image': 'assets/images/Books, Music & Media.jpg'},
      {'id': 'health-beauty', 'name': AppStrings.healthBeauty, 'image': 'assets/images/Health & Beauty.jpg'},
      {'id': 'musical-instruments', 'name': AppStrings.musicalInstruments, 'image': 'assets/images/Musical Instruments.jpg'},
      {'id': 'industrial-business', 'name': AppStrings.industrialBusiness, 'image': 'assets/images/Industrial & Business.jpg'},
      {'id': 'miscellaneous', 'name': AppStrings.miscellaneous, 'image': 'assets/images/Miscellaneous.jpg'},
    ];

    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            // All Categories button
            final isSelected = _selectedCategory == null;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = null;
                });
                _applyFilters();
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(AppColors.primary)
                      : cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(AppColors.primary)
                        : const Color(AppColors.grayLight),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    AppStrings.allCategories,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : textColor,
                    ),
                  ),
                ),
              ),
            );
          }

          final category = categories[index - 1];
          final isSelected = _selectedCategory == category['id'];

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category['id'] as String;
              });
              _applyFilters();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(AppColors.primary)
                    : cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(AppColors.primary)
                      : const Color(AppColors.grayLight),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      category['image'] as String,
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(width: 24, height: 24);
                      },
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    category['name'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : textColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFiltersModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(AppColors.darkCard)
        : const Color(AppColors.white);
    final backgroundColor = isDark
        ? const Color(AppColors.darkBackground)
        : const Color(AppColors.background);
    final textColor = isDark
        ? const Color(AppColors.darkText)
        : const Color(AppColors.black);
    final borderColor = isDark
        ? const Color(AppColors.darkBorder)
        : const Color(AppColors.grayLight);

    final categories = [
      {'id': 'electronics', 'name': AppStrings.electronics},
      {'id': 'fashion', 'name': AppStrings.fashion},
      {'id': 'home-garden', 'name': AppStrings.homeGarden},
      {'id': 'vehicles', 'name': AppStrings.vehicles},
      {'id': 'sports-outdoors', 'name': AppStrings.sportsOutdoors},
    ];

    final sortOptions = [
      AppStrings.priceLowToHigh,
      AppStrings.priceHighToLow,
      AppStrings.newestFirst,
      AppStrings.oldestFirst,
      AppStrings.sortByNearest,
    ];

    return GestureDetector(
      onTap: () {
        setState(() {
          _showFilters = false;
        });
      },
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: GestureDetector(
          onTap: () {}, // Prevent closing when tapping inside
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: borderColor, width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.filters,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _showFilters = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  // Filters Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category Filter
                          Text(
                            AppStrings.categories,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 50,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  final isSelected = _selectedCategory == null;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedCategory = null;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(AppColors.primary)
                                            : backgroundColor,
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(color: borderColor),
                                      ),
                                      child: Center(
                                        child: Text(
                                          AppStrings.allCategories,
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : textColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                final category = categories[index - 1];
                                final isSelected = _selectedCategory == category['id'];
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedCategory = category['id'] as String;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(AppColors.primary)
                                          : backgroundColor,
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(color: borderColor),
                                    ),
                                    child: Center(
                                      child: Text(
                                        category['name'] as String,
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Price Range
                          Text(
                            AppStrings.priceRange,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppStrings.minPrice,
                                      style: TextStyle(color: textColor),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: _minPriceController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: '\$0',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: borderColor),
                                        ),
                                        filled: true,
                                        fillColor: backgroundColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppStrings.maxPrice,
                                      style: TextStyle(color: textColor),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: _maxPriceController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: '\$9999',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: borderColor),
                                        ),
                                        filled: true,
                                        fillColor: backgroundColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          // Location Filter
                          Text(
                            AppStrings.filterByLocation,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _locationFilterController,
                            decoration: InputDecoration(
                              hintText: AppStrings.locationPlaceholder,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: borderColor),
                              ),
                              filled: true,
                              fillColor: backgroundColor,
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Sort By
                          Text(
                            AppStrings.sortBy,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...sortOptions.map((option) {
                            final isSelected = _sortBy == option;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _sortBy = isSelected ? null : option;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(AppColors.primary)
                                        : borderColor,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      option,
                                      style: TextStyle(
                                        color: isSelected
                                            ? const Color(AppColors.primary)
                                            : textColor,
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(
                                        Icons.check,
                                        color: Color(AppColors.primary),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  // Buttons
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: borderColor, width: 1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _clearFilters,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: borderColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              AppStrings.clearFilters,
                              style: TextStyle(color: textColor),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _applyFilters();
                              setState(() {
                                _showFilters = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(AppColors.primary),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              AppStrings.applyFilters,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = null;
      _searchQuery = '';
      _sortBy = null;
      _minPriceController.clear();
      _maxPriceController.clear();
      _locationFilterController.clear();
      _filteredProducts = _allProducts;
    });
  }

  double _parsePrice(String price) {
    return double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
  }

  Future<void> _requestLocationPermission() async {
    // Check if location services are enabled
    bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location services are disabled. Please enable them in settings.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    // Check location permission status
    geo.LocationPermission permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permissions are denied. Please enable them in settings.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }
    }

    if (permission == geo.LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permissions are permanently denied. Please enable them in app settings.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    // Permission granted, get location
    if (permission == geo.LocationPermission.whileInUse || permission == geo.LocationPermission.always) {
      try {
        final position = await geo.Geolocator.getCurrentPosition(
          desiredAccuracy: geo.LocationAccuracy.high,
        );

        // Try to get place name from coordinates using reverse geocoding
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );

          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            // Build location name from placemark
            String locationName = '';
            
            // Try to get city or locality first
            if (place.locality != null && place.locality!.isNotEmpty) {
              locationName = place.locality!;
            } else if (place.subAdministrativeArea != null && place.subAdministrativeArea!.isNotEmpty) {
              locationName = place.subAdministrativeArea!;
            } else if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
              locationName = place.administrativeArea!;
            } else if (place.country != null && place.country!.isNotEmpty) {
              locationName = place.country!;
            }
            
            // If we have a street, add it
            if (place.street != null && place.street!.isNotEmpty && locationName.isEmpty) {
              locationName = place.street!;
            }

            // Fallback to coordinates if no name found
            if (locationName.isEmpty) {
              locationName = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
            }

            if (mounted) {
              setState(() {
                _userLocationName = locationName;
              });
            }
          } else {
            // No placemarks found, use coordinates
            if (mounted) {
              setState(() {
                _userLocationName = '${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}';
              });
            }
          }
        } catch (e) {
          // If reverse geocoding fails, use coordinates
          debugPrint('Error getting place name: $e');
          if (mounted) {
            setState(() {
              _userLocationName = '${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}';
            });
          }
        }
      } catch (e) {
        debugPrint('Error getting location: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error getting location: ${e.toString()}'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }
}
