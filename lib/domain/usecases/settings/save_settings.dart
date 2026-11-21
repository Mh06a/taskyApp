import 'package:tasky/core/utils/result.dart';
import 'package:tasky/domain/entities/app_settings.dart';
import 'package:tasky/domain/repositories/settings_repository.dart';

final class SaveSettings {
  const SaveSettings(this._repository);

  final SettingsRepository _repository;

  Future<Result<void>> call(AppSettings settings) {
    return _repository.saveSettings(settings);
  }
}
