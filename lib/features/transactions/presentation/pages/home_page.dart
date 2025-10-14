import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/balance/balance_bloc.dart';
import '../bloc/balance/balance_event.dart';
import '../bloc/balance/balance_state.dart';
import '../widgets/balance_cards.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Transactions',
            icon: const Icon(Icons.list_alt),
            onPressed: () => Navigator.pushNamed(context, '/transactions'),
          ),
          IconButton(
            tooltip: 'Analysis',
            icon: const Icon(Icons.insights),
            onPressed: () => Navigator.pushNamed(context, '/analysis'),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: BlocBuilder<BalanceBloc, BalanceState>(
          builder: (context, state) {
            if (state is BalanceLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is BalanceLoaded) {
              return BalanceCards(
                totalIncome: state.totalIncome,
                totalExpense: state.totalExpense,
                netBalance: state.netBalance,
              );
            }
            if (state is BalanceError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/form'),
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

