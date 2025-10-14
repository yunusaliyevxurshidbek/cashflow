import '../entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<void> add(TransactionEntity entity);
  Future<void> update(TransactionEntity entity);
  Future<void> delete(String id);
  Future<List<TransactionEntity>> getAll();

  Future<List<TransactionEntity>> filter({
    TransactionType? type,
    DateTime? start,
    DateTime? end,
    String? category,
    String? search,
  });

  Future<({double totalIncome, double totalExpense, double netBalance})> getBalanceSummary();

  Future<String> exportJson();
  Future<int> importJson(String jsonString);
}

