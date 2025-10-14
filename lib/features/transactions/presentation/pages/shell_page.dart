import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'analysis_page.dart';
import 'home_page.dart';
import 'transactions_page.dart';
import 'add_tab_page.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  final _controller = NotchBottomBarController(index: 0);
  int _index = 0;

  final _pages = const [
    HomePage(),
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
          BottomBarItem(
            inActiveItem: Icon(PhosphorIconsRegular.house, size: 22.sp),
            activeItem: Icon(PhosphorIconsFill.house, size: 22.sp),
            itemLabel: 'Home',
          ),
          BottomBarItem(
            inActiveItem: Icon(PhosphorIconsRegular.list, size: 22.sp),
            activeItem: Icon(PhosphorIconsFill.list, size: 22.sp),
            itemLabel: 'Transactions',
          ),
          BottomBarItem(
            inActiveItem: Icon(PhosphorIconsRegular.chartBar, size: 22.sp),
            activeItem: Icon(PhosphorIconsFill.chartBar, size: 22.sp),
            itemLabel: 'Analysis',
          ),
          BottomBarItem(
            inActiveItem: Icon(PhosphorIconsRegular.plusCircle, size: 22.sp),
            activeItem: Icon(PhosphorIconsFill.plusCircle, size: 22.sp),
            itemLabel: 'Add',
          ),
        ],
        onTap: (i) => setState(() => _index = i),
      ),

    );
  }
}



