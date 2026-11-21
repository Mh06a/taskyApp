import 'package:flutter/material.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/core/theme/app_colors.dart';

abstract final class AppTypography {
  static TextTheme light = _createTextTheme(
    textColor: AppColors.lightText,
    secondaryColor: AppColors.lightSecondaryText,
  );

  static TextTheme dark = _createTextTheme(
    textColor: AppColors.darkText,
    secondaryColor: AppColors.darkSecondaryText,
  );

  static TextTheme _createTextTheme({
    required Color textColor,
    required Color secondaryColor,
  }) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: AppSizes.font36,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      displayMedium: TextStyle(
        fontSize: AppSizes.font32,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      displaySmall: TextStyle(
        fontSize: AppSizes.font28,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      headlineLarge: TextStyle(
        fontSize: AppSizes.font24,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
      headlineMedium: TextStyle(
        fontSize: AppSizes.font20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineSmall: TextStyle(
        fontSize: AppSizes.font18,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: TextStyle(
        fontSize: AppSizes.font18,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleMedium: TextStyle(
        fontSize: AppSizes.font16,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleSmall: TextStyle(
        fontSize: AppSizes.font14,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      bodyLarge: TextStyle(
        fontSize: AppSizes.font16,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: AppSizes.font14,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
      ),
      bodySmall: TextStyle(
        fontSize: AppSizes.font13,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
      ),
      labelLarge: TextStyle(
        fontSize: AppSizes.font14,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      labelMedium: TextStyle(
        fontSize: AppSizes.font12,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
      ),
      labelSmall: TextStyle(
        fontSize: AppSizes.font10,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
      ),
    );
  }
}
