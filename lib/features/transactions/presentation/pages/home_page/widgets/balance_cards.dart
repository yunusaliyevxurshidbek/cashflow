import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/utils/formatters.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/constants/app_typography.dart';

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
            Expanded(
              child: _CardTile(
                title: 'Total Income',
                value: '+${formatAmount(totalIncome)}',
                color: AppColors.income,
                gradient: AppColors.incomeGradient,
                icon: Icons.arrow_upward,
              ),
            ),
            AppSpacing.horizontalMd,
            Expanded(
              child: _CardTile(
                title: 'Total Expense',
                value: '-${formatAmount(totalExpense)}',
                color: AppColors.expense,
                gradient: AppColors.expenseGradient,
                icon: Icons.arrow_downward,
              ),
            ),
          ],
        ),
        AppSpacing.verticalMd,
        _CardTile(
          title: 'Net Balance',
          value: formatAmount(netBalance),
          color: Theme.of(context).colorScheme.primary,
          gradient: AppColors.primaryGradient,
          icon: Icons.account_balance_wallet,
          isFullWidth: true,
        ),
      ],
    );
  }
}

class _CardTile extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final LinearGradient gradient;
  final IconData icon;
  final bool isFullWidth;
  const _CardTile({
    required this.title,
    required this.value,
    required this.color,
    required this.gradient,
    required this.icon,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(77),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white.withAlpha(230), size: AppSpacing.iconMd),
              AppSpacing.horizontalSm,
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.cardSubtitle(context).copyWith(
                    color: Colors.white.withAlpha(230),
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.verticalMd,
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
