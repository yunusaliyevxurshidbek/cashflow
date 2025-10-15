import 'package:bloc_test/bloc_test.dart';
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
import 'package:income_expense_tracker/features/transactions/presentation/bloc/filter/filter_bloc.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/transaction/transaction_event.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/transaction/transaction_state.dart';

import '../helpers/memory_repository.dart';

void main() {
  group('TransactionBloc', () {
    TransactionBloc buildBloc(MemoryTransactionRepository repo, FilterBloc fb, BalanceBloc bb) {
      return TransactionBloc(
        addTransaction: AddTransaction(repo),
        updateTransaction: UpdateTransaction(repo),
        deleteTransaction: DeleteTransaction(repo),
        getTransactions: GetTransactions(repo),
        filterTransactions: FilterTransactions(repo),
        exportJson: ExportJson(repo),
        importJson: ImportJson(repo),
        filterBloc: fb,
        balanceBloc: bb,
      );
    }

    blocTest<TransactionBloc, TransactionState>(
      'loads empty -> TransactionEmpty',
      build: () {
        final repo = MemoryTransactionRepository();
        final fb = FilterBloc();
        final bb = BalanceBloc(getBalanceSummary: GetBalanceSummary(repo));
        return buildBloc(repo, fb, bb);
      },
      act: (bloc) => bloc.add(LoadTransactionsRequested()),
      expect: () => [isA<TransactionLoading>(), isA<TransactionEmpty>()],
    );

    blocTest<TransactionBloc, TransactionState>(
      'add -> success -> loaded with 1 item',
      build: () {
        final repo = MemoryTransactionRepository();
        final fb = FilterBloc();
        final bb = BalanceBloc(getBalanceSummary: GetBalanceSummary(repo));
        return buildBloc(repo, fb, bb);
      },
      act: (bloc) async {
        bloc.add(AddTransactionRequested(TransactionEntity(
          id: 't1',
          type: TransactionType.income,
          category: 'Salary',
          amount: 100,
          date: DateTime.now(),
        )));
        await Future<void>.delayed(const Duration(milliseconds: 10));
        bloc.add(LoadTransactionsRequested());
      },
      wait: const Duration(milliseconds: 50),
      expect: () => [
        isA<TransactionOperationSuccess>(),
        isA<TransactionLoading>(),
        isA<TransactionLoaded>(),
      ],
      verify: (bloc) {
        expect((bloc.state as TransactionLoaded).items.length, 1);
      },
    );

    blocTest<TransactionBloc, TransactionState>(
      'export triggers success state',
      build: () {
        final repo = MemoryTransactionRepository();
        final fb = FilterBloc();
        final bb = BalanceBloc(getBalanceSummary: GetBalanceSummary(repo));
        return buildBloc(repo, fb, bb);
      },
      act: (bloc) async {
        bloc.add(const ExportJsonRequested(source: 'test'));
      },
      expect: () => [isA<TransactionExportSuccess>()],
    );

    blocTest<TransactionBloc, TransactionState>(
      'import adds items and emits success',
      build: () {
        final repo = MemoryTransactionRepository();
        final fb = FilterBloc();
        final bb = BalanceBloc(getBalanceSummary: GetBalanceSummary(repo));
        return buildBloc(repo, fb, bb);
      },
      act: (bloc) async {
        final now = DateTime.now().millisecondsSinceEpoch;
        final json = '[{"id":"i1","type":"income","category":"Bonus","amount":50.0,"date":$now}]';
        bloc.add(ImportJsonRequested(json, source: 'test'));
      },
      expect: () => [isA<TransactionImportSuccess>()],
    );
  });
}
