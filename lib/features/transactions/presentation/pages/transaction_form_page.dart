import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:income_expense_tracker/features/transactions/presentation/widgets/transaction_form.dart';
import '../../domain/entities/transaction_entity.dart';

class TransactionFormPage extends StatefulWidget {
  const TransactionFormPage({super.key});

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final _formKey = GlobalKey<FormState>();
  TransactionType _type = TransactionType.expense;
  final _categoryController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _date;
  final _noteController = TextEditingController();
  String? _id; // null => add

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is TransactionEntity && _id == null) {
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
    return Scaffold(
      appBar: AppBar(title: Text(_id == null ? 'Add Transaction' : 'Edit Transaction')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w), 
        child: TransactionForm(
          initial: _id == null ? null : _buildEntity(), 
          popOnSubmit: true,
          ),
        ),
    );
  }

  TransactionEntity _buildEntity() => TransactionEntity(
        id: _id!,
        type: _type,
        category: _categoryController.text.trim(),
        amount: double.tryParse(_amountController.text.trim()) ?? 0,
        date: _date ?? DateTime.now(),
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      );
}
