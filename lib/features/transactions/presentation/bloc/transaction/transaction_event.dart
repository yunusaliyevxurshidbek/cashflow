import 'package:equatable/equatable.dart';
import '../../../domain/entities/transaction_entity.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
  @override
  List<Object?> get props => [];
}

class LoadTransactionsRequested extends TransactionEvent {}

class AddTransactionRequested extends TransactionEvent {
  final TransactionEntity entity;
  const AddTransactionRequested(this.entity);
}

class UpdateTransactionRequested extends TransactionEvent {
  final TransactionEntity entity;
  const UpdateTransactionRequested(this.entity);
}

class DeleteTransactionRequested extends TransactionEvent {
  final String id;
  const DeleteTransactionRequested(this.id);
}

class ExportJsonRequested extends TransactionEvent {
  final String source; // e.g., 'home' or 'transactions'
  const ExportJsonRequested({required this.source});
}

class ImportJsonRequested extends TransactionEvent {
  final String json;
  final String source; // e.g., 'home' or 'transactions'
  const ImportJsonRequested(this.json, {required this.source});
}
