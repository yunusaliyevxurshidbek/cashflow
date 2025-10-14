import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_balance_summary.dart';
import 'balance_event.dart';
import 'balance_state.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {
  final GetBalanceSummary getBalanceSummary;
  BalanceBloc({required this.getBalanceSummary}) : super(BalanceInitial()) {
    on<LoadBalanceRequested>(_load);
    on<RecomputeBalanceRequested>(_load);
  }

  Future<void> _load(BalanceEvent event, Emitter<BalanceState> emit) async {
    emit(BalanceLoading());
    try {
      final s = await getBalanceSummary(const NoParams());
      emit(BalanceLoaded(totalIncome: s.totalIncome, totalExpense: s.totalExpense, netBalance: s.netBalance));
    } catch (e) {
      emit(BalanceError('Failed to load balance: $e'));
    }
  }
}

