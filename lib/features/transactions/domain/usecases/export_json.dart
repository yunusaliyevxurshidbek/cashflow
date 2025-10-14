import '../../../../core/usecase/usecase.dart';
import '../repositories/transaction_repository.dart';

class ExportJson implements UseCase<String, NoParams> {
  final TransactionRepository repository;
  ExportJson(this.repository);
  @override
  Future<String> call(NoParams params) => repository.exportJson();
}

