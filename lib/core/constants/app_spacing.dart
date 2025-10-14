import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSpacing {
  AppSpacing._();

  // Base spacing units
  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get md => 12.w;
  static double get lg => 16.w;
  static double get xl => 24.w;
  static double get xxl => 32.w;
  static double get xxxl => 48.w;

  // Page padding
  static EdgeInsets get pagePadding => EdgeInsets.symmetric(horizontal: lg, vertical: md);

  // Card padding
  static EdgeInsets get cardPadding => EdgeInsets.all(lg);
  static EdgeInsets get cardPaddingSmall => EdgeInsets.all(md);

  // Element spacing
  static SizedBox get verticalXs => SizedBox(height: xs);
  static SizedBox get verticalSm => SizedBox(height: sm);
  static SizedBox get verticalMd => SizedBox(height: md);
  static SizedBox get verticalLg => SizedBox(height: lg);
  static SizedBox get verticalXl => SizedBox(height: xl);
  static SizedBox get verticalXxl => SizedBox(height: xxl);

  static SizedBox get horizontalXs => SizedBox(width: xs);
  static SizedBox get horizontalSm => SizedBox(width: sm);
  static SizedBox get horizontalMd => SizedBox(width: md);
  static SizedBox get horizontalLg => SizedBox(width: lg);
  static SizedBox get horizontalXl => SizedBox(width: xl);
  static SizedBox get horizontalXxl => SizedBox(width: xxl);

  // Border radius
  static double get radiusXs => 4.r;
  static double get radiusSm => 8.r;
  static double get radiusMd => 12.r;
  static double get radiusLg => 16.r;
  static double get radiusXl => 24.r;
  static double get radiusXxl => 32.r;

  // Icon sizes
  static double get iconXs => 12.sp;
  static double get iconSm => 16.sp;
  static double get iconMd => 20.sp;
  static double get iconLg => 24.sp;
  static double get iconXl => 32.sp;
  static double get iconXxl => 48.sp;

  // Elevation
  static double get elevationSm => 2;
  static double get elevationMd => 4;
  static double get elevationLg => 8;
  static double get elevationXl => 16;
}

