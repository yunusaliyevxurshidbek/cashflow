import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const background = Color(0xFF0F0F23);
  static const surface = Color(0xFF1A1A2E);
  static const surfaceVariant = Color(0xFF16213E);
  static const primary = Color(0xFF00D4FF);
  static const primaryVariant = Color(0xFF0099CC);
  static const secondary = Color(0xFF9D4EDD);
  static const secondaryText = Color(0xFFB8C5D6);
  static const heading = Color(0xFFFFFFFF);
  static const mutedText = Color(0xFF94A3B8);
  static const border = Color(0xFF2A2A3E);

  static const income = Color(0xFF00FF88);
  static const incomeLight = Color(0xFF00CC6A);
  static const expense = Color(0xFFFF6B6B);
  static const expenseLight = Color(0xFFCC5555);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient incomeGradient = LinearGradient(
    colors: [income, incomeLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient expenseGradient = LinearGradient(
    colors: [expense, expenseLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Color surfaceCard(BuildContext context) => Theme.of(context).colorScheme.surface;
  static Color onSurfaceCard(BuildContext context) => Theme.of(context).colorScheme.onSurface;

  static const success = Color(0xFF00FF88);
  static const error = Color(0xFFFF6B6B);
  static const warning = Color(0xFFFFD93D);
  static const info = Color(0xFF00D4FF);
}

