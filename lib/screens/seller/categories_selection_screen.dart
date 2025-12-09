import 'dart:convert';

import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../navigation/app_router.dart';
import '../../widgets/app_scaffold.dart';

/// Categories Selection Screen - Sell Flow
class CategoriesSelectionScreen extends StatefulWidget {
  const CategoriesSelectionScreen({super.key});

  @override
  State<CategoriesSelectionScreen> createState() => _CategoriesSelectionScreenState();
}

class _CategoriesSelectionScreenState extends State<CategoriesSelectionScreen> {
  String _activeTab = 'categories';

  final List<Map<String, dynamic>> _tabs = [
    {'id': 'categories', 'label': AppStrings.categoriesTab, 'icon': Icons.grid_view},
    {'id': 'drafts', 'label': AppStrings.draftsTab, 'icon': Icons.description},
    {'id': 'active', 'label': AppStrings.activeListingsTab, 'icon': Icons.check_circle},
    {'id': 'completed', 'label': AppStrings.completedTab, 'icon': Icons.check_circle_outline},
  ];

  final List<Map<String, dynamic>> _allCategories = [
    {
      'id': 'electronics',
      'name': AppStrings.electronics,
      'subcategories': [
        'Mobile Phones & Accessories',
        'Computers & Laptops',
        'Tablets & e-Readers',
        'Cameras & Photography',
        'Audio & Headphones',
        'Wearable Tech (Smartwatches, Fitness Bands)',
        'TV & Home Entertainment',
        'Gaming Consoles & Accessories',
        'Other Electronics',
      ],
    },
    {
      'id': 'fashion',
      'name': AppStrings.fashion,
      'subcategories': [
        "Men's Clothing",
        "Women's Clothing",
        'Kids & Baby Clothing',
        'Shoes & Footwear',
        'Bags & Accessories',
        'Watches & Jewelry',
        'Sunglasses & Eyewear',
        'Beauty & Personal Care',
      ],
    },
    {
      'id': 'home-garden',
      'name': AppStrings.homeGarden,
      'subcategories': [
        'Furniture (Living Room, Bedroom, Office)',
        'Kitchen & Dining',
        'Home Decor',
        'Garden & Outdoor',
        'DIY Tools & Supplies',
        'Appliances (Small & Large)',
        'Bedding & Linen',
      ],
    },
    {
      'id': 'vehicles',
      'name': AppStrings.vehicles,
      'subcategories': [
        'Cars',
        'Motorcycles',
        'Car Parts & Accessories',
        'Bikes & Scooters',
        'Car Electronics & GPS',
        'Tools & Garage Equipment',
      ],
    },
    {
      'id': 'sports-outdoors',
      'name': AppStrings.sportsOutdoors,
      'subcategories': [
        'Exercise & Fitness Equipment',
        'Outdoor Recreation (Camping, Hiking)',
        'Cycling & Accessories',
        'Team Sports Equipment',
        'Water Sports & Swimming',
        'Winter Sports',
      ],
    },
    {
      'id': 'toys-kids-baby',
      'name': AppStrings.toysKidsBaby,
      'subcategories': [
        'Baby Products & Gear',
        'Toys & Games',
        'Educational Toys',
        'Baby Clothing & Accessories',
      ],
    },
    {
      'id': 'books-music-media',
      'name': AppStrings.booksMusicMedia,
      'subcategories': [
        'Books (Fiction, Non-Fiction, Academic)',
        'Music CDs & Vinyl',
        'Movies & DVDs',
        'Video Games',
        'Magazines & Comics',
      ],
    },
    {
      'id': 'health-beauty',
      'name': AppStrings.healthBeauty,
      'subcategories': [
        'Skincare & Cosmetics',
        'Haircare & Styling',
        'Personal Care (Shaving, Hygiene)',
        'Vitamins & Supplements',
        'Fragrances',
      ],
    },
    {
      'id': 'collectibles-art',
      'name': AppStrings.collectiblesArt,
      'subcategories': [
        'Antiques',
        'Art & Paintings',
        'Coins & Stamps',
        'Memorabilia & Collectibles',
        'Handcrafted Items',
      ],
    },
    {
      'id': 'pet-supplies',
      'name': AppStrings.petSupplies,
      'subcategories': [
        'Pet Food & Treats',
        'Pet Toys & Accessories',
        'Pet Grooming',
        'Aquatic & Small Pets',
      ],
    },
    {
      'id': 'musical-instruments',
      'name': AppStrings.musicalInstruments,
      'subcategories': [
        'Guitars & String Instruments',
        'Keyboards & Pianos',
        'Drums & Percussion',
        'DJ & Studio Equipment',
        'Wind & Brass Instruments',
      ],
    },
    {
      'id': 'industrial-business',
      'name': AppStrings.industrialBusiness,
      'subcategories': [
        'Tools & Machinery',
        'Office Equipment & Supplies',
        'Safety & Security',
        'Commercial Appliances',
      ],
    },
    {
      'id': 'miscellaneous',
      'name': AppStrings.miscellaneous,
      'subcategories': ['Everything Else', 'Freebies / Giveaways', 'Services'],
    },
  ];

