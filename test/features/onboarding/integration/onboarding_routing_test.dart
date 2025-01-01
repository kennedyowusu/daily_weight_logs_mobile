import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:daily_weight_logs_mobile/router/app_router.dart';

void main() {
  testWidgets('Navigates to NotFoundScreen for unknown route', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: '/unknown',
    ));

    expect(find.text('You seem lost!'), findsOneWidget);
  });
}
