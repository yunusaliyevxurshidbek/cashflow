import 'package:equatable/equatable.dart';
import '../../../domain/entities/transaction_entity.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();
  @override
  List<Object?> get props => [];
}

class ApplyFilterRequested extends FilterEvent {
  final TransactionType? type;
  final DateTime? dateStart;
  final DateTime? dateEnd;
  final String? category;
  final String? search;
  const ApplyFilterRequested({this.type, this.dateStart, this.dateEnd, this.category, this.search});
}

class ClearFilterRequested extends FilterEvent {}

