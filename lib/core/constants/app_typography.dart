import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextTheme textTheme(BuildContext context) {
    final base = Theme.of(context).textTheme;
    return base.copyWith(
      displayLarge: GoogleFonts.inter(fontSize: 48.sp, fontWeight: FontWeight.w700),
      displayMedium: GoogleFonts.inter(fontSize: 40.sp, fontWeight: FontWeight.w700),
      displaySmall: GoogleFonts.inter(fontSize: 34.sp, fontWeight: FontWeight.w700),
      headlineLarge: GoogleFonts.inter(fontSize: 28.sp, fontWeight: FontWeight.w700),
      headlineMedium: GoogleFonts.inter(fontSize: 24.sp, fontWeight: FontWeight.w700),
      headlineSmall: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w700),
      titleLarge: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w400),
      bodyMedium: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w400),
      bodySmall: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w400),
      labelLarge: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w600),
      labelMedium: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w600),
      labelSmall: GoogleFonts.inter(fontSize: 10.sp, fontWeight: FontWeight.w600),
    );
  }
}

