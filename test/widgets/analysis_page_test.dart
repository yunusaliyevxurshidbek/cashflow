import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:income_expense_tracker/features/transactions/domain/entities/transaction_entity.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/add_transaction.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/export_json.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/filter_transactions.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/get_balance_summary.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/get_transactions.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/import_json.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/update_transaction.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/balance/balance_bloc.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/balance/balance_event.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/filter/filter_bloc.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/transaction/transaction_event.dart';
import 'package:income_expense_tracker/features/transactions/presentation/pages/analysis_page/analysis_page.dart';
import '../helpers/memory_repository.dart';

void main() {
  testWidgets('AnalysisPage shows summary and chart labels', (tester) async {
    final repo = MemoryTransactionRepository();
    final add = AddTransaction(repo);
    final now = DateTime.now();
    await add(TransactionEntity(id: '1', type: TransactionType.income, category: 'Salary', amount: 500, date: now));
    await add(TransactionEntity(id: '2', type: TransactionType.expense, category: 'Food', amount: 200, date: now));

    final filterBloc = FilterBloc();
    final balanceBloc = BalanceBloc(getBalanceSummary: GetBalanceSummary(repo));
    final transactionBloc = TransactionBloc(
      addTransaction: add,
      updateTransaction: UpdateTransaction(repo),
      deleteTransaction: DeleteTransaction(repo),
      getTransactions: GetTransactions(repo),
      filterTransactions: FilterTransactions(repo),
      exportJson: ExportJson(repo),
      importJson: ImportJson(repo),
      filterBloc: filterBloc,
      balanceBloc: balanceBloc,
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(430, 932),
        builder: (_, __) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: filterBloc),
            BlocProvider.value(value: balanceBloc),
            BlocProvider.value(value: transactionBloc),
          ],
          child: const MaterialApp(
            home: AnalysisPage(),
          ),
        ),
      ),
    );

    balanceBloc.add(LoadBalanceRequested());
    transactionBloc.add(LoadTransactionsRequested());
    await tester.pumpAndSettle();

    expect(find.text('Analysis'), findsOneWidget);
    expect(find.text('Monthly Overview'), findsOneWidget);
    expect(find.text('Income'), findsWidgets);
    expect(find.text('Expense'), findsWidgets);
  });
}
