import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

/// AppSearchBar Widget - Reusable search bar with filter icon
class AppSearchBar extends StatelessWidget {
  final String value;
  final ValueChanged<String>? onChangeText;
  final VoidCallback? onPress;
  final VoidCallback? onFilterPress;
  final String placeholder;
  final bool editable;
  final bool showFilter;
  final String variant; // 'default' or 'compact'

  const AppSearchBar({
    super.key,
    required this.value,
    this.onChangeText,
    this.onPress,
    this.onFilterPress,
    this.placeholder = AppStrings.searchPlaceholder,
    this.editable = true,
    this.showFilter = true,
    this.variant = 'default',
  });

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

    final isCompact = variant == 'compact';

    return Container(
      margin: isCompact ? EdgeInsets.zero : const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: isCompact ? null : BorderRadius.circular(10),
        border: Border(
          bottom: isCompact
              ? BorderSide(color: borderColor, width: 1)
              : BorderSide.none,
          top: isCompact ? BorderSide.none : BorderSide(color: borderColor, width: 1),
          left: isCompact ? BorderSide.none : BorderSide(color: borderColor, width: 1),
          right: isCompact ? BorderSide.none : BorderSide(color: borderColor, width: 1),
        ),
        boxShadow: isCompact
            ? null
            : [
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
            child: onPress != null
                ? GestureDetector(
                    onTap: onPress,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            size: 18,
                            color: const Color(AppColors.grayMedium),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            value.isEmpty ? placeholder : value,
                            style: TextStyle(
                              color: value.isEmpty
                                  ? const Color(AppColors.grayPlaceholder)
                                  : textColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : TextField(
                    onChanged: onChangeText,
                    enabled: editable,
                    style: TextStyle(color: textColor, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: placeholder,
                      hintStyle: const TextStyle(
                        color: Color(AppColors.grayPlaceholder),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 18,
                        color: Color(AppColors.grayMedium),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),
                    ),
                  ),
          ),
          if (showFilter)
            IconButton(
              icon: const Icon(
                Icons.tune,
                color: Color(AppColors.primary),
                size: 18,
              ),
              onPressed: onFilterPress,
              padding: const EdgeInsets.all(5),
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
