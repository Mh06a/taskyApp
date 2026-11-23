import 'package:shared_preferences/shared_preferences.dart';

final class PreferencesManager {
  PreferencesManager._(this._preferences);

  final SharedPreferences _preferences;

  static Future<PreferencesManager> create() async {
    final preferences = await SharedPreferences.getInstance();

    return PreferencesManager._(preferences);
  }

  String? getString(String key) {
    return _preferences.getString(key);
  }

  bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  int? getInt(String key) {
    return _preferences.getInt(key);
  }

  Future<bool> setString(String key, String value) {
    return _preferences.setString(key, value);
  }

  Future<bool> setBool(String key, bool value) {
    return _preferences.setBool(key, value);
  }

  Future<bool> setInt(String key, int value) {
    return _preferences.setInt(key, value);
  }

  Future<bool> remove(String key) {
    return _preferences.remove(key);
  }
}
