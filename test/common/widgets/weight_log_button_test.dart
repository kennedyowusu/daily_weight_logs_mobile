import 'package:daily_weight_logs_mobile/common/widgets/weight_log_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('WeightLogButton displays correct text',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeightLogButton(
            text: 'Test Button',
            onPressed: () {},
          ),
        ),
      ),
    );

    // Verify button text
    expect(find.text('Test Button'), findsOneWidget);
  });

  testWidgets('WeightLogButton is disabled when isEnabled is false',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeightLogButton(
            text: 'Disabled Button',
            isEnabled: false,
            onPressed: () {},
          ),
        ),
      ),
    );

    // Verify button is disabled
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('WeightLogButton triggers onPressed callback when tapped',
      (WidgetTester tester) async {
    bool isTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeightLogButton(
            text: 'Tap Me',
            onPressed: () {
              isTapped = true;
            },
          ),
        ),
      ),
    );

    // Tap the button
    await tester.tap(find.text('Tap Me'));
    await tester.pump();

    // Verify callback was triggered
    expect(isTapped, true);
  });
}
