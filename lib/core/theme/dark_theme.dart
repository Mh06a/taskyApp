
import 'package:flutter/material.dart';
import 'package:tasky/core/theme/app_colors.dart';
import 'package:tasky/core/theme/app_typography.dart';
import 'package:tasky/core/theme/theme_factory.dart';

abstract final class DarkTheme {
  static ThemeData build() {
    return ThemeFactory.create(
      brightness: Brightness.dark,

      background: AppColors.darkBackground,
      surface: AppColors.darkSurface,
      surfaceSecondary: AppColors.darkSurfaceSecondary,

      text: AppColors.darkText,
      secondaryText: AppColors.darkSecondaryText,
      placeholder: AppColors.darkPlaceholder,

      border: AppColors.darkBorder,
      borderStrong: AppColors.darkBorderStrong,

      primary: AppColors.primaryLight,
      onPrimary: AppColors.darkBackground,

      error: AppColors.dangerDark,
      errorSoft: AppColors.dangerSoftDark,

      priorityHigh: AppColors.priorityHighDark,
      priorityHighText: AppColors.priorityHighTextDark,

      primarySoft: AppColors.darkPrimarySoft,
      primarySoftText: AppColors.darkPrimarySoftText,

      textTheme: AppTypography.dark,
    );
  }
}
