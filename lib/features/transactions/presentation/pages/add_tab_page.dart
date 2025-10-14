import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/transaction_form.dart';

/// Add tab embedding the transaction form as a full screen without popping navigation
class AddTabPage extends StatelessWidget {
  const AddTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: const TransactionForm(popOnSubmit: false),
    );
  }
}

