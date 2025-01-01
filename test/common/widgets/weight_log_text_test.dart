import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('WeightLogText displays correct text',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: WeightLogText(
            text: 'Sample Text',
          ),
        ),
      ),
    );

    // Verify the text
    expect(find.text('Sample Text'), findsOneWidget);
  });

  testWidgets('WeightLogText applies correct style',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: WeightLogText(
            text: 'Styled Text',
            color: Colors.red,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    // Verify text style
    final textWidget = tester.widget<Text>(find.text('Styled Text'));
    final textStyle = textWidget.style;

    expect(textStyle?.color, Colors.red);
    expect(textStyle?.fontSize, 20);
    expect(textStyle?.fontWeight, FontWeight.bold);
  });
}
