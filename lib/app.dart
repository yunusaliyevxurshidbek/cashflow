import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/transactions/presentation/pages/analysis_page.dart';
import 'features/transactions/presentation/pages/home_page.dart';
import 'features/transactions/presentation/pages/transaction_form_page.dart';
import 'features/transactions/presentation/pages/transactions_page.dart';

class IncomeExpenseApp extends StatelessWidget {
  const IncomeExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = GoogleFonts.interTextTheme(Theme.of(context).textTheme);
    return MaterialApp(
      title: 'Income & Expense Tracker',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        textTheme: baseTextTheme,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark),
        textTheme: baseTextTheme,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomePage(),
        '/transactions': (_) => const TransactionsPage(),
        '/form': (_) => const TransactionFormPage(),
        '/analysis': (_) => const AnalysisPage(),
      },
    );
  }
}

