import 'package:tasky/core/utils/guard.dart';
import 'package:tasky/core/utils/result.dart';
import 'package:tasky/data/datasources/local/onboarding_local_data_source.dart';
import 'package:tasky/domain/repositories/onboarding_repository.dart';

final class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(this._localDataSource);

  final OnboardingLocalDataSource _localDataSource;

  @override
  Result<bool> isCompleted() {
    return guardSync<bool>(
      _localDataSource.isCompleted,
    );
  }

  @override
  Future<Result<void>> setCompleted() {
    return guard<void>(
      _localDataSource.setCompleted,
    );
  }
}
