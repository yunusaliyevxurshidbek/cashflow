import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/constants/app_typography.dart';
import '../../../../domain/entities/transaction_entity.dart';

class TransactionTypeSwitch extends StatelessWidget {
  final TransactionType selected;
  final ValueChanged<TransactionType> onChanged;

  const TransactionTypeSwitch({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = selected == TransactionType.income;

    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            alignment: isIncome ? Alignment.centerLeft : Alignment.centerRight,
            curve: Curves.easeInOut,
            child: Container(
              width: (MediaQuery.of(context).size.width - 100) / 2,
              height: 42.h,
              decoration: BoxDecoration(
                color: isIncome
                    ? AppColors.income.withAlpha(45)
                    : AppColors.expense.withAlpha(45),
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildOption(
                context,
                icon: Icons.arrow_downward,
                label: 'Income',
                active: isIncome,
                color: AppColors.income,
                onTap: () => onChanged(TransactionType.income),
              ),
              _buildOption(
                context,
                icon: Icons.arrow_upward,
                label: 'Expense',
                active: !isIncome,
                color: AppColors.expense,
                onTap: () => onChanged(TransactionType.expense),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
      BuildContext context, {
        required IconData icon,
        required String label,
        required bool active,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18.sp,
                  color: active ? color : AppColors.secondaryText),
              SizedBox(width: 6.w),
              Text(
                label,
                style: AppTypography.cardTitle(context).copyWith(
                  fontSize: 14.sp,
                  color: active ? color : AppColors.secondaryText,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
