import 'dart:convert';

import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../navigation/app_router.dart';
import '../../widgets/app_scaffold.dart';

/// Subcategories Screen - Sell Flow
class SubcategoriesScreen extends StatelessWidget {
  const SubcategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final categoryId = args?['categoryId'] as String? ?? '';
    final categoryName = args?['categoryName'] as String? ?? '';
    final subcategoriesJson = args?['subcategories'] as String? ?? '[]';
    final subcategories = (jsonDecode(subcategoriesJson) as List)
        .map((e) => e as String)
        .toList();

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

    void handleSubcategorySelect(String subcategory) {
      Navigator.pushReplacementNamed(
        context,
        AppRouter.productListing,
        arguments: {
          'categoryId': categoryId,
          'categoryName': categoryName,
          'subcategory': subcategory,
        },
      );
    }

    return AppScaffold(
      title: categoryName,
      showBackButton: true,
      showCart: false,
      showBottomNav: false,
      body: ListView.separated(
        padding: const EdgeInsets.all(15),
        itemCount: subcategories.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final subcategory = subcategories[index];
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
                      subcategory,
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
      ),
    );
  }
}
