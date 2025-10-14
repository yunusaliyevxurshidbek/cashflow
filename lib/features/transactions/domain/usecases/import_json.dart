import '../../../../core/usecase/usecase.dart';
import '../repositories/transaction_repository.dart';

class ImportJson implements UseCase<int, String> {
  final TransactionRepository repository;
  ImportJson(this.repository);
  @override
  Future<int> call(String params) => repository.importJson(params);
}

