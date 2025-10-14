import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/entities/transaction_entity.dart';
import '../../../../core/utils/formatters.dart';

class TransactionCard extends StatelessWidget {
  final TransactionEntity entity;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const TransactionCard({super.key, required this.entity, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isIncome = entity.type == TransactionType.income;
    final color = isIncome ? Colors.green : Colors.red;
    final prefix = isIncome ? '+' : '-';
    return Card(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(isIncome ? Icons.south_west : Icons.north_east, color: color)),
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
                      const Icon(Icons.notes, size: 14),
                      SizedBox(width: 4.w),
                      Expanded(child: Text(entity.note!, style: Theme.of(context).textTheme.bodySmall)),
                    ]
                  ],
                ),
              ]),
            ),
            SizedBox(width: 8.w),
            IconButton(tooltip: 'Edit', onPressed: onEdit, icon: const Icon(Icons.edit)),
            IconButton(tooltip: 'Delete', onPressed: onDelete, icon: const Icon(Icons.delete_outline)),
          ],
        ),
      ),
    );
  }
}

