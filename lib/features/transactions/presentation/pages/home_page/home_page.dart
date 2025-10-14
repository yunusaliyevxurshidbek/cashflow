import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:income_expense_tracker/core/constants/app_colors.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../bloc/balance/balance_bloc.dart';
import '../../bloc/balance/balance_event.dart';
import '../../bloc/balance/balance_state.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_event.dart';
import '../../bloc/transaction/transaction_state.dart';
import '../../widgets/custom_snacbar.dart';
import '../analysis_page/widgets/chart_section.dart';
import 'widgets/balance_cards.dart';
import 'widgets/pie_chart_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<BalanceBloc>().add(LoadBalanceRequested());
    context.read<TransactionBloc>().add(LoadTransactionsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is TransactionExportSuccess && state.source == 'home') {
          _showExportDialog(context, state.jsonString);
        } else if (state is TransactionImportSuccess && state.source == 'home') {
          CustomSnacbar.show(
            context,
            isError: false,
            text: '${state.countImported} transactions imported successfully',
          );
        } else if (state is TransactionError) {
          CustomSnacbar.show(
            context,
            isError: false,
            text: 'Error: ${state.errorMessage}',
          );
        }
      },
      builder: (context, transactionState) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Dashboard', style: Theme.of(context).textTheme.titleLarge),
            actions: [
              IconButton(
                icon: SvgPicture.asset(
                    "assets/icons/import.svg",
                  height: 24.h,
                  width: 24.w,
                  colorFilter: const ColorFilter.mode(
                    AppColors.heading,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () => _showImportDialog(context),
                tooltip: 'Import JSON',
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/export.svg",
                  height: 24.h,
                  width: 24.w,
                  colorFilter: const ColorFilter.mode(
                    AppColors.heading,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () => context.read<TransactionBloc>().add(const ExportJsonRequested(source: 'home')),
                tooltip: 'Export JSON',
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: BlocBuilder<BalanceBloc, BalanceState>(
              builder: (context, balanceState) {
                if (balanceState is BalanceLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (balanceState is BalanceLoaded) {
                  return BlocBuilder<TransactionBloc, TransactionState>(
                    builder: (context, transactionState) {
                      if (transactionState is TransactionLoaded) {
                        final monthlyIncome = List.filled(12, 0.0);
                        final monthlyExpense = List.filled(12, 0.0);

                        for (final t in transactionState.items) {
                          final idx = t.date.month - 1;
                          if (t.type == TransactionType.income) monthlyIncome[idx] += t.amount;
                          if (t.type == TransactionType.expense) monthlyExpense[idx] += t.amount;
                        }

                        return Column(
                          children: [
                            BalanceCards(
                              totalIncome: balanceState.totalIncome,
                              totalExpense: balanceState.totalExpense,
                              netBalance: balanceState.netBalance,
                            ),
                            SizedBox(height: 24.h),
                            Expanded(
                              child: DefaultTabController(
                                length: 2,
                                child: Column(
                                  children: [
                                    const TabBar(
                                      tabs: [
                                        Tab(text: 'Line Chart'),
                                        Tab(text: 'Pie Chart'),
                                      ],
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        children: [
                                          SingleChildScrollView(
                                            child: ChartSection(
                                              monthlyIncome: monthlyIncome,
                                              monthlyExpense: monthlyExpense,
                                            ),
                                          ),
                                          SingleChildScrollView(
                                            child: PieChartSection(
                                              monthlyIncome: monthlyIncome,
                                              monthlyExpense: monthlyExpense,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return BalanceCards(
                        totalIncome: balanceState.totalIncome,
                        totalExpense: balanceState.totalExpense,
                        netBalance: balanceState.netBalance,
                      );
                    },
                  );
                }
                if (balanceState is BalanceError) {
                  return Center(child: Text(balanceState.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        );
      },
    );
  }

  void _showExportDialog(BuildContext context, String jsonString) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: SingleChildScrollView(
          child: SelectableText(jsonString),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: jsonString));
              CustomSnacbar.show(
                context,
                isError: false,
                text: 'JSON copied to clipboard',
              );
              Navigator.of(context).pop();
            },
            child:  const Text('Copy to Clipboard'),
          ),
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Data'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Paste JSON here',
            border: OutlineInputBorder(),
          ),
          maxLines: 10,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final json = controller.text.trim();
              if (json.isNotEmpty) {
                context.read<TransactionBloc>().add(ImportJsonRequested(json, source: 'home'));
                Navigator.of(context).pop();
              }
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }
}
