import 'package:flutter/material.dart';
import 'app_constants.dart';

/// Theme colors for light and dark mode
class AppThemeColors {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(AppColors.primary),
      brightness: Brightness.light,
    ).copyWith(
      surface: Color(AppColors.white),
      onSurface: Color(AppColors.black),
      onBackground: Color(AppColors.black),
      onPrimary: Color(AppColors.white),
      onSecondary: Color(AppColors.white),
    ),
    scaffoldBackgroundColor: Color(AppColors.background),
    primaryColor: Color(AppColors.primary),
    cardColor: Color(AppColors.white),
    dividerColor: Color(AppColors.grayLight),
    textTheme: TextTheme(
      // Display styles - for large hero text
      displayLarge: TextStyle(
        color: Color(AppColors.black),
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
      ),
      displayMedium: TextStyle(
        color: Color(AppColors.black),
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      displaySmall: TextStyle(
        color: Color(AppColors.black),
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      // Headline styles - for section headers
      headlineLarge: TextStyle(
        color: Color(AppColors.black),
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      headlineMedium: TextStyle(
        color: Color(AppColors.black),
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      headlineSmall: TextStyle(
        color: Color(AppColors.black),
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      // Title styles - for card titles, list items
      titleLarge: TextStyle(
        color: Color(AppColors.black),
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      titleMedium: TextStyle(
        color: Color(AppColors.black),
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        color: Color(AppColors.black),
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      // Body styles - for main content
      bodyLarge: TextStyle(
        color: Color(AppColors.black),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        color: Color(AppColors.black),
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        color: Color(AppColors.grayDark),
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
      // Label styles - for buttons, labels
      labelLarge: TextStyle(
        color: Color(AppColors.black),
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        color: Color(AppColors.black),
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        color: Color(AppColors.grayDark),
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(AppColors.primary),
      brightness: Brightness.dark,
    ).copyWith(
      surface: Color(AppColors.darkCard),
      onSurface: Color(AppColors.darkText),
      onBackground: Color(AppColors.darkText),
      onPrimary: Color(AppColors.white),
      onSecondary: Color(AppColors.white),
    ),
    scaffoldBackgroundColor: Color(AppColors.darkBackground),
    primaryColor: Color(AppColors.primary),
    cardColor: Color(AppColors.darkCard),
    dividerColor: Color(AppColors.darkBorder),
    textTheme: TextTheme(
      // Display styles - for large hero text
      displayLarge: TextStyle(
        color: Color(AppColors.darkText),
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
      ),
      displayMedium: TextStyle(
        color: Color(AppColors.darkText),
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      displaySmall: TextStyle(
        color: Color(AppColors.darkText),
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      // Headline styles - for section headers
      headlineLarge: TextStyle(
        color: Color(AppColors.darkText),
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      headlineMedium: TextStyle(
        color: Color(AppColors.darkText),
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      headlineSmall: TextStyle(
        color: Color(AppColors.darkText),
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      // Title styles - for card titles, list items
      titleLarge: TextStyle(
        color: Color(AppColors.darkText),
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      titleMedium: TextStyle(
        color: Color(AppColors.darkText),
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        color: Color(AppColors.darkText),
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      // Body styles - for main content
      bodyLarge: TextStyle(
        color: Color(AppColors.darkText),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        color: Color(AppColors.darkText),
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        color: Color(AppColors.grayMedium),
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
      // Label styles - for buttons, labels
      labelLarge: TextStyle(
        color: Color(AppColors.darkText),
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        color: Color(AppColors.darkText),
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        color: Color(AppColors.grayMedium),
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
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

