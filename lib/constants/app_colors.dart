import 'package:flutter/material.dart';
import 'app_constants.dart';

/// Theme colors for light and dark mode
class AppThemeColors {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(AppColors.primary),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Color(AppColors.background),
    primaryColor: Color(AppColors.primary),
    cardColor: Color(AppColors.white),
    dividerColor: Color(AppColors.grayLight),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(AppColors.black)),
      bodyMedium: TextStyle(color: Color(AppColors.black)),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(AppColors.primary),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: Color(AppColors.darkBackground),
    primaryColor: Color(AppColors.primary),
    cardColor: Color(AppColors.darkCard),
    dividerColor: Color(AppColors.darkBorder),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(AppColors.darkText)),
      bodyMedium: TextStyle(color: Color(AppColors.darkText)),
    ),
  );

  // Helper methods to get colors based on theme
  static Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(AppColors.darkText)
        : Color(AppColors.black);
  }

  static Color getCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(AppColors.darkCard)
        : Color(AppColors.white);
  }

  static Color getBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(AppColors.darkBorder)
        : Color(AppColors.grayLight);
  }

  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(AppColors.darkBackground)
        : Color(AppColors.background);
  }
}

