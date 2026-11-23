import 'package:tasky/core/utils/result.dart';

abstract interface class OnboardingRepository {
  Result<bool> isCompleted();

  Future<Result<void>> setCompleted();
}