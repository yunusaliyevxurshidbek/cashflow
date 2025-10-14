import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'analysis_page.dart';
import 'transactions_page.dart';
import 'add_tab_page.dart';

/// Shell with Animated Notch Bottom Bar and three tabs: Transactions, Analysis, Add
class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  final _controller = NotchBottomBarController(index: 0);
  int _index = 0;

  final _pages = const [
    TransactionsPage(),
    AnalysisPage(),
    AddTabPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: _pages[_index],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        showLabel: true,
        kIconSize: 24.sp,
        kBottomRadius: 18.r,
        notchColor: Theme.of(context).colorScheme.primary,
        color: Theme.of(context).colorScheme.surface,
        elevation: 8,
        blurOpacity: 0.05,
        durationInMilliSeconds: 220,
        bottomBarItems: [
          const BottomBarItem(
            inActiveItem: Icon(Icons.list_alt_outlined),
            activeItem: Icon(Icons.list_alt),
            itemLabel: 'Transactions',
          ),
          const BottomBarItem(
            inActiveItem: Icon(Icons.insights_outlined),
            activeItem: Icon(Icons.insights),
            itemLabel: 'Analysis',
          ),
          const BottomBarItem(
            inActiveItem: Icon(Icons.add_circle_outline),
            activeItem: Icon(Icons.add_circle),
            itemLabel: 'Add',
          ),
        ],
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

