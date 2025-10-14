part of 'transaction_model.dart';

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) => TransactionModel(
      id: json['id'] as String,
      type: json['type'] as String,
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: (json['date'] as num).toInt(),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'category': instance.category,
      'amount': instance.amount,
      'date': instance.date,
      'note': instance.note,
    };

