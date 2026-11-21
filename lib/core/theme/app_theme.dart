import 'package:flutter/material.dart';
import 'package:tasky/core/theme/dark_theme.dart';
import 'package:tasky/core/theme/light_theme.dart';

abstract final class AppTheme {
  static ThemeData get light => LightTheme.build();
  static ThemeData get dark => DarkTheme.build();
}