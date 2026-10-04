import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rocketbot/screens/error_screen.dart';

void main() {
  testWidgets('ErrorScreen shows the unauthorized message', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ErrorScreen()));

    expect(find.text('Unauthorized usage of the app'), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
