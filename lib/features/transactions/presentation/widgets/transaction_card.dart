import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:income_expense_tracker/core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
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
    final gradient = isIncome ? AppColors.incomeGradient : AppColors.expenseGradient;

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppColors.border.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Row(
          children: [
            // Icon with gradient background
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                color: Colors.white,
                size: AppSpacing.iconMd,
              ),
            ),
            AppSpacing.horizontalMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entity.category,
                          style: AppTypography.cardTitle(context).copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        '$prefix${formatAmount(entity.amount)}',
                        style: TextStyle(
                          color: color,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.verticalXs,
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: AppSpacing.iconXs,
                        color: AppColors.mutedText,
                      ),
                      AppSpacing.horizontalXs,
                      Text(
                        formatDate(entity.date),
                        style: AppTypography.cardSubtitle(context),
                      ),
                      if (entity.note != null && entity.note!.isNotEmpty) ...[
                        AppSpacing.horizontalSm,
                        Icon(
                          Icons.notes,
                          size: AppSpacing.iconXs,
                          color: AppColors.mutedText,
                        ),
                        AppSpacing.horizontalXs,
                        Expanded(
                          child: Text(
                            entity.note!,
                            style: AppTypography.cardSubtitle(context),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.horizontalSm,
            // Type badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                isIncome ? 'Income' : 'Expense',
                style: TextStyle(
                  color: color,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            AppSpacing.horizontalXs,
            // Action buttons
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') onEdit();
                if (value == 'delete') onDelete();
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: AppSpacing.iconSm, color: AppColors.primary),
                      AppSpacing.horizontalSm,
                      Text('Edit', style: TextStyle(fontSize: 14.sp)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: AppSpacing.iconSm, color: AppColors.expense),
                      AppSpacing.horizontalSm,
                      Text('Delete', style: TextStyle(fontSize: 14.sp)),
                    ],
                  ),
                ),
              ],
              icon: Icon(
                Icons.more_vert,
                size: AppSpacing.iconMd,
                color: AppColors.mutedText,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
