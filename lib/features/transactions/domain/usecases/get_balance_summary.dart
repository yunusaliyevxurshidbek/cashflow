import '../../../../core/usecase/usecase.dart';
import '../repositories/transaction_repository.dart';

class GetBalanceSummary implements UseCase<({double totalIncome, double totalExpense, double netBalance}), NoParams> {
  final TransactionRepository repository;
  GetBalanceSummary(this.repository);
  @override
  Future<({double totalIncome, double totalExpense, double netBalance})> call(NoParams params) =>
      repository.getBalanceSummary();
}

