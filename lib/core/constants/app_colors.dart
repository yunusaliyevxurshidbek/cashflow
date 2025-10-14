import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Semantic colors
  static const income = Color(0xFF2E7D32); // green
  static const expense = Color(0xFFC62828); // red

  // Surface tints (derived from theme where possible)
  static Color surfaceCard(BuildContext context) => Theme.of(context).colorScheme.surface;
  static Color onSurfaceCard(BuildContext context) => Theme.of(context).colorScheme.onSurface;
}

