import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/utils/result.dart';
import 'package:tasky/core/errors/failure.dart';
import 'package:tasky/domain/repositories/onboarding_repository.dart';
import 'package:tasky/domain/usecases/onboarding/complete_onboarding.dart';
import 'package:tasky/presentation/controllers/onboarding_controller.dart';
import 'package:tasky/presentation/screens/onboarding/onboarding_screen.dart';

class FakeOnboardingRepo implements OnboardingRepository {
  bool completed = false;
  bool shouldFail = false;

  @override
  Result<bool> isCompleted() => Ok(completed);

  @override
  Future<Result<void>> setCompleted() async {
    if (shouldFail) return Err(StorageFailure());
    completed = true;
    return const Ok(null);
  }
}

void main() {
  group('OnboardingScreen', () {
    testWidgets('displays the first onboarding page', (
        WidgetTester tester,
        ) async {
      final repo = FakeOnboardingRepo();
      final completeOnboarding = CompleteOnboarding(repo);

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, child) => MaterialApp(
            home: ChangeNotifierProvider<OnboardingController>(
              create: (_) => OnboardingController(completeOnboarding: completeOnboarding),
              child: const OnboardingScreen(),
            ),
          ),
        ),
      );

      expect(
        find.text('Catch it before it slips away.'),
        findsOneWidget,
      );

      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('moves to the next onboarding page', (
        WidgetTester tester,
        ) async {
      final repo = FakeOnboardingRepo();
      final completeOnboarding = CompleteOnboarding(repo);

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, child) => MaterialApp(
            home: ChangeNotifierProvider<OnboardingController>(
              create: (_) => OnboardingController(completeOnboarding: completeOnboarding),
              child: const OnboardingScreen(),
            ),
          ),
        ),
      );

      await tester.drag(
        find.byType(PageView),
        const Offset(-500, 0),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('See how far you’ve come.'),
        findsOneWidget,
      );
    });

    test('OnboardingController finishOnboarding returns true on Ok and false on Err', () async {
      final repo = FakeOnboardingRepo();
      final completeOnboarding = CompleteOnboarding(repo);
      final controller = OnboardingController(completeOnboarding: completeOnboarding);

      final success = await controller.finishOnboarding();
      expect(success, true);
      expect(repo.completed, true);

      repo.shouldFail = true;
      repo.completed = false;
      final controllerFail = OnboardingController(completeOnboarding: completeOnboarding);
      final failSuccess = await controllerFail.finishOnboarding();
      expect(failSuccess, false);
      expect(repo.completed, false);
    });
  });
}
