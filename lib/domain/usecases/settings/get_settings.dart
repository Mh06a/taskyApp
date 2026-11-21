import 'package:tasky/core/utils/result.dart';
import 'package:tasky/domain/entities/app_settings.dart';
import 'package:tasky/domain/repositories/settings_repository.dart';

final class GetSettings {
  const GetSettings(this._repository);

  final SettingsRepository _repository;

  Future<Result<AppSettings>> call() => _repository.getSettings();
}
