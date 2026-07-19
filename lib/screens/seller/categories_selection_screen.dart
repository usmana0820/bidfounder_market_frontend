import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../models/category_model.dart';
import '../../navigation/app_router.dart';
import '../../services/product/category_service.dart';
import '../../services/product/subcategory_service.dart';
import '../../widgets/app_scaffold.dart';

/// Categories Selection Screen - Sell Flow
class CategoriesSelectionScreen extends StatefulWidget {
  const CategoriesSelectionScreen({super.key});

  @override
  State<CategoriesSelectionScreen> createState() => _CategoriesSelectionScreenState();
}

class _CategoriesSelectionScreenState extends State<CategoriesSelectionScreen> {
  String _activeTab = 'categories';

  // API-backed categories
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _error;

  final List<Map<String, dynamic>> _tabs = [
    {'id': 'categories', 'label': AppStrings.categoriesTab, 'icon': Icons.grid_view},
    {'id': 'drafts', 'label': AppStrings.draftsTab, 'icon': Icons.description},
    {'id': 'active', 'label': AppStrings.activeListingsTab, 'icon': Icons.check_circle},
    {'id': 'completed', 'label': AppStrings.completedTab, 'icon': Icons.check_circle_outline},
  ];

  List<Category> get _popularCategories => _categories.take(4).toList();
  List<Category> get _remainingCategories => _categories.skip(4).toList();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final cats = await CategoryService.getCategories();
      if (mounted) {
        setState(() {
          _categories = cats;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load categories';
      });
    }
  }

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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(AppColors.grayMedium)),
            const SizedBox(height: 12),
            Text(_error ?? 'No categories available'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadCategories,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

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
    Category category,
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
                    category.name,
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
                    category.description?.isNotEmpty == true
                        ? category.description!
                        : 'Tap to view subcategories',
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

  void _handleCategorySelect(Category category) async {
    final subcats = await SubcategoryService.getSubcategories(categorySlug: category.slug);

    Navigator.pushNamed(
      context,
      AppRouter.subcategories,
      arguments: {
        'categoryId': category.id.toString(),
        'categoryName': category.name,
        'categorySlug': category.slug,
        'subcategories': subcats.map((s) => s.name).toList(),
      },
    );
  }
}
