import 'dart:convert';
import 'package:income_expense_tracker/features/transactions/data/models/transaction_model.dart';
import 'package:income_expense_tracker/features/transactions/domain/entities/transaction_entity.dart';
import 'package:income_expense_tracker/features/transactions/domain/repositories/transaction_repository.dart';

class MemoryTransactionRepository implements TransactionRepository {
  final List<TransactionEntity> _items = [];

  @override
  Future<void> add(TransactionEntity entity) async {
    _items.add(entity);
  }

  @override
  Future<void> delete(String id) async {
    _items.removeWhere((e) => e.id == id);
  }

  @override
  Future<void> update(TransactionEntity entity) async {
    final i = _items.indexWhere((e) => e.id == entity.id);
    if (i != -1) {
      _items[i] = entity;
    }
  }

  @override
  Future<List<TransactionEntity>> getAll() async {
    final copy = [..._items]..sort((a, b) => b.date.compareTo(a.date));
    return copy;
  }

  @override
  Future<List<TransactionEntity>> filter({
    TransactionType? type,
    DateTime? start,
    DateTime? end,
    String? category,
    String? search,
  }) async {
    Iterable<TransactionEntity> list = _items;
    if (type != null) {
      list = list.where((e) => e.type == type);
    }
    if (start != null) {
      list = list.where((e) => e.date.millisecondsSinceEpoch >= start.millisecondsSinceEpoch);
    }
    if (end != null) {
      list = list.where((e) => e.date.millisecondsSinceEpoch <= end.millisecondsSinceEpoch);
    }
    if (category != null && category.isNotEmpty) {
      final cat = category.toLowerCase();
      list = list.where((e) => e.category.toLowerCase() == cat);
    }
    if (search != null && search.isNotEmpty) {
      final q = search.toLowerCase();
      list = list.where((e) =>
          e.category.toLowerCase().contains(q) || (e.note?.toLowerCase().contains(q) ?? false));
    }
    final filtered = list.toList()..sort((a, b) => b.date.compareTo(a.date));
    return filtered;
  }

  @override
  Future<({double totalIncome, double totalExpense, double netBalance})> getBalanceSummary() async {
    double income = 0;
    double expense = 0;
    for (final t in _items) {
      if (t.type == TransactionType.income) {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }
    return (totalIncome: income, totalExpense: expense, netBalance: income - expense);
  }

  @override
  Future<String> exportJson() async {
    final jsonList = (await getAll())
        .map((e) => TransactionModel.fromEntity(e).toJson())
        .toList();
    return const JsonEncoder.withIndent('  ').convert(jsonList);
  }

  @override
  Future<int> importJson(String jsonString) async {
    final parsed = json.decode(jsonString);
    if (parsed is! List) throw const FormatException('JSON must be a list');

    int count = 0;
    for (final item in parsed) {
      if (item is! Map<String, dynamic>) continue;
      if (!item.containsKey('id') ||
          !item.containsKey('type') ||
          !item.containsKey('category') ||
          !item.containsKey('amount') ||
          !item.containsKey('date')) {
        continue;
      }
      final incomingModel = TransactionModel.fromJson(item);
      final incoming = incomingModel.toEntity();
      final i = _items.indexWhere((e) => e.id == incoming.id);
      if (i == -1) {
        _items.add(incoming);
        count++;
      } else {
        final current = _items[i];
        final keep = incoming.date.millisecondsSinceEpoch >=
                current.date.millisecondsSinceEpoch
            ? incoming
            : current;
        _items[i] = keep;
        count++;
      }
    }
    return count;
  }
}

