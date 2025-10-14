import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:income_expense_tracker/core/usecase/usecase.dart';
import 'package:income_expense_tracker/features/transactions/domain/entities/transaction_entity.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/add_transaction.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/export_json.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/filter_transactions.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/get_transactions.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/import_json.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/update_transaction.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/balance/balance_bloc.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/balance/balance_event.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/filter/filter_bloc.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/transaction/transaction_event.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/transaction/transaction_state.dart';

class _MemRepo {
  final items = <TransactionEntity>[];
}

class _Add implements AddTransaction {
  final _MemRepo mem;
  _Add(this.mem) : super((_) => Future.value());
  @override
  Future<void> call(TransactionEntity params) async => mem.items.add(params);
}

class _Update implements UpdateTransaction {
  final _MemRepo mem;
  _Update(this.mem) : super((_) => Future.value());
  @override
  Future<void> call(TransactionEntity params) async {
    final i = mem.items.indexWhere((e) => e.id == params.id);
    if (i != -1) mem.items[i] = params;
  }
}

class _Delete implements DeleteTransaction {
  final _MemRepo mem;
  _Delete(this.mem) : super((_) => Future.value());
  @override
  Future<void> call(String params) async => mem.items.removeWhere((e) => e.id == params);
}

class _Get implements GetTransactions {
  final _MemRepo mem;
  _Get(this.mem) : super((_) => Future.value([]));
  @override
  Future<List<TransactionEntity>> call(NoParams params) async => mem.items;
}

class _Filter implements FilterTransactions {
  final _MemRepo mem;
  _Filter(this.mem) : super((_) => Future.value([]));
  @override
  Future<List<TransactionEntity>> call(FilterParams params) async => mem.items;
}

class _Export implements ExportJson {
  _Export() : super((_) async => '[]');
}

class _Import implements ImportJson {
  _Import() : super((_) async => 0);
}

class _Balance extends BalanceBloc {
  _Balance() : super(getBalanceSummary: ((_) async => (totalIncome: 0.0, totalExpense: 0.0, netBalance: 0.0)) as dynamic);
  @override
  void add(BalanceEvent event) {}
}

void main() {
  test('TransactionBloc loads empty -> empty state', () async {
    final mem = _MemRepo();
    final bloc = TransactionBloc(
      addTransaction: _Add(mem),
      updateTransaction: _Update(mem),
      deleteTransaction: _Delete(mem),
      getTransactions: _Get(mem),
      filterTransactions: _Filter(mem),
      exportJson: _Export(),
      importJson: _Import(),
      filterBloc: FilterBloc(),
      balanceBloc: _Balance(),
    );
    bloc.add(LoadTransactionsRequested());
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(bloc.state, isA<TransactionEmpty>());
    await bloc.close();
  });

  blocTest<TransactionBloc, TransactionState>(
    'Add -> success -> Loaded',
    build: () {
      final mem = _MemRepo();
      return TransactionBloc(
        addTransaction: _Add(mem),
        updateTransaction: _Update(mem),
        deleteTransaction: _Delete(mem),
        getTransactions: _Get(mem),
        filterTransactions: _Filter(mem),
        exportJson: _Export(),
        importJson: _Import(),
        filterBloc: FilterBloc(),
        balanceBloc: _Balance(),
      );
    },
    act: (bloc) async {
      bloc.add(AddTransactionRequested(TransactionEntity(id: 't1', type: TransactionType.income, category: 'Salary', amount: 100, date: DateTime.now())));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(LoadTransactionsRequested());
    },
    wait: const Duration(milliseconds: 50),
    expect: () => [
      isA<TransactionOperationSuccess>(),
      isA<TransactionLoading>(),
      isA<TransactionLoaded>(),
    ],
  );
}

