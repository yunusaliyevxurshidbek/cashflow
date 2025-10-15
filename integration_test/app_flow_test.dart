import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:income_expense_tracker/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add a transaction and find it in list', (tester) async {
    await app.main();
    await tester.pumpAndSettle();

    expect(find.text('Add'), findsOneWidget);
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    const category = 'TestCategory_IT';
    await tester.enterText(find.widgetWithText(TextFormField, 'Category'), category);
    await tester.enterText(find.widgetWithText(TextFormField, 'Amount'), '12.50');

    await tester.tap(find.text('Select date'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add Transaction'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Transactions'));
    await tester.pumpAndSettle();

    final searchField = find.widgetWithText(TextField, 'Search ...');
    if (searchField.evaluate().isNotEmpty) {
      await tester.enterText(searchField, category);
      await tester.pumpAndSettle();
    }

    expect(find.text(category), findsWidgets);
  });
}

