import 'package:tasky/domain/repositories/onboarding_repository.dart';
final class GetOnboardingStatus {
  const GetOnboardingStatus(this._repository);
  final OnboardingRepository _repository;
  bool call() => _repository.isCompleted();
}
