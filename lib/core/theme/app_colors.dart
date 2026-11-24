
import 'package:flutter/material.dart';

abstract final class AppColors {
  /// Brand
  static const primary = Color(0xFF0A7A45);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryLight = Color(0xFF6FD9A0);
  static const primaryDark = Color(0xFF06502D);

  /// Light Theme
  static const lightBackground = Color(0xFFF1F4F0);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceSecondary = Color(0xFFE7ECE6);
  static const lightText = Color(0xFF12241A);
  static const lightSecondaryText = Color(0xFF566259);
  static const lightPlaceholder = Color(0xFF6B766E);
  static const lightBorder = Color(0xFFD5DED5);
  static const lightBorderStrong = Color(0xFFB8C7BB);
  static const lightPrimarySoft = Color(0xFFE3F3E8);
  static const lightPrimarySoftText = Color(0xFF06502D);

  /// Dark Theme
  static const darkBackground = Color(0xFF0E1511);
  static const darkSurface = Color(0xFF17201A);
  static const darkSurfaceSecondary = Color(0xFF202B24);
  static const darkText = Color(0xFFE6F0E8);
  static const darkSecondaryText = Color(0xFF9DAAA1);
  static const darkPlaceholder = Color(0xFF8A978E);
  static const darkBorder = Color(0xFF2A362E);
  static const darkBorderStrong = Color(0xFF3E4F43);
  static const darkPrimarySoft = Color(0xFF1D3828);
  static const darkPrimarySoftText = Color(0xFFA8EBC6);

  /// Priority
  static const priorityHighLight = Color(0xFFFFF1D6);
  static const priorityHighTextLight = Color(0xFF7A4B00);
  static const priorityHighDark = Color(0xFF3A2C12);
  static const priorityHighTextDark = Color(0xFFF2C77B);

  /// Status
  static const danger = Color(0xFFB3261E);
  static const dangerSoft = Color(0xFFFCE9E7);
  static const dangerDark = Color(0xFFFFB4AB);
  static const dangerSoftDark = Color(0xFF3D1F1C);
  static const success = Color(0xFF0A7A45);

  /// Common
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const transparent = Color(0x00000000);

  /// Opacity Alphas
  static const double alphaSubtle = 0.08;
  static const double alphaLight = 0.12;
  static const double alphaMedium = 0.16;
  static const double alphaStrong = 0.18;
  static const double alphaBorder = 0.3;
  static const double alphaMuted = 0.55;
}
