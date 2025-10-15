import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:income_expense_tracker/core/constants/app_colors.dart';
import 'add_transaction_page/add_page.dart';
import 'analysis_page/analysis_page.dart';
import 'home_page/home_page.dart';
import 'transaction_page/transactions_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static final GlobalKey<_MainPageState> globalKey = GlobalKey<_MainPageState>();

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _controller = NotchBottomBarController(index: 0);
  int _index = 0;

  void switchToHome() {
    setState(() => _index = 0);
    _controller.jumpTo(0);
  }

  final _pages = const [
    HomePage(),
    TransactionsPage(),
    AnalysisPage(),
    AddPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(
          index: _index,
          children: _pages,
        ),
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        showLabel: true,
        textOverflow: TextOverflow.visible,
        showShadow: true,
        shadowElevation: 5,
        removeMargins: false,
        kIconSize: 24.sp,
        kBottomRadius: 18.r,
        notchColor: Theme.of(context).colorScheme.primary,
        color: Theme.of(context).colorScheme.surface,
        elevation: 8,
        blurOpacity: 0.05,
        durationInMilliSeconds: 400,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: SvgPicture.asset(
              "assets/icons/home.svg",
              colorFilter: const ColorFilter.mode(AppColors.mutedText, BlendMode.srcIn),
            ),
            activeItem: SvgPicture.asset(
              "assets/icons/home.svg",
              colorFilter: const ColorFilter.mode(AppColors.heading, BlendMode.srcIn),
            ),
            itemLabel: 'Home',
          ),
          BottomBarItem(
            inActiveItem: SvgPicture.asset(
              "assets/icons/transaction.svg",
              colorFilter: const ColorFilter.mode(AppColors.mutedText, BlendMode.srcIn),
            ),
            activeItem: SvgPicture.asset(
              "assets/icons/transaction.svg",
              colorFilter: const ColorFilter.mode(AppColors.heading, BlendMode.srcIn),
            ),
            itemLabel: 'Transactions',
          ),
          BottomBarItem(
            inActiveItem: SvgPicture.asset(
              "assets/icons/analysis.svg",
              colorFilter: const ColorFilter.mode(AppColors.mutedText, BlendMode.srcIn),
            ),
            activeItem: SvgPicture.asset(
              "assets/icons/analysis.svg",
              colorFilter: const ColorFilter.mode(AppColors.heading, BlendMode.srcIn),
            ),
            itemLabel: 'Analysis',
          ),
          BottomBarItem(
            inActiveItem: SvgPicture.asset(
              "assets/icons/add.svg",
              colorFilter: const ColorFilter.mode(AppColors.mutedText, BlendMode.srcIn),
            ),
            activeItem: SvgPicture.asset(
              "assets/icons/add.svg",
              colorFilter: const ColorFilter.mode(AppColors.heading, BlendMode.srcIn),
            ),
            itemLabel: 'Add',
          ),
        ],
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
