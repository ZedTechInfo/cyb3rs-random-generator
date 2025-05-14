// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:random_string/main.dart';

void main() {
  testWidgets('Random String Generator test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Enter a valid length in the TextField.
    await tester.enterText(find.byType(TextField), '10');

    // Tap the 'Generate String' button and trigger a frame.
    await tester.tap(find.text('Generate String'));
    await tester.pump();

    // Verify that a string is generated and displayed.
    expect(find.text('Generated String:'), findsOneWidget);
    expect(find.byType(SelectableText), findsOneWidget);

    // Tap the 'Copy to Clipboard' icon button.
    await tester.tap(find.byIcon(Icons.copy));
    await tester.pump();

    // Verify that the 'Copied to clipboard!' message is shown.
    expect(find.text('Copied to clipboard!'), findsOneWidget);
  });
}
