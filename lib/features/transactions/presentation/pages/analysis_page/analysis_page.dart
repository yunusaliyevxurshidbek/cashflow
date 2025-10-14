import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_event.dart';
import '../../bloc/transaction/transaction_state.dart';
import 'widgets/chart_section.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  int _year = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8.w),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _year,
                icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.onSecondary.withAlpha(230)),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary.withAlpha(220),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                items: List.generate(6, (i) => DateTime.now().year - i)
                    .map((y) => DropdownMenuItem(value: y, child: Text('$y')))
                    .toList(),
                onChanged: (v) => setState(() => _year = v ?? _year),
              ),
            ),
          ),
          IconButton(
            onPressed: () => context.read<TransactionBloc>().add(LoadTransactionsRequested()),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: () {
              if (state is TransactionLoaded) {
                final monthlyIncome = List.filled(12, 0.0);
                final monthlyExpense = List.filled(12, 0.0);

                for (final t in state.items) {
                  if (t.date.year != _year) continue;
                  final idx = t.date.month - 1;
                  if (t.type == TransactionType.income) monthlyIncome[idx] += t.amount;
                  if (t.type == TransactionType.expense) monthlyExpense[idx] += t.amount;
                }

                final totalIncome = monthlyIncome.reduce((a, b) => a + b);
                final totalExpense = monthlyExpense.reduce((a, b) => a + b);
                final net = totalIncome - totalExpense;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SummaryCards(
                        totalIncome: totalIncome,
                        totalExpense: totalExpense,
                        net: net,
                      ),
                      SizedBox(height: 24.h),
                      ChartSection(
                        monthlyIncome: monthlyIncome,
                        monthlyExpense: monthlyExpense,
                      ),
                    ],
                  ),
                );
              }
              if (state is TransactionLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is TransactionEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bar_chart_outlined, size: 80.sp, color: Colors.grey),
                      SizedBox(height: 16.h),
                      Text('No data available', style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(height: 8.h),
                      Text('Add transactions to see analysis', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }(),
          );
        },
      ),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;
  final double net;

  const _SummaryCards({
    required this.totalIncome,
    required this.totalExpense,
    required this.net,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Column(
      spacing: 12.h,
      children: [
        Row(
          spacing: 12.w,
          children: [
            Expanded(
              child: _SummaryCard(
                title: 'Total Income',
                amount: currencyFormat.format(totalIncome),
                color: const Color(0xFF4CAF50),
                icon: Icons.arrow_downward,
              ),
            ),
            Expanded(
              child: _SummaryCard(
                title: 'Total Expense',
                amount: currencyFormat.format(totalExpense),
                color: const Color(0xFFFF5E5E),
                icon: Icons.arrow_upward,
              ),
            ),
          ],
        ),
        _SummaryCard(
          title: 'Net Balance',
          amount: currencyFormat.format(net),
          color: net >= 0 ? const Color(0xFF2196F3) : const Color(0xFFFF9800),
          icon: net >= 0 ? Icons.trending_up : Icons.trending_down,
          isFullWidth: true,
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  final IconData icon;
  final bool isFullWidth;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withAlpha(77), width: 1),
      ),
      child: Column(
        spacing: 12.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8.w,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withAlpha(52),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: color, size: 20.sp),
              ),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Text(
            amount,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: isFullWidth ? 24.sp : 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}
