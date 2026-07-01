import 'package:flutter/material.dart';
import 'package:second_project/core/services/preferences_manager.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> valueNotifier = ValueNotifier(
    ThemeMode.dark,
  );

  init() {
    bool result = PreferencesManager().getBool("theme") ?? true;

    if (result == true) {
      valueNotifier.value = ThemeMode.dark;
    } else {
      valueNotifier.value = ThemeMode.light;
    }
  }

  static toggleTheme() async {
    if (valueNotifier.value == ThemeMode.dark) {
      valueNotifier.value = ThemeMode.light;
      await PreferencesManager().setBool("theme", false);
    } else {
      valueNotifier.value = ThemeMode.dark;
      await PreferencesManager().setBool("theme", true);
    }
  }

  static bool isDark() => valueNotifier.value == ThemeMode.dark;
}