  List<Map<String, dynamic>> get _popularCategories => _allCategories.take(4).toList();
  List<Map<String, dynamic>> get _remainingCategories => _allCategories.skip(4).toList();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(AppColors.darkCard)
        : const Color(AppColors.white);
    final borderColor = isDark
        ? const Color(AppColors.darkBorder)
        : const Color(AppColors.grayLight);
    final textColor = isDark
        ? const Color(AppColors.darkText)
        : const Color(AppColors.black);

    return AppScaffold(
      title: AppStrings.sell,
      showBackButton: true, // Show back arrow on other screens
      showCart: false,
      showBottomNav: false, // Bottom nav is handled by MainScreen
      currentTabIndex: null,
      body: Column(
        children: [
          // Custom Tab Bar
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              border: Border(
                bottom: BorderSide(color: borderColor, width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: _tabs.map((tab) {
                  final isActive = _activeTab == tab['id'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _activeTab = tab['id'] as String;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(AppColors.primary)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor, width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            tab['icon'] as IconData,
                            size: 16,
                            color: isActive
                                ? Colors.white
                                : textColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            tab['label'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isActive
                                  ? Colors.white
                                  : textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Tab Content
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _buildCategoriesContent() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(AppColors.darkCard)
        : const Color(AppColors.white);
    final borderColor = isDark
        ? const Color(AppColors.darkBorder)
        : const Color(AppColors.grayLight);
    final textColor = isDark
        ? const Color(AppColors.darkText)
        : const Color(AppColors.black);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Popular Categories Section
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.popularCategories,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 15),
                ..._popularCategories.map((category) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildCategoryCard(category, cardColor, borderColor, textColor),
                    )),
              ],
            ),
          ),
          // All Categories Section
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 15),
                ..._remainingCategories.map((category) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildCategoryCard(category, cardColor, borderColor, textColor),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    Map<String, dynamic> category,
    Color cardColor,
    Color borderColor,
    Color textColor,
  ) {
    return GestureDetector(
      onTap: () => _handleCategorySelect(category),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category['name'] as String,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(category['subcategories'] as List).length} subcategories',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(AppColors.grayMedium),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: Color(AppColors.grayMedium),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? const Color(AppColors.darkText)
        : const Color(AppColors.black);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: const Color(AppColors.grayMedium),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_activeTab) {
      case 'categories':
        return _buildCategoriesContent();
      case 'drafts':
        return _buildEmptyState(Icons.description, 'No drafts yet');
      case 'active':
        return _buildEmptyState(Icons.check_circle, 'No active listings');
      case 'completed':
        return _buildEmptyState(Icons.check_circle_outline, 'No completed listings');
      default:
        return const SizedBox();
    }
  }

  void _handleCategorySelect(Map<String, dynamic> category) {
    Navigator.pushReplacementNamed(
      context,
      AppRouter.subcategories,
      arguments: {
        'categoryId': category['id'],
        'categoryName': category['name'],
        'subcategories': jsonEncode(category['subcategories']),
      },
    );
  }
}
