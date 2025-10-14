import 'package:equatable/equatable.dart';
import '../../../domain/entities/transaction_entity.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();
  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<TransactionEntity> items;
  const TransactionLoaded(this.items);
  @override
  List<Object?> get props => [items];
}

class TransactionOperationSuccess extends TransactionState {
  final String message;
  const TransactionOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class TransactionExportSuccess extends TransactionState {
  final String jsonString;
  const TransactionExportSuccess(this.jsonString);
  @override
  List<Object?> get props => [jsonString];
}

class TransactionImportSuccess extends TransactionState {
  final int countImported;
  const TransactionImportSuccess(this.countImported);
  @override
  List<Object?> get props => [countImported];
}

class TransactionEmpty extends TransactionState {}

class TransactionError extends TransactionState {
  final String errorMessage;
  const TransactionError(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}

