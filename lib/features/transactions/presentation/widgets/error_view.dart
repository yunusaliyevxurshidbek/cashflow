import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorView extends StatelessWidget {
  final String message;
  const ErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48.sp),
          SizedBox(height: 8.h),
          Text('Something went wrong', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 4.h),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
