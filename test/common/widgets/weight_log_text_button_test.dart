import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('WeightLogTextButton displays correct text',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeightLogTextButton(
            text: 'Text Button',
            onPressed: () {},
          ),
        ),
      ),
    );

    // Verify text
    expect(find.text('Text Button'), findsOneWidget);
  });

  testWidgets('WeightLogTextButton is disabled when isEnabled is false',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeightLogTextButton(
            text: 'Disabled Text',
            isEnabled: false,
            onPressed: () {},
          ),
        ),
      ),
    );

    // Verify button is disabled
    final button = tester.widget<TextButton>(find.byType(TextButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('WeightLogTextButton triggers onPressed callback when tapped',
      (WidgetTester tester) async {
    bool isTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeightLogTextButton(
            text: 'Tap Text',
            onPressed: () {
              isTapped = true;
            },
          ),
        ),
      ),
    );

    // Tap the button
    await tester.tap(find.text('Tap Text'));
    await tester.pump();

    // Verify callback was triggered
    expect(isTapped, true);
  });
}
