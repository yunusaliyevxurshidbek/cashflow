import 'package:flutter_test/flutter_test.dart';

import 'package:income_expense_tracker/features/transactions/domain/entities/transaction_entity.dart';
import 'package:income_expense_tracker/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/add_transaction.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/get_balance_summary.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/get_transactions.dart';
import 'package:income_expense_tracker/core/usecase/usecase.dart';

class _FakeRepo implements TransactionRepository {
  final _items = <TransactionEntity>[];
  @override
  Future<void> add(TransactionEntity entity) async => _items.add(entity);
  @override
  Future<void> delete(String id) async => _items.removeWhere((e) => e.id == id);
  @override
  Future<String> exportJson() async => '[]';
  @override
  Future<({double totalIncome, double totalExpense, double netBalance})> getBalanceSummary() async {
    double inc = 0, exp = 0;
    for (final t in _items) {
      if (t.type == TransactionType.income) inc += t.amount; else exp += t.amount;
    }
    return (totalIncome: inc, totalExpense: exp, netBalance: inc - exp);
  }
  @override
  Future<List<TransactionEntity>> getAll() async => _items;
  @override
  Future<int> importJson(String jsonString) async => 0;
  @override
  Future<void> update(TransactionEntity entity) async {
    final i = _items.indexWhere((e) => e.id == entity.id);
    if (i != -1) _items[i] = entity;
  }
  @override
  Future<List<TransactionEntity>> filter({TransactionType? type, DateTime? start, DateTime? end, String? category, String? search}) async => _items;
}

void main() {
  test('Add and balance use cases work', () async {
    final repo = _FakeRepo();
    final add = AddTransaction(repo);
    final balance = GetBalanceSummary(repo);
    final getAll = GetTransactions(repo);

    expect((await getAll(const NoParams())).length, 0);

    await add(TransactionEntity(id: '1', type: TransactionType.income, category: 'Salary', amount: 1000, date: DateTime.now()));
    await add(TransactionEntity(id: '2', type: TransactionType.expense, category: 'Food', amount: 200, date: DateTime.now()));

    final items = await getAll(const NoParams());
    expect(items.length, 2);

    final s = await balance(const NoParams());
    expect(s.totalIncome, 1000);
    expect(s.totalExpense, 200);
    expect(s.netBalance, 800);
  });
}

