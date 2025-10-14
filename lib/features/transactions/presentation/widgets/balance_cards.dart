import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/formatters.dart';

class BalanceCards extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;
  final double netBalance;
  const BalanceCards({super.key, required this.totalIncome, required this.totalExpense, required this.netBalance});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _CardTile(title: 'Total Income', value: '+${formatAmount(totalIncome)}', color: Colors.green)),
            SizedBox(width: 12.w),
            Expanded(child: _CardTile(title: 'Total Expense', value: '-${formatAmount(totalExpense)}', color: Colors.red)),
          ],
        ),
        SizedBox(height: 12.h),
        _CardTile(title: 'Net Balance', value: formatAmount(netBalance), color: Theme.of(context).colorScheme.primary),
      ],
    );
  }
}

class _CardTile extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _CardTile({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(height: 8.h),
          Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color, fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }
}

