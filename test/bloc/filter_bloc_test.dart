import 'package:flutter_test/flutter_test.dart';
import 'package:income_expense_tracker/features/transactions/domain/entities/transaction_entity.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/filter/filter_bloc.dart';
import 'package:income_expense_tracker/features/transactions/presentation/bloc/filter/filter_event.dart';

void main() {
  test('FilterBloc apply/clear', () async {
    final bloc = FilterBloc();
    expect(bloc.state.type, isNull);

    bloc.add(const ApplyFilterRequested(type: TransactionType.expense));
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(bloc.state.type, TransactionType.expense);

    bloc.add(ClearFilterRequested());
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(bloc.state.type, isNull);

    await bloc.close();
  });
}

