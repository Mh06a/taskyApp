
import 'package:flutter/material.dart';
import 'package:tasky/core/theme/app_colors.dart';
import 'package:tasky/core/theme/app_typography.dart';
import 'package:tasky/core/theme/theme_factory.dart';

abstract final class LightTheme {
  static ThemeData build() {
    return ThemeFactory.create(
      brightness: Brightness.light,

      background: AppColors.lightBackground,
      surface: AppColors.lightSurface,
      surfaceSecondary: AppColors.lightSurfaceSecondary,

      text: AppColors.lightText,
      secondaryText: AppColors.lightSecondaryText,
      placeholder: AppColors.lightPlaceholder,

      border: AppColors.lightBorder,
      borderStrong: AppColors.lightBorderStrong,

      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,

      error: AppColors.danger,
      errorSoft: AppColors.dangerSoft,

      priorityHigh: AppColors.priorityHighLight,
      priorityHighText: AppColors.priorityHighTextLight,

      primarySoft: AppColors.lightPrimarySoft,
      primarySoftText: AppColors.lightPrimarySoftText,

      textTheme: AppTypography.light,
    );
  }
}
