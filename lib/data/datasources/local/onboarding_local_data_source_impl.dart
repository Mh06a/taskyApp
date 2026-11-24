import 'package:tasky/data/constants/storage_keys.dart';
import 'package:tasky/core/errors/exceptions.dart';
import 'package:tasky/data/datasources/local/onboarding_local_data_source.dart';
import 'package:tasky/data/services/preferences_manager.dart';

final class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  const OnboardingLocalDataSourceImpl(this._preferences);
  final PreferencesManager _preferences;

  @override
  bool isCompleted() => _preferences.getBool(StorageKeys.onboardingCompleted) ?? false;

  @override
  Future<void> setCompleted() async {
    final success = await _preferences.setBool(StorageKeys.onboardingCompleted, true);
    if (!success) throw const StorageException('Could not save onboarding state.');
  }
}
