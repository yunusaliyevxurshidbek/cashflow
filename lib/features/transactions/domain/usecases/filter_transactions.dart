import '../../../../core/usecase/usecase.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class FilterTransactions implements UseCase<List<TransactionEntity>, FilterParams> {
  final TransactionRepository repository;
  FilterTransactions(this.repository);
  @override
  Future<List<TransactionEntity>> call(FilterParams params) => repository.filter(
        type: params.type,
        start: params.start,
        end: params.end,
        category: params.category,
        search: params.search,
      );
}

class FilterParams {
  final TransactionType? type;
  final DateTime? start;
  final DateTime? end;
  final String? category;
  final String? search;
  const FilterParams({this.type, this.start, this.end, this.category, this.search});
}

