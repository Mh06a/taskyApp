import 'package:flutter/material.dart';
import 'package:tasky/core/enums/app_language.dart';
import 'package:tasky/core/enums/app_theme_mode.dart';
import 'package:tasky/core/enums/async_status.dart';
import 'package:tasky/domain/entities/app_settings.dart';
import 'package:tasky/domain/usecases/settings/get_settings.dart';
import 'package:tasky/domain/usecases/settings/save_settings.dart';

class SettingsController extends ChangeNotifier {
  SettingsController({
    required GetSettings getSettings,
    required SaveSettings saveSettings,
  })  : _getSettings = getSettings,
        _saveSettings = saveSettings;

  final GetSettings _getSettings;
  final SaveSettings _saveSettings;

  AppSettings _settings = const AppSettings();

  AsyncStatus _loadStatus = AsyncStatus.initial;
  AsyncStatus _saveStatus = AsyncStatus.initial;

  String? _errorMessage;

  // State

  AppSettings get settings => _settings;

  AppThemeMode get themeMode => _settings.themeMode;
  AppLanguage get language => _settings.language;

  AsyncStatus get loadStatus => _loadStatus;
  AsyncStatus get saveStatus => _saveStatus;

  String? get errorMessage => _errorMessage;

  bool get isLoading => _loadStatus == AsyncStatus.loading;
  bool get isSaving => _saveStatus == AsyncStatus.loading;

  // Theme

  ThemeMode get materialThemeMode {
    switch (_settings.themeMode) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  // Locale

  Locale? get locale {
    switch (_settings.language) {
      case AppLanguage.system:
        return null;
      case AppLanguage.arabic:
        return const Locale('ar');
      case AppLanguage.english:
        return const Locale('en');
    }
  }

  // Load

  Future<void> loadSettings() async {
    if (isLoading || isSaving) return;

    _loadStatus = AsyncStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _getSettings();

      result.when(
        ok: (settings) {
          _settings = settings;
          _loadStatus = AsyncStatus.success;
        },
        err: (failure) {
          debugPrint('Settings load failed: $failure');
          _loadStatus = AsyncStatus.failure;
          _errorMessage = 'Something went wrong. Please try again.';
        },
      );
    } catch (error) {
      debugPrint('Settings load threw an exception: $error');
      _loadStatus = AsyncStatus.failure;
      _errorMessage = 'Something went wrong. Please try again.';
    }

    notifyListeners();
  }

  // Update theme

  Future<bool> changeTheme(AppThemeMode mode) {
    if (isLoading || isSaving) {
      return Future.value(false);
    }

    if (_settings.themeMode == mode) {
      return Future.value(true);
    }

    final updated = _settings.copyWith(themeMode: mode);
    return _save(updated);
  }

  // Update language

  Future<bool> changeLanguage(AppLanguage language) {
    if (isLoading || isSaving) {
      return Future.value(false);
    }

    if (_settings.language == language) {
      return Future.value(true);
    }

    final updated = _settings.copyWith(language: language);
    return _save(updated);
  }

  // Save

  Future<bool> _save(AppSettings updated) async {
    if (isLoading || isSaving) return false;

    final previous = _settings;

    _settings = updated;
    _saveStatus = AsyncStatus.loading;
    _errorMessage = null;

    notifyListeners();

    var success = false;

    try {
      final result = await _saveSettings(updated);

      result.when(
        ok: (_) {
          _saveStatus = AsyncStatus.success;
          success = true;
        },
        err: (failure) {
          debugPrint('Settings save failed: $failure');
          _settings = previous;
          _saveStatus = AsyncStatus.failure;
          _errorMessage = 'Something went wrong. Please try again.';
        },
      );
    } catch (error) {
      debugPrint('Settings save threw an exception: $error');
      _settings = previous;
      _saveStatus = AsyncStatus.failure;
      _errorMessage = 'Something went wrong. Please try again.';
    }

    notifyListeners();
    return success;
  }

  // Error

  void clearError() {
    if (_errorMessage == null) return;

    _errorMessage = null;
    notifyListeners();
  }
}
