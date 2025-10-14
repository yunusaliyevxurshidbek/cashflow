import 'package:equatable/equatable.dart';

class BalanceState extends Equatable {
  const BalanceState();
  @override
  List<Object?> get props => [];
}

class BalanceInitial extends BalanceState {}

class BalanceLoading extends BalanceState {}

class BalanceLoaded extends BalanceState {
  final double totalIncome;
  final double totalExpense;
  final double netBalance;
  const BalanceLoaded({required this.totalIncome, required this.totalExpense, required this.netBalance});
  @override
  List<Object?> get props => [totalIncome, totalExpense, netBalance];
}

class BalanceError extends BalanceState {
  final String message;
  const BalanceError(this.message);
  @override
  List<Object?> get props => [message];
}

