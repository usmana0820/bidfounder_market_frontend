import 'package:flutter/material.dart';

import '../../../constants/app_constants.dart';
import '../../../navigation/app_router.dart';
import '../../../widgets/app_scaffold.dart';

/// My Ads Screen - Shows all user's ads with status counters
class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({super.key});

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  String _selectedFilter = 'all';

  final List<Map<String, dynamic>> _mockAds = [
    {
      'id': '1',
      'title': 'iPhone 15 Pro',
      'price': '\$999',
      'image': 'assets/images/Electronics.jpg',
      'status': 'active',
      'category': 'Electronics',
      'subcategory': 'Mobile Phones & Accessories',
      'createdAt': DateTime(2024, 1, 15),
      'views': 245,
      'bids': 12,
    },
    {
      'id': '2',
      'title': 'MacBook Pro',
      'price': '\$1,299',
      'image': 'assets/images/Electronics.jpg',
      'status': 'pending',
      'category': 'Electronics',
      'subcategory': 'Computers & Laptops',
      'createdAt': DateTime(2024, 1, 20),
    },
    {
      'id': '3',
      'title': 'Sofa Set',
      'price': '\$450',
      'image': 'assets/images/Home & Garden.jpg',
      'status': 'active',
      'category': 'Home & Garden',
      'subcategory': 'Furniture',
      'createdAt': DateTime(2024, 1, 18),
      'views': 89,
      'bids': 3,
    },
    {
      'id': '4',
      'title': 'Refrigerator',
      'price': '\$600',
      'image': 'assets/images/Home & Garden.jpg',
      'status': 'sold',
      'category': 'Home & Garden',
      'subcategory': 'Appliances',
      'createdAt': DateTime(2024, 1, 10),
    },
  ];

  Map<String, int> get _counts {
    return {
      'all': _mockAds.length,
      'pending': _mockAds.where((ad) => ad['status'] == 'pending').length,
      'active': _mockAds.where((ad) => ad['status'] == 'active').length,
      'sold': _mockAds.where((ad) => ad['status'] == 'sold').length,
      'rejected': _mockAds.where((ad) => ad['status'] == 'rejected').length,
    };
  }

  List<Map<String, dynamic>> get _filteredAds {
    if (_selectedFilter == 'all') {
      return _mockAds;
    }
    return _mockAds.where((ad) => ad['status'] == _selectedFilter).toList();
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

    final filters = [
      {'key': 'all', 'label': 'All'},
      {'key': 'pending', 'label': 'Pending'},
      {'key': 'active', 'label': 'Active'},
      {'key': 'sold', 'label': 'Sold'},
      {'key': 'rejected', 'label': 'Rejected'},
    ];

    return AppScaffold(
      title: 'My Ads',
      showBackButton: true, // Show back arrow on other screens
      showCart: false,
      showBottomNav: false, // Bottom nav is handled by MainScreen
      currentTabIndex: null,
      body: Column(
        children: [
          // Filter Tabs with Counters
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: borderColor, width: 1),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: filters.map((filter) {
                  final key = filter['key'] as String;
                  final isSelected = _selectedFilter == key;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = key;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(AppColors.primary)
                            : cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor, width: 1),
                      ),
                      child: Row(
                        children: [
                          Text(
                            filter['label'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : textColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            constraints: const BoxConstraints(minWidth: 24),
                            height: 24,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(AppColors.primary),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                '${_counts[key]}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? const Color(AppColors.primary)
                                      : Colors.white,
                                ),
                              ),
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

          // Ads List
          Expanded(
            child: _filteredAds.isEmpty
                ? Center(
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
                          'No ${_selectedFilter != 'all' ? _selectedFilter : ''} ads found',
                          style: TextStyle(
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: _filteredAds.length,
                    itemBuilder: (context, index) {
                      final ad = _filteredAds[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: GestureDetector(
                          onTap: () => _handleAdTap(ad),
                          child: Container(
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
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                  child: Image.asset(
                                    ad['image'] as String,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 120,
                                        height: 120,
                                        color: const Color(AppColors.grayLight),
                                        child: const Icon(Icons.image),
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                ad['title'] as String,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: textColor,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: _getStatusColor(ad['status'] as String),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                _getStatusLabel(ad['status'] as String),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          ad['price'] as String,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${ad['category']} • ${ad['subcategory']}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(AppColors.grayMedium),
                                          ),
                                        ),
                                        if (ad['status'] == 'active' && (ad['views'] != null || ad['bids'] != null)) ...[
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              if (ad['views'] != null) ...[
                                                const Icon(
                                                  Icons.visibility,
                                                  size: 12,
                                                  color: Color(AppColors.grayMedium),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${ad['views']} views',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Color(AppColors.grayMedium),
                                                  ),
                                                ),
                                                const SizedBox(width: 15),
                                              ],
                                              if (ad['bids'] != null) ...[
                                                const Icon(
                                                  Icons.gavel,
                                                  size: 12,
                                                  color: Color(AppColors.grayMedium),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${ad['bids']} bids',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Color(AppColors.grayMedium),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xFFFFA500);
      case 'active':
        return const Color(0xFF4CAF50);
      case 'sold':
        return const Color(AppColors.primary);
      case 'rejected':
        return const Color(0xFFF44336);
      default:
        return const Color(AppColors.grayMedium);
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'active':
        return 'Active';
      case 'sold':
        return 'Sold';
      case 'rejected':
        return 'Rejected';
      default:
        return status;
    }
  }

  void _handleAdTap(Map<String, dynamic> ad) {
    final status = ad['status'] as String;
    if (status == 'active') {
      Navigator.pushReplacementNamed(
        context,
        AppRouter.bidManagement,
        arguments: {'productId': ad['id']},
      );
    } else if (status == 'pending') {
      Navigator.pushReplacementNamed(
        context,
        AppRouter.productListing,
        arguments: {'adId': ad['id'], 'edit': 'true'},
      );
    }
  }
}
