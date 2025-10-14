import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextTheme textTheme(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.heading : AppColors.heading;
    final secondaryColor = isDark ? AppColors.secondaryText : AppColors.secondaryText;
    final mutedColor = isDark ? AppColors.mutedText : AppColors.mutedText;

    return TextTheme(
      // Headlines - Bold and prominent
      headlineLarge: GoogleFonts.inter(
        fontSize: 32.sp,
        fontWeight: FontWeight.w800,
        color: primaryColor,
        letterSpacing: -0.5,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: -0.25,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),

      // Titles - Semi-bold for sections
      titleLarge: GoogleFonts.inter(
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: secondaryColor,
      ),

      // Body text - Regular weight
      bodyLarge: GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        height: 1.4,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: mutedColor,
        height: 1.3,
      ),

      // Labels - Medium weight for buttons/labels
      labelLarge: GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: primaryColor,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        color: mutedColor,
        letterSpacing: 0.5,
      ),

      // Display styles for special cases
      displayLarge: GoogleFonts.inter(
        fontSize: 57.sp,
        fontWeight: FontWeight.w400,
        color: primaryColor,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45.sp,
        fontWeight: FontWeight.w400,
        color: primaryColor,
        letterSpacing: 0,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36.sp,
        fontWeight: FontWeight.w400,
        color: primaryColor,
        letterSpacing: 0,
      ),
    );
  }

  // Custom text styles for specific use cases
  static TextStyle amountText(BuildContext context, double amount, {bool isIncome = true}) {
    final color = isIncome ? AppColors.income : AppColors.expense;
    return GoogleFonts.jetBrainsMono(
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
      color: color,
      letterSpacing: 0.5,
    );
  }

  static TextStyle cardTitle(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.heading,
    );
  }

  static TextStyle cardSubtitle(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.mutedText,
    );
  }

  static TextStyle buttonText(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: Colors.black,
      letterSpacing: 0.5,
    );
  }
}

