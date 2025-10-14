import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Palette (Dark)
  static const background = Color(0xFF121212); // or 0xFF0E0E0E
  static const surface = Color(0xFF1A1A1A);
  static const primary = Color(0xFF00C3A1); // mint/teal accent
  static const secondaryText = Color(0xFFB3B3B3);
  static const heading = Color(0xFFFFFFFF);

  // Semantic colors
  static const income = Color(0xFF4CAF50);
  static const expense = Color(0xFFFF5E5E);

  // Surface tints (derived from theme where possible)
  static Color surfaceCard(BuildContext context) => Theme.of(context).colorScheme.surface;
  static Color onSurfaceCard(BuildContext context) => Theme.of(context).colorScheme.onSurface;
}

