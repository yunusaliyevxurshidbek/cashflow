import 'package:flutter/material.dart';
import 'core/constants/app_theme.dart';
import 'core/constants/app_typography.dart';
import 'features/transactions/presentation/pages/add_transaction_page/add_page.dart';
import 'features/transactions/presentation/pages/analysis_page/analysis_page.dart';
import 'features/transactions/presentation/pages/main_page.dart';
import 'features/transactions/presentation/pages/transaction_page/transactions_page.dart';

class IncomeExpenseApp extends StatelessWidget {
  const IncomeExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final light = AppTheme.light.copyWith(textTheme: AppTypography.textTheme(context));
    final dark = AppTheme.dark.copyWith(textTheme: AppTypography.textTheme(context));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: light,
      darkTheme: dark,
      initialRoute: '/',
      routes: {
        '/': (_) => const MainPage(),
        '/transactions': (_) => const TransactionsPage(),
        '/form': (_) => const AddPage(),
        '/analysis': (_) => const AnalysisPage(),
      },
    );
  }
}
