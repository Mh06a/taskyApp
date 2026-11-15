import 'package:equatable/equatable.dart';
import 'package:tasky/core/enums/app_language.dart';
import 'package:tasky/core/enums/app_theme_mode.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.themeMode = AppThemeMode.system,
    this.language = AppLanguage.system,
  });

  final AppThemeMode themeMode;
  final AppLanguage language;

  AppSettings copyWith({AppThemeMode? themeMode, AppLanguage? language}) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [themeMode, language];
}
