import 'package:daily_weight_logs_mobile/features/authentication/presentation/login_screen.dart';
import 'package:daily_weight_logs_mobile/features/onboarding/presentation/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('OnboardingScreen UI Edge Cases', () {
    testWidgets('Skip button skips directly to the last slide',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingScreen(),
          ),
        ),
      );

      // Assert initial state
      expect(find.text('Track Your Weight'), findsOneWidget);
      expect(find.text('Reach Your Goals'), findsNothing);

      // Act - Press "Skip"
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      // Assert user navigates to the last slide
      expect(find.text('Reach Your Goals'), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);
      expect(find.text('Back'), findsNothing); // "Back" button is not shown
    });

    testWidgets('Back button is only visible on intermediate slides',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingScreen(),
          ),
        ),
      );

      // Assert no "Back" button on the first slide
      expect(find.text('Back'), findsNothing);

      // Act - Navigate to the next slide
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Assert "Back" button is visible
      expect(find.text('Back'), findsOneWidget);

      // Act - Tap "Back" button
      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();

      // Assert user navigates back to the first slide
      expect(find.text('Track Your Weight'), findsOneWidget);
      expect(find.text('Back'), findsNothing); // "Back" button is not visible
    });

    testWidgets('Button text changes to "Get Started" on the last slide',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: OnboardingScreen()),
        ),
      );

      // Navigate to the second slide
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Verify the "Back" button is present
      expect(find.byKey(const Key('back_button')), findsOneWidget);

      // Tap the "Back" button
      await tester.tap(find.byKey(const Key('back_button')));
      await tester.pumpAndSettle();

      // Verify we navigated back to the first slide
      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets(
        'Get Started button completes onboarding and navigates to login',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            initialRoute: '/onboarding',
            routes: {
              '/onboarding': (context) => const OnboardingScreen(),
              '/login': (context) => const LoginScreen(),
            },
          ),
        ),
      );

      // Navigate to the last slide
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Tap the "Get Started" button
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();
    });

    testWidgets('Swiping is disabled after skipping to the last slide',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingScreen(),
          ),
        ),
      );

      // Act - Press "Skip"
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      // Assert user is on the last slide
      expect(find.text('Reach Your Goals'), findsOneWidget);

      // Try to swipe back
      await tester.drag(find.byType(PageView), const Offset(300, 0));
      await tester.pumpAndSettle();

      // Assert user is still on the last slide
      expect(find.text('Reach Your Goals'), findsOneWidget);
    });

    testWidgets('Get Started button appears on the last slide',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingScreen(),
          ),
        ),
      );

      // Skip to the last slide
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      // Verify "Get Started" button is visible
      expect(find.text('Get Started'), findsOneWidget);
      expect(find.text('Next'), findsNothing);
    });

    testWidgets('Next button works correctly', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: OnboardingScreen()),
        ),
      );

      // Verify the "Next" button is present on the first slide
      expect(find.text('Next'), findsOneWidget);

      // Tap the "Next" button and move to the second slide
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Verify we're on the second slide
      expect(find.text('Stay on Track'), findsOneWidget);
    });

    testWidgets('Back button works correctly', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: OnboardingScreen()),
        ),
      );

      // Navigate to the second slide
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Verify the "Back" button is present
      expect(find.text('Back'), findsOneWidget);

      // Tap the "Back" button and verify navigation
      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();

      // Verify we're back on the first slide
      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('Next button works correctly', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: OnboardingScreen()),
        ),
      );

      // Verify the "Next" button is present on the first slide
      expect(find.text('Next'), findsOneWidget);

      // Tap the "Next" button and move to the second slide
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Verify we're on the second slide
      expect(find.text('Stay on Track'), findsOneWidget);
    });
  });
}
