import 'package:flutter/material.dart';
import 'core/constants/app_theme.dart';
import 'core/constants/app_typography.dart';
import 'features/transactions/presentation/pages/analysis_page.dart';
import 'features/transactions/presentation/pages/shell_page.dart';
import 'features/transactions/presentation/pages/transaction_form_page.dart';
import 'features/transactions/presentation/pages/transactions_page.dart';

class IncomeExpenseApp extends StatelessWidget {
  const IncomeExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final _light = AppTheme.light.copyWith(textTheme: AppTypography.textTheme(context));
    final _dark = AppTheme.dark.copyWith(textTheme: AppTypography.textTheme(context));
    return MaterialApp(
      title: 'Income & Expense Tracker',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: _light,
      darkTheme: _dark,
      initialRoute: '/',
      routes: {
        '/': (_) => const ShellPage(),
        '/transactions': (_) => const TransactionsPage(),
        '/form': (_) => const TransactionFormPage(),
        '/analysis': (_) => const AnalysisPage(),
      },
    );
  }
}
