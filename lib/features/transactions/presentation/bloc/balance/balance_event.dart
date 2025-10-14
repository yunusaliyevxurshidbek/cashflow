import 'package:equatable/equatable.dart';

abstract class BalanceEvent extends Equatable {
  const BalanceEvent();
  @override
  List<Object?> get props => [];
}

class LoadBalanceRequested extends BalanceEvent {}

class RecomputeBalanceRequested extends BalanceEvent {}

