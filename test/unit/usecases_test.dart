import 'package:flutter_test/flutter_test.dart';
import 'package:income_expense_tracker/core/usecase/usecase.dart';
import 'package:income_expense_tracker/features/transactions/domain/entities/transaction_entity.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/add_transaction.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/export_json.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/filter_transactions.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/get_balance_summary.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/get_transactions.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/import_json.dart';
import 'package:income_expense_tracker/features/transactions/domain/usecases/update_transaction.dart';
import '../helpers/memory_repository.dart';

void main() {
  group('UseCases (in-memory)', () {
    test('Add/Get/Balance/Delete', () async {
      final repo = MemoryTransactionRepository();
      final add = AddTransaction(repo);
      final getAll = GetTransactions(repo);
      final summary = GetBalanceSummary(repo);
      final del = DeleteTransaction(repo);

      expect(await getAll(NoParams()), isEmpty);

      final now = DateTime.now();
      await add(TransactionEntity(
        id: '1',
        type: TransactionType.income,
        category: 'Salary',
        amount: 1000,
        date: now,
      ));
      await add(TransactionEntity(
        id: '2',
        type: TransactionType.expense,
        category: 'Food',
        amount: 150,
        date: now,
      ));

      final items = await getAll(NoParams());
      expect(items.length, 2);

      final s = await summary( NoParams());
      expect(s.totalIncome, 1000);
      expect(s.totalExpense, 150);
      expect(s.netBalance, 850);

      await del('2');
      final itemsAfter = await getAll( NoParams());
      expect(itemsAfter.length, 1);
    });

    test('Update modifies existing', () async {
      final repo = MemoryTransactionRepository();
      final add = AddTransaction(repo);
      final update = UpdateTransaction(repo);
      final getAll = GetTransactions(repo);

      final now = DateTime.now();
      final original = TransactionEntity(
        id: 'x',
        type: TransactionType.expense,
        category: 'Transport',
        amount: 10,
        date: now,
      );
      await add(original);
      await update(original.copyWith(amount: 15));

      final items = await getAll( NoParams());
      expect(items.single.amount, 15);
    });

    test('Filter by type/category/search/date', () async {
      final repo = MemoryTransactionRepository();
      final add = AddTransaction(repo);
      final filter = FilterTransactions(repo);
      final now = DateTime.now();

      await add(TransactionEntity(id: 'a', type: TransactionType.income, category: 'Salary', amount: 1000, date: now));
      await add(TransactionEntity(id: 'b', type: TransactionType.expense, category: 'Food', amount: 50, date: now, note: 'groceries at market'));
      await add(TransactionEntity(id: 'c', type: TransactionType.expense, category: 'Transport', amount: 20, date: now.subtract(const Duration(days: 1))));

      final onlyExpense = await filter(const FilterParams(type: TransactionType.expense));
      expect(onlyExpense.length, 2);

      final byCategory = await filter(const FilterParams(category: 'food'));
      expect(byCategory.length, 1);
      expect(byCategory.single.category, 'Food');

      final bySearch = await filter(const FilterParams(search: 'market'));
      expect(bySearch.length, 1);

      final byDateRange = await filter(FilterParams(start: now.subtract(const Duration(hours: 12)), end: now.add(const Duration(hours: 12))));
      expect(byDateRange.length, 2);
    });

    test('Export/Import JSON keeps newest by id', () async {
      final repo = MemoryTransactionRepository();
      final add = AddTransaction(repo);
      final export = ExportJson(repo);
      final import = ImportJson(repo);
      final now = DateTime.now();

      await add(TransactionEntity(id: 'z', type: TransactionType.income, category: 'Salary', amount: 1000, date: now));
      final jsonString = await export( NoParams());
      expect(jsonString.contains('Salary'), true);

      final older = '[{"id":"z","type":"income","category":"Salary","amount":2000,"date":${now.subtract(const Duration(days: 1)).millisecondsSinceEpoch}}]';
      final newer = '[{"id":"z","type":"income","category":"Salary","amount":3000,"date":${now.add(const Duration(days: 1)).millisecondsSinceEpoch}}]';

      expect(await import(older), 1);
      expect(await import(newer), 1);

      final after = await export( NoParams());
      expect(after.contains('3000'), true);
    });
  });
}

