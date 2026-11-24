abstract interface class OnboardingLocalDataSource {
  bool isCompleted();
  Future<void> setCompleted();
}
