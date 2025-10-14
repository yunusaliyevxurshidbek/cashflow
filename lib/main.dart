import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app.dart';
import 'core/di/injection_container.dart' as di;
import 'features/transactions/presentation/bloc/balance/balance_bloc.dart';
import 'features/transactions/presentation/bloc/balance/balance_event.dart';
import 'features/transactions/presentation/bloc/filter/filter_bloc.dart';
import 'features/transactions/presentation/bloc/transaction/transaction_bloc.dart';
import 'features/transactions/presentation/bloc/transaction/transaction_event.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.initDependencies();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  runZonedGuarded(() {
    runApp(
      ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        builder: (context, _) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => di.sl<FilterBloc>()),
            BlocProvider(create: (_) => di.sl<BalanceBloc>()..add(LoadBalanceRequested())),
            BlocProvider(create: (_) => di.sl<TransactionBloc>()..add(LoadTransactionsRequested())),
          ],
          child: const IncomeExpenseApp(),
        ),
      ),
    );
  }, (error, stack) {
    debugPrint('Uncaught error: $error');
    debugPrint(stack.toString());
  });
}


// chart types
// export import yaxshi ishlamayapti
// yillarni o'zgartirgandan analysis da error chiqyapti