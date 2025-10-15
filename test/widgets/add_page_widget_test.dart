import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:income_expense_tracker/features/transactions/domain/entities/transaction_entity.dart';
import 'package:income_expense_tracker/features/transactions/presentation/pages/add_transaction_page/widgets/add_page_widget.dart';

void main() {
  Widget wrap(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      builder: (_, __) => MaterialApp(home: Scaffold(body: child)),
    );
  }

  testWidgets('AddPageWidget shows Add/Update button text', (tester) async {
    await tester.pumpWidget(wrap(const AddPageWidget()));
    expect(find.text('Add Transaction'), findsOneWidget);
    expect(find.text('Update Transaction'), findsNothing);

    final initial = TransactionEntity(
      id: 'id1',
      type: TransactionType.expense,
      category: 'Food',
      amount: 10,
      date: DateTime.now(),
    );
    await tester.pumpWidget(wrap(AddPageWidget(initial: initial)));
    await tester.pumpAndSettle();
    expect(find.text('Update Transaction'), findsOneWidget);
  });
}

