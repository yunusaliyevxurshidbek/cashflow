import 'package:flutter_test/flutter_test.dart';
import 'package:income_expense_tracker/features/transactions/domain/entities/transaction_entity.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/add_transaction.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/get_balance_summary.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/balance/balance_bloc.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/balance/balance_event.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/balance/balance_state.dart';

import '../helpers/memory_repository.dart';

void main() {
  test('BalanceBloc computes totals', () async {
    final repo = MemoryTransactionRepository();
    final add = AddTransaction(repo);
    await add(TransactionEntity(id: '1', type: TransactionType.income, category: 'Salary', amount: 500, date: DateTime.now()));
    await add(TransactionEntity(id: '2', type: TransactionType.expense, category: 'Food', amount: 200, date: DateTime.now()));

    final bloc = BalanceBloc(getBalanceSummary: GetBalanceSummary(repo));
    bloc.add(LoadBalanceRequested());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<BalanceLoading>(),
        predicate<BalanceState>((s) => s is BalanceLoaded && s.netBalance == 300),
      ]),
    );

    await bloc.close();
  });
}

