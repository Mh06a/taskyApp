import 'package:tasky/core/utils/guard.dart';
import 'package:tasky/core/utils/result.dart';
import 'package:tasky/data/datasources/local/settings_local_data_source.dart';
import 'package:tasky/data/models/app_settings_model.dart';
import 'package:tasky/domain/entities/app_settings.dart';
import 'package:tasky/domain/repositories/settings_repository.dart';

final class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._dataSource);

  final SettingsLocalDataSource _dataSource;

  @override
  Future<Result<AppSettings>> getSettings() {
    return guard<AppSettings>(_dataSource.getSettings);
  }

  @override
  Future<Result<void>> saveSettings(AppSettings settings) {
    return guard<void>(
      () => _dataSource.saveSettings(AppSettingsModel.fromEntity(settings)),
    );
  }
}
