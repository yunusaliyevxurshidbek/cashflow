import 'dart:convert';

import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/local/transaction_local_datasource.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource local;
  TransactionRepositoryImpl(this.local);

  @override
  Future<void> add(TransactionEntity entity) => local.add(entity);

  @override
  Future<void> delete(String id) => local.delete(id);

  @override
  Future<({double totalIncome, double totalExpense, double netBalance})> getBalanceSummary() async {
    final all = await local.getAll();
    double income = 0, expense = 0;
    for (final t in all) {
      if (t.type == TransactionType.income) {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }
    return (totalIncome: income, totalExpense: expense, netBalance: income - expense);
  }

  @override
  Future<List<TransactionEntity>> getAll() => local.getAll();

  @override
  Future<void> update(TransactionEntity entity) => local.update(entity);

  @override
  Future<List<TransactionEntity>> filter({TransactionType? type, DateTime? start, DateTime? end, String? category, String? search}) =>
      local.filter(type: type, start: start, end: end, category: category, search: search);

  @override
  Future<String> exportJson() => local.exportJson();

  @override
  Future<int> importJson(String jsonString) => local.importJson(jsonString);
}

