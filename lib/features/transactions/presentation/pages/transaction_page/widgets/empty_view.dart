import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 48.sp),
          SizedBox(height: 8.h),
          Text('No transactions yet', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 4.h),
          Text('Tap + to add your first one', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
