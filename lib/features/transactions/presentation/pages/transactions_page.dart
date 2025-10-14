import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/entities/transaction_entity.dart';
import '../bloc/filter/filter_bloc.dart';
import '../bloc/filter/filter_event.dart';
import '../bloc/filter/filter_state.dart';
import '../bloc/transaction/transaction_bloc.dart';
import '../bloc/transaction/transaction_event.dart';
import '../bloc/transaction/transaction_state.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/filter_bar.dart';
import '../widgets/loading_view.dart';
import '../widgets/transaction_card.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            tooltip: 'Export JSON',
            onPressed: () => context.read<TransactionBloc>().add(ExportJsonRequested()),
            icon: const Icon(Icons.file_upload_outlined),
          ),
          IconButton(
            tooltip: 'Import JSON',
            onPressed: () async {
              final controller = TextEditingController();
              final json = await showDialog<String>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Import JSON'),
                  content: TextField(controller: controller, maxLines: 10, decoration: const InputDecoration(hintText: 'Paste JSON here')),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                    FilledButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('Import')),
                  ],
                ),
              );
              if (json != null && json.trim().isNotEmpty) {
                // ignore: use_build_context_synchronously
                context.read<TransactionBloc>().add(ImportJsonRequested(json));
              }
            },
            icon: const Icon(Icons.file_download_outlined),
          ),
          IconButton(
            tooltip: 'Add',
            onPressed: () => Navigator.pushNamed(context, '/form'),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: BlocBuilder<FilterBloc, FilterState>(
              builder: (context, state) => FilterBar(
                current: state,
                onApply: (f) => context.read<FilterBloc>().add(ApplyFilterRequested(
                      type: f.type,
                      dateStart: f.dateStart,
                      dateEnd: f.dateEnd,
                      category: f.category,
                      search: f.search,
                    )),
                onClear: () => context.read<FilterBloc>().add(ClearFilterRequested()),
              ),
            ),
          ),
          Expanded(
            child: BlocConsumer<TransactionBloc, TransactionState>(
              listener: (context, state) async {
                if (state is TransactionOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                } else if (state is TransactionImportSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Imported ${state.countImported} items')));
                } else if (state is TransactionError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));
                } else if (state is TransactionExportSuccess) {
                  // Offer copy to clipboard
                  try {
                    // late import to avoid platform issues on web
                    // ignore: avoid_dynamic_calls
                    // ignore: unnecessary_import
                  } catch (_) {}
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Export completed — JSON ready')));
                  await showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Export JSON'),
                      content: SingleChildScrollView(child: SelectableText(state.jsonString)),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                      ],
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is TransactionLoading) return const LoadingView();
                if (state is TransactionEmpty) return const EmptyView();
                if (state is TransactionError) return ErrorView(message: state.errorMessage);
                if (state is TransactionLoaded) {
                  final items = state.items;
                  return ListView.separated(
                    padding: EdgeInsets.all(12.w),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => SizedBox(height: 8.h),
                    itemBuilder: (context, index) {
                      final t = items[index];
                      return TransactionCard(
                        entity: t,
                        onEdit: () => Navigator.pushNamed(context, '/form', arguments: t),
                        onDelete: () => _confirmDelete(context, t),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, TransactionEntity t) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) {
      // ignore: use_build_context_synchronously
      context.read<TransactionBloc>().add(DeleteTransactionRequested(t.id));
    }
  }
}
