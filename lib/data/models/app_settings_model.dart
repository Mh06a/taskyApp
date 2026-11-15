import 'package:tasky/core/enums/app_language.dart';
import 'package:tasky/core/enums/app_theme_mode.dart';
import 'package:tasky/core/extensions/enum_extensions.dart';
import 'package:tasky/domain/entities/app_settings.dart';

final class AppSettingsModel extends AppSettings {
  const AppSettingsModel({super.themeMode, super.language});

  factory AppSettingsModel.fromEntity(AppSettings settings) {
    return AppSettingsModel(
      themeMode: settings.themeMode,
      language: settings.language,
    );
  }

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      themeMode: AppThemeMode.values.parse(
        json['themeMode'] as String?,
        orElse: AppThemeMode.system,
      ),
      language: AppLanguage.values.parse(
        json['language'] as String?,
        orElse: AppLanguage.system,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'themeMode': themeMode.name, 'language': language.name};
  }
}
