import '../../../../core/usecase/usecase.dart';
import '../repositories/transaction_repository.dart';

class DeleteTransaction implements UseCase<void, String> {
  final TransactionRepository repository;
  DeleteTransaction(this.repository);
  @override
  Future<void> call(String params) => repository.delete(params);
}

