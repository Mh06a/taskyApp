
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasky/presentation/screens/onboarding/onboarding_screen.dart';

void main() {
  group('OnboardingScreen', () {
    testWidgets('displays the first onboarding page', (
        WidgetTester tester,
        ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingScreen(),
        ),
      );

      expect(
        find.text('Catch it before it slips away.'),
        findsOneWidget,
      );

      expect(find.text('Skip intro'), findsOneWidget);
    });

    testWidgets('moves to the next onboarding page', (
        WidgetTester tester,
        ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingScreen(),
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
  });
}
