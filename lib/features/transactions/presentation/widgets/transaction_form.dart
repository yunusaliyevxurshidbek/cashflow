import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:income_expense_tracker/features/transactions/domain/entities/transaction_entity.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/transaction/transaction_event.dart';
import 'package:income_expense_tracker/core/constants/app_colors.dart';
import 'package:income_expense_tracker/core/constants/app_spacing.dart';
import 'package:income_expense_tracker/core/constants/app_typography.dart';
import 'package:uuid/uuid.dart';

/// Reusable Transaction Form used across Add tab and standalone page
class TransactionForm extends StatefulWidget {
  final TransactionEntity? initial;
  final bool popOnSubmit;
  const TransactionForm({super.key, this.initial, this.popOnSubmit = true});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  TransactionType _type = TransactionType.expense;
  final _categoryController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _date;
  final _noteController = TextEditingController();
  String? _id;

  @override
  void initState() {
    super.initState();
    final arg = widget.initial;
    if (arg != null) {
      _id = arg.id;
      _type = arg.type;
      _categoryController.text = arg.category;
      _amountController.text = arg.amount.toStringAsFixed(2);
      _date = arg.date;
      _noteController.text = arg.note ?? '';
    }
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  bool get _valid => _formKey.currentState?.validate() == true && _date != null;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: () => setState(() {}),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type Selection
          Container(
            padding: AppSpacing.cardPaddingSmall,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transaction Type',
                  style: AppTypography.cardTitle(context).copyWith(fontSize: 14.sp),
                ),
                AppSpacing.verticalSm,
                SegmentedButton<TransactionType>(
                  segments: const [
                    ButtonSegment(
                      value: TransactionType.income,
                      label: Text('Income'),
                      icon: Icon(Icons.arrow_downward),
                    ),
                    ButtonSegment(
                      value: TransactionType.expense,
                      label: Text('Expense'),
                      icon: Icon(Icons.arrow_upward),
                    ),
                  ],
                  selected: {_type},
                  onSelectionChanged: (s) => setState(() => _type = s.first),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return _type == TransactionType.income
                            ? AppColors.income.withOpacity(0.2)
                            : AppColors.expense.withOpacity(0.2);
                      }
                      return AppColors.surface;
                    }),
                    foregroundColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return _type == TransactionType.income
                            ? AppColors.income
                            : AppColors.expense;
                      }
                      return AppColors.secondaryText;
                    }),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.verticalLg,

          // Category Field
          TextFormField(
            controller: _categoryController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.category_outlined, color: AppColors.primary),
              labelText: 'Category',
              hintText: 'e.g., Food, Salary, Transport',
            ),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Category is required' : null,
            textCapitalization: TextCapitalization.words,
          ),
          AppSpacing.verticalMd,

          // Amount Field
          TextFormField(
            controller: _amountController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.attach_money, color: AppColors.primary),
              labelText: 'Amount',
              hintText: '0.00',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (v) {
              final d = double.tryParse(v ?? '');
              if (d == null || d <= 0) return 'Please enter a valid amount greater than 0';
              return null;
            },
          ),
          AppSpacing.verticalMd,

          // Date Picker
          InkWell(
            onTap: () async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: _date ?? now,
                firstDate: DateTime(now.year - 5),
                lastDate: DateTime(now.year + 5),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.dark(
                        primary: AppColors.primary,
                        surface: AppColors.surface,
                        onSurface: AppColors.secondaryText,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) setState(() => _date = picked);
            },
            child: Container(
              padding: AppSpacing.cardPadding,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Row(
                children: [
                  Icon(Icons.date_range, color: AppColors.primary),
                  AppSpacing.horizontalMd,
                  Expanded(
                    child: Text(
                      _date == null
                          ? 'Select date'
                          : '${_date!.day}/${_date!.month}/${_date!.year}',
                      style: TextStyle(
                        color: _date == null ? AppColors.mutedText : AppColors.secondaryText,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: AppColors.mutedText),
                ],
              ),
            ),
          ),
          AppSpacing.verticalMd,

          // Note Field
          TextFormField(
            controller: _noteController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.notes, color: AppColors.primary),
              labelText: 'Note (optional)',
              hintText: 'Add a note for this transaction',
            ),
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
          ),
          AppSpacing.verticalXxl,

          // Submit Button
          _GradientButton(text: _id == null ? 'Add Transaction' : 'Update Transaction', onPressed: _valid ? _submit : null),
        ],
      ),
    );
  }

  void _submit() {
    if (!_valid) return;
    final entity = TransactionEntity(
      id: _id ?? const Uuid().v4(),
      type: _type,
      category: _categoryController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      date: _date!,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    );
    final bloc = context.read<TransactionBloc>();
    if (_id == null) {
      bloc.add(AddTransactionRequested(entity));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Income/Expense added successfully ✅')));
      if (!widget.popOnSubmit) {
        _categoryController.clear();
        _amountController.clear();
        _date = null;
        _noteController.clear();
        setState(() {});
        return;
      }
    } else {
      bloc.add(UpdateTransactionRequested(entity));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaction updated successfully')));
    }
    if (widget.popOnSubmit && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}

class _GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  const _GradientButton({required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: enabled ? 1.0 : 0.6,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          gradient: AppColors.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: AppSpacing.elevationXl,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            onTap: onPressed,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Center(
                child: Text(
                  text,
                  style: AppTypography.buttonText(context).copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

