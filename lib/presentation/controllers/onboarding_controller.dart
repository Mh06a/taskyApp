import 'package:flutter/material.dart';
import 'package:tasky/domain/usecases/onboarding/complete_onboarding.dart';

class OnboardingController extends ChangeNotifier {
  OnboardingController({
    required CompleteOnboarding completeOnboarding,
  }) : _completeOnboarding = completeOnboarding;

  final CompleteOnboarding _completeOnboarding;

  int _currentPage = 0;
  bool _isFinishing = false;

  int get currentPage => _currentPage;
  bool get isFinishing => _isFinishing;

  // Update the current onboarding page.
  void updatePage(int index) {
    if (_currentPage == index) return;

    _currentPage = index;
    notifyListeners();
  }

  // Complete onboarding and save its status.
  Future<bool> finishOnboarding() async {
    if (_isFinishing) return false;

    _isFinishing = true;
    notifyListeners();

    try {
      await _completeOnboarding.call();
      return true;
    } catch (error) {
      debugPrint('Onboarding completion failed: $error');
      return false;
    } finally {
      _isFinishing = false;
      notifyListeners();
    }
  }
}
