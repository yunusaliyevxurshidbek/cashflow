import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/transactions/data/datasources/local/transaction_local_datasource.dart';
import '../../features/transactions/data/repositories/transaction_repository_impl.dart';
import '../../features/transactions/domain/repositories/transaction_repository.dart';
import '../../features/transactions/domain/usecases/add_transaction.dart';
import '../../features/transactions/domain/usecases/delete_transaction.dart';
import '../../features/transactions/domain/usecases/export_json.dart';
import '../../features/transactions/domain/usecases/filter_transactions.dart';
import '../../features/transactions/domain/usecases/get_balance_summary.dart';
import '../../features/transactions/domain/usecases/get_transactions.dart';
import '../../features/transactions/domain/usecases/import_json.dart';
import '../../features/transactions/domain/usecases/update_transaction.dart';
import '../../features/transactions/presentation/bloc/balance/balance_bloc.dart';
import '../../features/transactions/presentation/bloc/filter/filter_bloc.dart';
import '../../features/transactions/presentation/bloc/transaction/transaction_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final appDir = await getApplicationDocumentsDirectory();
  final dbPath = '${appDir.path}/income_expense_tracker.db';

  final localDataSource = TransactionLocalDataSource(dbPath: dbPath);
  await localDataSource.init();

  sl.registerLazySingleton<TransactionLocalDataSource>(() => localDataSource);

  sl.registerLazySingleton<TransactionRepository>(() => TransactionRepositoryImpl(sl()));

  sl.registerLazySingleton(() => AddTransaction(sl()));
  sl.registerLazySingleton(() => UpdateTransaction(sl()));
  sl.registerLazySingleton(() => DeleteTransaction(sl()));
  sl.registerLazySingleton(() => GetTransactions(sl()));
  sl.registerLazySingleton(() => FilterTransactions(sl()));
  sl.registerLazySingleton(() => GetBalanceSummary(sl()));
  sl.registerLazySingleton(() => ExportJson(sl()));
  sl.registerLazySingleton(() => ImportJson(sl()));

  // Provide shared instances of FilterBloc and BalanceBloc across the app
  // so TransactionBloc interacts with the same blocs used by the UI.
  sl.registerLazySingleton<FilterBloc>(() => FilterBloc());
  sl.registerLazySingleton<BalanceBloc>(() => BalanceBloc(getBalanceSummary: sl()));

  // TransactionBloc remains a factory, but it receives the shared blocs above.
  sl.registerFactory(() => TransactionBloc(
    addTransaction: sl(),
    updateTransaction: sl(),
    deleteTransaction: sl(),
    getTransactions: sl(),
    filterTransactions: sl(),
    exportJson: sl(),
    importJson: sl(),
    filterBloc: sl<FilterBloc>(),
    balanceBloc: sl<BalanceBloc>(),
  ));
}

