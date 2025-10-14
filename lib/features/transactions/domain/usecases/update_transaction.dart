import '../../../../core/usecase/usecase.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class UpdateTransaction implements UseCase<void, TransactionEntity> {
  final TransactionRepository repository;
  UpdateTransaction(this.repository);
  @override
  Future<void> call(TransactionEntity params) => repository.update(params);
}

