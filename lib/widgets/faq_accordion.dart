import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

/// FAQ Accordion Widget - Displays FAQ items in an accordion style
class FAQAccordion extends StatefulWidget {
  final FAQItem item;
  final int? index;
  final String variant; // 'default' or 'compact'

  const FAQAccordion({
    super.key,
    required this.item,
    this.index,
    this.variant = 'default',
  });

  @override
  State<FAQAccordion> createState() => _FAQAccordionState();
}

/// FAQ Item Model
class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}

class _FAQAccordionState extends State<FAQAccordion> {
  bool _isExpanded = false;

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
    final primaryColor = const Color(AppColors.primary);

    final isCompact = widget.variant == 'compact';

    return Container(
      margin: EdgeInsets.only(bottom: isCompact ? 8 : 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(isCompact ? 6 : 8),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: EdgeInsets.all(isCompact ? 12 : 15),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.item.question,
                      style: TextStyle(
                        fontSize: isCompact ? 13 : 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                      maxLines: _isExpanded ? null : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: isCompact ? 14 : 16,
                    color: primaryColor,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Container(
              padding: EdgeInsets.only(
                left: isCompact ? 12 : 15,
                right: isCompact ? 12 : 15,
                bottom: isCompact ? 12 : 15,
              ),
              child: Text(
                widget.item.answer,
                style: TextStyle(
                  fontSize: isCompact ? 12 : 14,
                  height: isCompact ? 1.5 : 1.43,
                  color: textColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

