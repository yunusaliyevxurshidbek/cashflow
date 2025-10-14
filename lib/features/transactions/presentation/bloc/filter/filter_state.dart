import 'package:equatable/equatable.dart';
import '../../../domain/entities/transaction_entity.dart';

class FilterState extends Equatable {
  final TransactionType? type;
  final DateTime? dateStart;
  final DateTime? dateEnd;
  final String? category;
  final String? search;

  const FilterState({this.type, this.dateStart, this.dateEnd, this.category, this.search});

  factory FilterState.initial() => const FilterState();

  FilterState copyWith({
    TransactionType? type,
    DateTime? dateStart,
    DateTime? dateEnd,
    String? category,
    String? search,
  }) =>
      FilterState(
        type: type,
        dateStart: dateStart,
        dateEnd: dateEnd,
        category: category,
        search: search,
      );

  @override
  List<Object?> get props => [type, dateStart, dateEnd, category, search];
}

