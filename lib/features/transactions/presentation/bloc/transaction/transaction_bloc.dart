import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../../domain/usecases/add_transaction.dart';
import '../../../domain/usecases/delete_transaction.dart';
import '../../../domain/usecases/export_json.dart';
import '../../../domain/usecases/filter_transactions.dart';
import '../../../domain/usecases/get_transactions.dart';
import '../../../domain/usecases/import_json.dart';
import '../../../domain/usecases/update_transaction.dart';
import '../balance/balance_bloc.dart';
import '../balance/balance_event.dart';
import '../filter/filter_bloc.dart';
import '../filter/filter_state.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final AddTransaction addTransaction;
  final UpdateTransaction updateTransaction;
  final DeleteTransaction deleteTransaction;
  final GetTransactions getTransactions;
  final FilterTransactions filterTransactions;
  final ExportJson exportJson;
  final ImportJson importJson;
  final FilterBloc filterBloc;
  final BalanceBloc balanceBloc;

  late final StreamSubscription _filterSub;

  TransactionBloc({
    required this.addTransaction,
    required this.updateTransaction,
    required this.deleteTransaction,
    required this.getTransactions,
    required this.filterTransactions,
    required this.exportJson,
    required this.importJson,
    required this.filterBloc,
    required this.balanceBloc,
  }) : super(TransactionInitial()) {
    on<LoadTransactionsRequested>(_onLoad);
    on<AddTransactionRequested>(_onAdd);
    on<UpdateTransactionRequested>(_onUpdate);
    on<DeleteTransactionRequested>(_onDelete);
    on<ExportJsonRequested>(_onExport);
    on<ImportJsonRequested>(_onImport);

    // When filter changes, reload list
    _filterSub = filterBloc.stream.listen((state) {
      add(LoadTransactionsRequested());
    });
  }

  Future<void> _onLoad(LoadTransactionsRequested event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    try {
      final fs = filterBloc.state;
      if (_hasAnyFilter(fs)) {
        final items = await filterTransactions(FilterParams(
          type: fs.type,
          start: fs.dateStart,
          end: fs.dateEnd,
          category: fs.category,
          search: fs.search,
        ));
        emit(items.isEmpty ? TransactionEmpty() : TransactionLoaded(items));
      } else {
        final items = await getTransactions( NoParams());
        emit(items.isEmpty ? TransactionEmpty() : TransactionLoaded(items));
      }
    } catch (e) {
      emit(TransactionError('Failed to load: $e'));
    }
  }

  Future<void> _onAdd(AddTransactionRequested event, Emitter<TransactionState> emit) async {
    try {
      await addTransaction(event.entity);
      balanceBloc.add(RecomputeBalanceRequested());
      add(LoadTransactionsRequested());
      emit(const TransactionOperationSuccess('Income added successfully'));
    } catch (e) {
      emit(TransactionError('Add failed: $e'));
    }
  }

  Future<void> _onUpdate(UpdateTransactionRequested event, Emitter<TransactionState> emit) async {
    try {
      await updateTransaction(event.entity);
      balanceBloc.add(RecomputeBalanceRequested());
      add(LoadTransactionsRequested());
      emit(const TransactionOperationSuccess('Transaction updated successfully'));
    } catch (e) {
      emit(TransactionError('Update failed: $e'));
    }
  }

  Future<void> _onDelete(DeleteTransactionRequested event, Emitter<TransactionState> emit) async {
    try {
      await deleteTransaction(event.id);
      balanceBloc.add(RecomputeBalanceRequested());
      add(LoadTransactionsRequested());
      emit(const TransactionOperationSuccess('Transaction deleted'));
    } catch (e) {
      emit(TransactionError('Delete failed: $e'));
    }
  }

  Future<void> _onExport(ExportJsonRequested event, Emitter<TransactionState> emit) async {
    try {
      final jsonString = await exportJson( NoParams());
      emit(TransactionExportSuccess(jsonString));
      add(LoadTransactionsRequested());
    } catch (e) {
      emit(TransactionError('Export failed: $e'));
    }
  }

  Future<void> _onImport(ImportJsonRequested event, Emitter<TransactionState> emit) async {
    try {
      final count = await importJson(event.json);
      balanceBloc.add(RecomputeBalanceRequested());
      add(LoadTransactionsRequested());
      emit(TransactionImportSuccess(count));
    } catch (e) {
      emit(TransactionError('Import failed: $e'));
    }
  }

  bool _hasAnyFilter(FilterState s) => s.type != null || s.dateStart != null || s.dateEnd != null || (s.category != null && s.category!.isNotEmpty) || (s.search != null && s.search!.isNotEmpty);

  @override
  Future<void> close() {
    _filterSub.cancel();
    return super.close();
  }
}

