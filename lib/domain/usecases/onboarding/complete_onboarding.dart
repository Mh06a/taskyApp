import 'package:tasky/core/utils/result.dart';
import 'package:tasky/domain/repositories/onboarding_repository.dart';

final class CompleteOnboarding {
  const CompleteOnboarding(this._repository);

  final OnboardingRepository _repository;

  Future<Result<void>> call() => _repository.setCompleted();
}
