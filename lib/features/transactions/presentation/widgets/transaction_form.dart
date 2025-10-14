import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:income_expense_tracker/features/transactions/domain/entities/transaction_entity.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/transaction/transaction_event.dart';
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
          SegmentedButton<TransactionType>(
            segments: const [
              ButtonSegment(value: TransactionType.income, label: Text('Income'), icon: Icon(Icons.arrow_downward)),
              ButtonSegment(value: TransactionType.expense, label: Text('Expense'), icon: Icon(Icons.arrow_upward)),
            ],
            selected: {_type},
            onSelectionChanged: (s) => setState(() => _type = s.first),
          ),
          SizedBox(height: 16.h),
          TextFormField(
            controller: _categoryController,
            decoration: InputDecoration(prefixIcon: const Icon(Icons.category_outlined), labelText: 'Category'),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Category required' : null,
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: _amountController,
            decoration: InputDecoration(prefixIcon: const Icon(Icons.attach_money), labelText: 'Amount'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (v) {
              final d = double.tryParse(v ?? '');
              if (d == null || d <= 0) return 'Enter amount > 0';
              return null;
            },
          ),
          SizedBox(height: 12.h),
          OutlinedButton.icon(
            onPressed: () async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: _date ?? now,
                firstDate: DateTime(now.year - 5),
                lastDate: DateTime(now.year + 5),
              );
              if (picked != null) setState(() => _date = picked);
            },
            icon: const Icon(Icons.date_range),
            label: Text(_date == null ? 'Pick date' : '${_date!.day}-${_date!.month}-${_date!.year}'),
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: _noteController,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.notes), labelText: 'Note (optional)'),
            maxLines: 2,
          ),
          SizedBox(height: 20.h),
          _GradientButton(text: _id == null ? 'Add' : 'Update', onPressed: _valid ? _submit : null),
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
          borderRadius: BorderRadius.circular(16.r),
          gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary.withOpacity(0.8)]),
          boxShadow: [
            BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.35), blurRadius: 16.r, offset: const Offset(0, 8)),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: onPressed,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              child: Center(child: Text(text, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: Colors.black))),
            ),
          ),
        ),
      ),
    );
  }
}

