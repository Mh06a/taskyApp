import 'package:tasky/data/datasources/onboarding_local_data_source.dart';
import 'package:tasky/domain/repositories/onboarding_repository.dart';

final class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(this._localDataSource);
  final OnboardingLocalDataSource _localDataSource;
  @override
  bool isCompleted() => _localDataSource.isCompleted();
  @override
  Future<void> setCompleted() => _localDataSource.setCompleted();
}
