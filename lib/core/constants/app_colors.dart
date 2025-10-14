import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Modern Dark Palette
  static const background = Color(0xFF0F0F23); // Deep dark blue-black
  static const surface = Color(0xFF1A1A2E); // Dark blue surface
  static const surfaceVariant = Color(0xFF16213E); // Slightly different surface
  static const primary = Color(0xFF00D4FF); // Bright cyan accent
  static const primaryVariant = Color(0xFF0099CC); // Darker cyan
  static const secondary = Color(0xFF9D4EDD); // Purple accent
  static const secondaryText = Color(0xFFB8C5D6); // Soft blue-gray text
  static const heading = Color(0xFFFFFFFF); // Pure white
  static const mutedText = Color(0xFF94A3B8); // Muted text
  static const border = Color(0xFF2A2A3E); // Subtle borders

  // Semantic colors with modern gradients
  static const income = Color(0xFF00FF88); // Bright green
  static const incomeLight = Color(0xFF00CC6A); // Darker green
  static const expense = Color(0xFFFF6B6B); // Soft red
  static const expenseLight = Color(0xFFCC5555); // Darker red

  // Gradients
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

  // Surface tints (derived from theme where possible)
  static Color surfaceCard(BuildContext context) => Theme.of(context).colorScheme.surface;
  static Color onSurfaceCard(BuildContext context) => Theme.of(context).colorScheme.onSurface;

  // Utility colors
  static const success = Color(0xFF00FF88);
  static const error = Color(0xFFFF6B6B);
  static const warning = Color(0xFFFFD93D);
  static const info = Color(0xFF00D4FF);
}

