import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/transaction_entity.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel {
  final String id;
  final String type; // 'income' | 'expense'
  final String category;
  final double amount;
  final int date; // epoch millis
  final String? note;

  const TransactionModel({
    required this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
    this.note,
  });

  factory TransactionModel.fromEntity(TransactionEntity e) => TransactionModel(
        id: e.id,
        type: e.type.name,
        category: e.category,
        amount: e.amount,
        date: e.date.millisecondsSinceEpoch,
        note: e.note,
      );

  TransactionEntity toEntity() => TransactionEntity(
        id: id,
        type: type == 'income' ? TransactionType.income : TransactionType.expense,
        category: category,
        amount: amount,
        date: DateTime.fromMillisecondsSinceEpoch(date),
        note: note,
      );

  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
}

