import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../navigation/app_router.dart';
import '../../widgets/app_scaffold.dart';
import '../../services/product/subcategory_service.dart';
import '../../models/subcategory_model.dart';

/// Subcategories Screen - Sell Flow
class SubcategoriesScreen extends StatefulWidget {
  const SubcategoriesScreen({super.key});

  @override
  State<SubcategoriesScreen> createState() => _SubcategoriesScreenState();
}

class _SubcategoriesScreenState extends State<SubcategoriesScreen> {
  List<Subcategory> _subcategories = [];
  bool _isLoading = true;
  String? _error;

  String _categoryId = '';
  String _categoryName = '';
  String _categorySlug = '';

  @override
  void initState() {
    super.initState();
    // Delay to get context arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      _categoryId = args?['categoryId'] as String? ?? '';
      _categoryName = args?['categoryName'] as String? ?? '';
      _categorySlug = args?['categorySlug'] as String? ?? '';
      final passedSubs = args?['subcategories'] as List<dynamic>? ?? [];
      if (passedSubs.isNotEmpty) {
        _subcategories = passedSubs.map((e) => Subcategory(
          id: 0,
          categoryId: int.tryParse(_categoryId) ?? 0,
          categoryName: _categoryName,
          categorySlug: _categorySlug,
          name: e.toString(),
          slug: e.toString(),
        )).toList();
        _isLoading = false;
        setState(() {});
      }
      _loadSubcategories();
    });
  }

  Future<void> _loadSubcategories() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final subs = await SubcategoryService.getSubcategories(categorySlug: _categorySlug);
      if (mounted) {
        setState(() {
          _subcategories = subs;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load subcategories';
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

    void handleSubcategorySelect(Subcategory subcategory) {
      Navigator.pushNamed(
        context,
        AppRouter.productListing,
        arguments: {
          'categoryId': _categoryId,
          'categoryName': _categoryName,
          'subcategory': subcategory.name,
        },
      );
    }

    Widget body;
    if (_isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_subcategories.isEmpty) {
      body = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(AppColors.grayMedium)),
            const SizedBox(height: 12),
            Text(_error ?? 'No subcategories found'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadSubcategories,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else {
      body = ListView.separated(
        padding: const EdgeInsets.all(15),
        itemCount: _subcategories.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final subcategory = _subcategories[index];
          return GestureDetector(
            onTap: () => handleSubcategorySelect(subcategory),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      subcategory.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: Color(AppColors.grayMedium),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return AppScaffold(
      title: _categoryName,
      showBackButton: true,
      showCart: false,
      showBottomNav: false,
      body: body,
    );
  }
}
