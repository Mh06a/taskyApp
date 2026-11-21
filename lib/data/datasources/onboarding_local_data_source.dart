import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/constants/storage_keys.dart';
import 'package:tasky/core/errors/exceptions.dart';

abstract interface class OnboardingLocalDataSource {
  bool isCompleted();
  Future<void> setCompleted();
}


final class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  const OnboardingLocalDataSourceImpl(this._preferences);
  final SharedPreferences _preferences;

  //isCompleted
  @override
  bool isCompleted() => _preferences.getBool(StorageKeys.onboardingCompleted) ?? false;


  //setCompleted
  @override
  Future<void> setCompleted() async {
    final success = await _preferences.setBool(StorageKeys.onboardingCompleted, true);
    if (!success) throw const StorageException('Could not save onboarding state.');
  }
}
