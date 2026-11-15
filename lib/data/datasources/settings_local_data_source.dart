import 'package:tasky/data/models/app_settings_model.dart';

abstract interface class SettingsLocalDataSource {
  Future<AppSettingsModel> getSettings();
  Future<void> saveSettings(AppSettingsModel settings);
}
