import 'package:daily_weight_logs_mobile/common/utils/weight_log_secure_storage.dart';
import 'package:daily_weight_logs_mobile/features/onboarding/application/onboarding_controller.dart';
import 'package:daily_weight_logs_mobile/features/onboarding/presentation/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'onboarding_controller_test.mocks.dart';

@GenerateMocks([DailyWeightLogsSecureStorage])
void main() {
  late MockDailyWeightLogsSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockDailyWeightLogsSecureStorage();
  });

  testWidgets('Back button works correctly', (WidgetTester tester) async {
    // Mock the onboarding controller behavior
    when(mockStorage.isUserSeenOnboarding()).thenAnswer((_) async => false);
    final onboardingController = OnboardingController(mockStorage);

    // Build the widget tree with a ProviderScope
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingControllerProvider
              .overrideWith((ref) => onboardingController),
        ],
        child: const MaterialApp(
          home: OnboardingScreen(),
        ),
      ),
    );

    // Simulate the "Next" button tap
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Verify that the Back button appears
    expect(find.text('Back'), findsOneWidget);

    // Simulate the "Back" button tap
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    // Ensure that we navigated back to the first page
    expect(find.text('Skip'), findsOneWidget);

    // Debug PageController's page index
    final pageControllerFinder = find.byType(PageView);
    final PageView pageView = tester.widget(pageControllerFinder);
    print('Current page: ${pageView.controller?.page}');
    expect(
      pageView.controller?.page,
      0,
    ); // Ensure it navigates back to the first page
  });
}
