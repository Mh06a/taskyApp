import 'package:tasky/data/models/app_settings_model.dart';
import 'dart:convert';
import 'package:tasky/core/constants/storage_keys.dart';
import 'package:tasky/core/errors/exceptions.dart';
import 'package:tasky/data/services/preferences_manager.dart';



abstract interface class SettingsLocalDataSource {
  Future<AppSettingsModel> getSettings();
  Future<void> saveSettings(AppSettingsModel settings);
}





final class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  const SettingsLocalDataSourceImpl(this._preferences);

  final PreferencesManager _preferences;

  //getSettings
  @override
  Future<AppSettingsModel> getSettings() async {
    final raw = _preferences.getString(StorageKeys.appSettings);
    if (raw == null) return const AppSettingsModel();
    try {
      return AppSettingsModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      return const AppSettingsModel();
    } on TypeError {
      return const AppSettingsModel();
    }
  }

  //saveSettings
  @override
  Future<void> saveSettings(AppSettingsModel settings) async {
    final saved = await _preferences.setString(
      StorageKeys.appSettings,
      jsonEncode(settings.toJson()),
    );
    if (!saved) throw const StorageException('Could not save the settings.');
  }
}
