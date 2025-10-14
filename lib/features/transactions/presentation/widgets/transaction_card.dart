import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:income_expense_tracker/core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/transaction_entity.dart';

class TransactionCard extends StatelessWidget {
  final TransactionEntity entity;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const TransactionCard({super.key, required this.entity, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isIncome = entity.type == TransactionType.income;
    final color = isIncome ? AppColors.income : AppColors.expense;
    final prefix = isIncome ? '+' : '-';
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            CircleAvatar(radius: 18.r, backgroundColor: color.withOpacity(0.15), child: Icon(isIncome ? Icons.south_west : Icons.north_east, color: color, size: 18.sp)),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    Expanded(child: Text(entity.category, style: Theme.of(context).textTheme.titleMedium)),
                    Text('$prefix${formatAmount(entity.amount)}', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color, fontWeight: FontWeight.w600)),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(formatDate(entity.date), style: Theme.of(context).textTheme.bodySmall),
                    if (entity.note != null && entity.note!.isNotEmpty) ...[
                      SizedBox(width: 8.w),
                      Icon(Icons.notes, size: 14.sp),
                      SizedBox(width: 4.w),
                      Expanded(child: Text(entity.note!, style: Theme.of(context).textTheme.bodySmall)),
                    ]
                  ],
                ),
              ]),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12.r), border: Border.all(color: color.withOpacity(0.4))),
              child: Text(isIncome ? 'Income' : 'Expense', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w600)),
            ),
            SizedBox(width: 4.w),
            IconButton(tooltip: 'Edit', onPressed: onEdit, icon: Icon(Icons.edit, size: 20.sp)),
            IconButton(tooltip: 'Delete', onPressed: onDelete, icon: Icon(Icons.delete_outline, size: 20.sp)),
          ],
        ),
      ),
    );
  }
}
