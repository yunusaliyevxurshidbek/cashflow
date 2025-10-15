import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:income_expense_tracker/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add a transaction and find it in list', (tester) async {
    await app.main();
    await tester.pumpAndSettle();

    // Navigate to Add tab via bottom bar label
    expect(find.text('Add'), findsOneWidget);
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // Fill the form
    const category = 'TestCategory_IT';
    await tester.enterText(find.widgetWithText(TextFormField, 'Category'), category);
    await tester.enterText(find.widgetWithText(TextFormField, 'Amount'), '12.50');

    // Pick a date (defaults to today, so just confirm)
    // Tap the date field by its hint text
    await tester.tap(find.text('Select date'));
    await tester.pumpAndSettle();
    // Confirm the default selected date
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Submit
    await tester.tap(find.text('Add Transaction'));
    await tester.pumpAndSettle();

    // Go to Transactions tab
    await tester.tap(find.text('Transactions'));
    await tester.pumpAndSettle();

    // Optionally filter via search
    final searchField = find.widgetWithText(TextField, 'Search ...');
    if (searchField.evaluate().isNotEmpty) {
      await tester.enterText(searchField, category);
      await tester.pumpAndSettle();
    }

    // Expect our category text to appear at least once
    expect(find.text(category), findsWidgets);
  });
}

