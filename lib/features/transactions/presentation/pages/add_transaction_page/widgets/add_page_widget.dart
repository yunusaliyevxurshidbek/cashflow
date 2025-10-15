import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:income_expense_tracker/core/constants/app_colors.dart';
import 'package:income_expense_tracker/core/constants/app_spacing.dart';
import 'package:income_expense_tracker/core/constants/app_typography.dart';
import 'package:income_expense_tracker/features/transactions/domain/entities/transaction_entity.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/transaction/transaction_event.dart';
import 'package:income_expense_tracker/features/transactions/presentation/pages/add_transaction_page/widgets/switchable_buttons.dart';
import 'package:income_expense_tracker/features/transactions/presentation/widgets/custom_snacbar.dart';
import 'package:uuid/uuid.dart';
import '../../../bloc/balance/balance_bloc.dart';
import '../../../bloc/balance/balance_event.dart';
import '../../main_page.dart';

class AddPageWidget extends StatefulWidget {
  final TransactionEntity? initial;
  final bool popOnSubmit;
  const AddPageWidget({super.key, this.initial, this.popOnSubmit = true});

  @override
  State<AddPageWidget> createState() => _AddPageWidgetState();
}

class _AddPageWidgetState extends State<AddPageWidget> {
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
          // expense_income_container:
          Container(
            width: double.infinity,
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
                  style: AppTypography.cardTitle(context)
                      .copyWith(fontSize: 14.sp),
                ),
                AppSpacing.verticalSm,
                TransactionTypeSwitch(
                  selected: _type,
                  onChanged: (v) => setState(() => _type = v),
                ),
              ],
            ),
          ),

          AppSpacing.verticalLg,

          // category_field:
          TextFormField(
            controller: _categoryController,
            decoration: const InputDecoration(
              prefixIcon:
                  Icon(Icons.category_outlined, color: AppColors.mutedText),
              labelText: 'Category',
              hintText: 'e.g., Food, Salary, Transport',
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Category is required' : null,
            textCapitalization: TextCapitalization.words,
          ),
          AppSpacing.verticalMd,

          // amount_field:
          TextFormField(
            controller: _amountController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.attach_money, color: AppColors.mutedText),
              labelText: 'Amount',
              hintText: '0.00',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (v) {
              final d = double.tryParse(v ?? '');
              if (d == null || d <= 0)
                return 'Please enter a valid amount greater than 0';
              return null;
            },
          ),
          AppSpacing.verticalMd,

          // date_picker:
          InkWell(
            onTap: () async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: _date ?? now,
                firstDate: DateTime(now.year - 5),
                lastDate: now,
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.dark(
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
                  SvgPicture.asset(
                    "assets/icons/calendar.svg",
                    colorFilter: const ColorFilter.mode(
                      AppColors.mutedText,
                      BlendMode.srcIn,
                    ),
                  ),
                  AppSpacing.horizontalMd,
                  Expanded(
                    child: Text(
                      _date == null
                          ? 'Select date'
                          : '${_date!.day}-${_date!.month}-${_date!.year}',
                      style: TextStyle(
                        color: _date == null
                            ? AppColors.mutedText
                            : AppColors.secondaryText,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down,
                      color: AppColors.mutedText),
                ],
              ),
            ),
          ),

          AppSpacing.verticalMd,

          // note_field:
          TextFormField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: 'Note (optional) ...',
              hintText: 'Add a note for this transaction',
              alignLabelWithHint: true,
            ),
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
          ),
          AppSpacing.verticalXxl,

          // submit_button:
          _GradientButton(
              text: _id == null ? 'Add Transaction' : 'Update Transaction',
              onPressed: _valid ? _submit : null),
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
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    final transactionBloc = context.read<TransactionBloc>();
    final balanceBloc = context.read<BalanceBloc>();

    if (_id == null) {
      transactionBloc.add(AddTransactionRequested(entity));
      CustomSnacbar.show(
        context,
        isError: false,
        text: 'Income/Expense added successfully',
      );
    } else {
      transactionBloc.add(UpdateTransactionRequested(entity));
      CustomSnacbar.show(
        context,
        isError: false,
        text: 'Transaction updated successfully',
      );
    }

    transactionBloc.add(LoadTransactionsRequested());
    balanceBloc.add(LoadBalanceRequested());

    if (widget.popOnSubmit) {
      Navigator.of(context).pop();
      return;
    }

    _categoryController.clear();
    _amountController.clear();
    _date = null;
    _noteController.clear();
    _id = null;
    _type = TransactionType.expense;
    setState(() {});

    MainPage.globalKey.currentState?.switchToHome();
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
              color: AppColors.primary.withAlpha(77),
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
