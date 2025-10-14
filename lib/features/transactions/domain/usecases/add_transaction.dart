import '../../../../core/usecase/usecase.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class AddTransaction implements UseCase<void, TransactionEntity> {
  final TransactionRepository repository;
  AddTransaction(this.repository);
  @override
  Future<void> call(TransactionEntity params) => repository.add(params);
}

