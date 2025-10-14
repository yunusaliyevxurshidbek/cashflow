import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:income_expense_tracker/features/transactions/presentation/widgets/custom_snacbar.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../bloc/filter/filter_bloc.dart';
import '../../bloc/filter/filter_event.dart';
import '../../bloc/filter/filter_state.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_event.dart';
import '../../bloc/transaction/transaction_state.dart';
import 'widgets/empty_view.dart';
import '../../widgets/error_view.dart';
import 'widgets/filter_bar_modern.dart';
import 'widgets/loading_view.dart';
import 'widgets/transaction_card.dart';

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
        title: Text('Transactions', style: Theme.of(context).textTheme.titleLarge),
        actions: [
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
                context.read<TransactionBloc>().add(ImportJsonRequested(json, source: 'transactions'));
              }
            },
            icon: SvgPicture.asset(
              "assets/icons/import.svg",
              height: 24.h,
              width: 24.w,
              colorFilter: const ColorFilter.mode(
                AppColors.heading,
                BlendMode.srcIn,
              ),
            ),
          ),

          IconButton(
            tooltip: 'Export JSON',
            onPressed: () => context.read<TransactionBloc>().add(const ExportJsonRequested(source: 'transactions')),
            icon: SvgPicture.asset(
              "assets/icons/export.svg",
              height: 24.h,
              width: 24.w,
              colorFilter: const ColorFilter.mode(
                AppColors.heading,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: BlocBuilder<FilterBloc, FilterState>(
              builder: (context, fState) => BlocBuilder<TransactionBloc, TransactionState>(
                builder: (context, tState) {
                  final categories = tState is TransactionLoaded ? tState.items.map((e) => e.category).toSet().toList() : <String>[];
                  return FilterBarModern(
                    current: fState,
                    categories: categories,
                    onApply: (f) => context.read<FilterBloc>().add(ApplyFilterRequested(
                          type: f.type,
                          dateStart: f.dateStart,
                          dateEnd: f.dateEnd,
                          category: f.category,
                          search: f.search,
                        )),
                    onClear: () => context.read<FilterBloc>().add(ClearFilterRequested()),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: BlocConsumer<TransactionBloc, TransactionState>(
              listener: (context, state) async {
                if (state is TransactionImportSuccess && state.source == 'transactions') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Imported ${state.countImported} items')));
                } else if (state is TransactionError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));
                } else if (state is TransactionExportSuccess && state.source == 'transactions') {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Export JSON'),
                      content: SingleChildScrollView(child: SelectableText(state.jsonString)),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                        FilledButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: state.jsonString));
                            CustomSnacbar.show(
                              context,
                              isError: false,
                              text: 'JSON copied to clipboard',
                            );
                            Navigator.pop(context);
                          },
                          child: const Text('Copy to Clipboard'),
                        ),
                      ],
                    ),
                  );
                }
              },
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: () {
                    if (state is TransactionLoading) return const LoadingView();
                    if (state is TransactionEmpty) return const EmptyView();
                    if (state is TransactionError) return ErrorView(message: state.errorMessage);
                    if (state is TransactionLoaded) {
                      final items = state.items;
                      return ListView.separated(
                        key: const ValueKey('list'),
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => SizedBox(height: 8.h),
                        itemBuilder: (context, index) {
                          final t = items[index];
                          return AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: 1.0,
                            child: TransactionCard(
                              entity: t,
                              onEdit: () => Navigator.pushNamed(context, '/form', arguments: t),
                              onDelete: () => _confirmDelete(context, t),
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  }(),
                );
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
      context.read<TransactionBloc>().add(DeleteTransactionRequested(t.id));
    }
  }
}
