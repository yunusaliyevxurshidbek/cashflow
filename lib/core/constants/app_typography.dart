import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextTheme textTheme(BuildContext context) {
    // Consistent scale per spec: H:20, Sub:16, Body:14, Small:12
    final color = Theme.of(context).colorScheme.onBackground;
    return TextTheme(
      headlineSmall: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w700, color: color),
      titleMedium: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w600, color: color),
      bodyMedium: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w400, color: color),
      bodySmall: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w400, color: color.withOpacity(0.9)),
      labelLarge: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w600, color: color),
      labelMedium: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w600, color: color),
    );
  }
}

