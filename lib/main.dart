import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.dart';
import 'core/errors/exceptions.dart';
import 'features/transactions/data/datasources/local/transaction_local_datasource.dart';
import 'features/transactions/data/repositories/transaction_repository_impl.dart';
import 'features/transactions/domain/usecases/add_transaction.dart';
import 'features/transactions/domain/usecases/delete_transaction.dart';
import 'features/transactions/domain/usecases/export_json.dart';
import 'features/transactions/domain/usecases/filter_transactions.dart';
import 'features/transactions/domain/usecases/get_balance_summary.dart';
import 'features/transactions/domain/usecases/get_transactions.dart';
import 'features/transactions/domain/usecases/import_json.dart';
import 'features/transactions/domain/usecases/update_transaction.dart';
import 'features/transactions/presentation/bloc/balance/balance_bloc.dart';
import 'features/transactions/presentation/bloc/filter/filter_bloc.dart';
import 'features/transactions/presentation/bloc/transaction/transaction_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SQLite local datasource
  final appDir = await getApplicationDocumentsDirectory();
  final dbPath = '${appDir.path}/income_expense_tracker.db';
  final localDataSource = TransactionLocalDataSource(dbPath: dbPath);
  await localDataSource.init();

  // Optional seeder behind debug flag for demo data
  if (kDebugMode) {
    await localDataSource.seedIfEmpty();
  }

  // Repository
  final transactionRepository = TransactionRepositoryImpl(localDataSource);

  // Use cases
  final addTransaction = AddTransaction(transactionRepository);
  final updateTransaction = UpdateTransaction(transactionRepository);
  final deleteTransaction = DeleteTransaction(transactionRepository);
  final getTransactions = GetTransactions(transactionRepository);
  final filterTransactions = FilterTransactions(transactionRepository);
  final getBalanceSummary = GetBalanceSummary(transactionRepository);
  final exportJson = ExportJson(transactionRepository);
  final importJson = ImportJson(transactionRepository);

  // Blocs
  final filterBloc = FilterBloc();
  final balanceBloc = BalanceBloc(getBalanceSummary: getBalanceSummary);
  final transactionBloc = TransactionBloc(
    addTransaction: addTransaction,
    updateTransaction: updateTransaction,
    deleteTransaction: deleteTransaction,
    getTransactions: getTransactions,
    filterTransactions: filterTransactions,
    exportJson: exportJson,
    importJson: importJson,
    filterBloc: filterBloc,
    balanceBloc: balanceBloc,
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  runZonedGuarded(() {
    runApp(ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (context, _) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => filterBloc),
          BlocProvider(create: (_) => balanceBloc),
          BlocProvider(create: (_) => transactionBloc..add(LoadTransactionsRequested())),
        ],
        child: const IncomeExpenseApp(),
      ),
    ));
  }, (error, stack) {
    // ignore: avoid_print
    print('Uncaught error: $error');
  });
}
