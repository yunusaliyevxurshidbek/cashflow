import 'package:equatable/equatable.dart';

enum TransactionType { income, expense }

class TransactionEntity extends Equatable {
  final String id;
  final TransactionType type;
  final String category;
  final double amount;
  final DateTime date;
  final String? note;

  const TransactionEntity({
    required this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
    this.note,
  });

  TransactionEntity copyWith({
    String? id,
    TransactionType? type,
    String? category,
    double? amount,
    DateTime? date,
    String? note,
  }) =>
      TransactionEntity(
        id: id ?? this.id,
        type: type ?? this.type,
        category: category ?? this.category,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        note: note ?? this.note,
      );

  @override
  List<Object?> get props => [id, type, category, amount, date, note];
}

