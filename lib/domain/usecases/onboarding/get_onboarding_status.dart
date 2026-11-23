import 'package:tasky/core/utils/result.dart';
import 'package:tasky/domain/repositories/onboarding_repository.dart';
final class GetOnboardingStatus {
  const GetOnboardingStatus(this._repository);
  final OnboardingRepository _repository;
  Result<bool> call() => _repository.isCompleted();
}
