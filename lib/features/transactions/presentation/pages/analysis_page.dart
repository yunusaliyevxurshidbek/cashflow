import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/transaction_entity.dart';
import '../bloc/transaction/transaction_bloc.dart';
import '../bloc/transaction/transaction_event.dart';
import '../bloc/transaction/transaction_state.dart';

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
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _year,
              items: List.generate(6, (i) => DateTime.now().year - i)
                  .map((y) => DropdownMenuItem(value: y, child: Text('$y')))
                  .toList(),
              onChanged: (v) => setState(() => _year = v ?? _year),
            ),
          ),
          IconButton(onPressed: () => context.read<TransactionBloc>().add(LoadTransactionsRequested()), icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: BlocBuilder<TransactionBloc, TransactionState>(
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
                  return Column(
                    children: [
                      _SummaryRow(totalIncome: totalIncome, totalExpense: totalExpense, net: net),
                      SizedBox(height: 12.h),
                      Expanded(child: _buildBarChart(monthlyIncome, monthlyExpense)),
                    ],
                  );
                }
                if (state is TransactionLoading) return const Center(child: CircularProgressIndicator());
                if (state is TransactionEmpty) return const Center(child: Text('No data for chart'));
                return const SizedBox.shrink();
              }(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBarChart(List<double> income, List<double> expense) {
    final groups = List.generate(12, (i) {
      return BarChartGroupData(
        x: i,
        barsSpace: 4.w,
        barRods: [
          BarChartRodData(toY: income[i], color: Colors.green, width: 8.w),
          BarChartRodData(toY: expense[i], color: Colors.red, width: 8.w),
        ],
      );
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Monthly Income vs Expense', style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: 16.h),
        Expanded(
          child: BarChart(
            BarChartData(
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: false),
              barGroups: groups,
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (v, meta) => Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(['J','F','M','A','M','J','J','A','S','O','N','D'][v.toInt()]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: const [
            _Legend(color: Colors.green, text: 'Income'),
            SizedBox(width: 16),
            _Legend(color: Colors.red, text: 'Expense'),
          ],
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;
  final double net;
  const _SummaryRow({required this.totalIncome, required this.totalExpense, required this.net});

  @override
  Widget build(BuildContext context) {
    Widget _card(String title, double value, Color color) => Expanded(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: Theme.of(context).textTheme.bodySmall),
                SizedBox(height: 6.h),
                Text(value.toStringAsFixed(2), style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color)),
              ]),
            ),
          ),
        );

    return Row(
      children: [
        _card('Income', totalIncome, const Color(0xFF4CAF50)),
        SizedBox(width: 12.w),
        _card('Expense', totalExpense, const Color(0xFFFF5E5E)),
        SizedBox(width: 12.w),
        _card('Net', net, Theme.of(context).colorScheme.primary),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String text;
  const _Legend({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }
}
