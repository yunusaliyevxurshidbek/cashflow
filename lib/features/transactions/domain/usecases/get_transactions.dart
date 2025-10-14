import '../../../../core/usecase/usecase.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class GetTransactions implements UseCase<List<TransactionEntity>, NoParams> {
  final TransactionRepository repository;
  GetTransactions(this.repository);
  @override
  Future<List<TransactionEntity>> call(NoParams params) => repository.getAll();
}

