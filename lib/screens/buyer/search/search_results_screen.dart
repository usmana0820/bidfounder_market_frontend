import 'package:flutter/material.dart';

import '../../../constants/app_constants.dart';
import '../../../models/product_model.dart';
import '../../../widgets/app_scaffold.dart';
import '../../../widgets/product_card.dart';
import '../../../widgets/search_bar.dart' as search_widget;

/// Search Results Screen - Shows search bar with filter and search results
class SearchResultsScreen extends StatefulWidget {
  final String? query;

  const SearchResultsScreen({super.key, this.query});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _sortBy;
  bool _showFilterModal = false;

  final List<Map<String, dynamic>> _searchResults = [
    {
      'id': '1',
      'title': 'iPhone 15 Pro',
      'price': '£999',
      'image': 'assets/images/Electronics.jpg',
      'category': 'Electronics',
      'location': 'London',
    },
    {
      'id': '2',
      'title': 'Samsung Galaxy S24',
      'price': '£899',
      'image': 'assets/images/Electronics.jpg',
      'category': 'Electronics',
      'location': 'Manchester',
    },
    {
      'id': '3',
      'title': 'MacBook Pro',
      'price': '£1,299',
      'image': 'assets/images/Electronics.jpg',
      'category': 'Electronics',
      'location': 'Birmingham',
    },
  ];

  final List<String> _sortOptions = [
    'Relevance',
    'Price: Low to High',
    'Price: High to Low',
    'Newest First',
    'Nearest First',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 45) / 2;
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
    final backgroundColor = isDark
        ? const Color(AppColors.darkBackground)
        : const Color(AppColors.background);

    return AppScaffold(
      title: 'Search Results',
      showBackButton: true,
      showCart: false,
      showBottomNav: false,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Search Bar
                search_widget.AppSearchBar(
                  value: _searchController.text,
                  onChangeText: (value) {
                    setState(() {
                      _searchController.text = value;
                    });
                  },
                  onFilterPress: () {
                    setState(() {
                      _showFilterModal = true;
                    });
                  },
                  placeholder: AppStrings.searchPlaceholder,
                  editable: true,
                  variant: 'compact',
                ),

                // Results Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          '${_searchResults.length} results for "${_searchController.text}"',
                          style: TextStyle(
                            fontSize: 14,
                            color: textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showFilterModal = true;
                          });
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.sort,
                              size: 16,
                              color: Color(AppColors.grayMedium),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _sortBy ?? 'Sort',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(AppColors.grayMedium),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Products Grid
                _searchResults.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search,
                              size: 48,
                              color: Color(AppColors.grayMedium),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No results found',
                              style: TextStyle(
                                fontSize: 16,
                                color: textColor,
                              ),
                            ),
                          ],
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
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final product = _searchResults[index];
                          return ProductCard(
                            product: Product(
                              id: product['id'] as String,
                              title: product['title'] as String,
                              price: product['price'] as String,
                              image: product['image'] as String,
                              category: product['category'] as String,
                              location: product['location'] as String,
                            ),
                            width: itemWidth,
                          );
                        },
                      ),
              ],
            ),
          ),
          // Filter/Sort Modal
          if (_showFilterModal) _buildSortModal(cardColor, borderColor, textColor, backgroundColor),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.query ?? '';
  }

  Widget _buildSortModal(
    Color cardColor,
    Color borderColor,
    Color textColor,
    Color backgroundColor,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showFilterModal = false;
        });
      },
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: GestureDetector(
          onTap: () {}, // Prevent closing when tapping inside
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                          'Sort By',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _showFilterModal = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  // Sort Options
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _sortOptions.length,
                      itemBuilder: (context, index) {
                        final option = _sortOptions[index];
                        final isSelected = _sortBy == option;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _sortBy = option;
                              _showFilterModal = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected ? backgroundColor : Colors.transparent,
                              border: Border(
                                bottom: BorderSide(color: borderColor, width: 1),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isSelected
                                        ? const Color(AppColors.primary)
                                        : textColor,
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Color(AppColors.primary),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
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
}
