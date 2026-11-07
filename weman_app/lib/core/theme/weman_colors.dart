import 'package:flutter/material.dart';

/// WEMAN Design System Color Tokens
/// Based on WEMAN Design System with custom Volt-Green (#CCFF00) signature profile.
class WemanColors {
  WemanColors._();

  // Core Brand Tokens - Approved Light Theme
  static const Color neonLime = Color(0xFFC6F536); // Primary neon lime
  static const Color voltGreen = Color(0xFFC6F536); // Backward-compatible alias
  static const Color softLime = Color(0xFFE9F9A8); // Soft lime
  static const Color primary = Color(0xFF506600);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFC6F536);
  static const Color onPrimaryContainer = Color(0xFF161E00);

  // Secondary & Tertiary
  static const Color secondary = Color(0xFF74786E); // Secondary text
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFE9F9A8);
  static const Color onSecondaryContainer = Color(0xFF171914);

  // Surface Canvas Tokens (Light)
  static const Color surface = Color(0xFFF7F8F5); // Background #F7F8F5
  static const Color background = Color(0xFFF7F8F5);
  static const Color surfaceContainerLow = Color(0xFFF3F4F0);
  static const Color surfaceContainer = Color(0xFFEBEEE4);
  static const Color surfaceContainerHigh =
      Color(0xFFE5E8DF); // Borders #E5E8DF
  static const Color surfaceContainerHighest = Color(0xFFE1E5D8);
  static const Color cardBg = Color(0xFFFFFFFF); // Cards #FFFFFF
  static const Color surfaceWhite = Color(0xFFFFFFFF); // White surface
  static const Color deepMoss = Color(0xFF171914); // Dark accent / text
  static const Color charcoal = Color(0xFF171914); // Charcoal text

  // Dark & Media Mode Tokens (Reels / Dark Surfaces)
  static const Color darkBackground = Color(0xFF0F1113);
  static const Color darkSurface = Color(0xFF191C1D);
  static const Color darkCard = Color(0xFF222629);
  static const Color darkSurfaceBorder = Color(0xFF2E3132);

  // Text / Typography Tokens
  static const Color onSurface = Color(0xFF171914); // Primary text #171914
  static const Color onSurfaceVariant = Color(0xFF44483D);
  static const Color textMuted = Color(0xFF74786E); // Secondary text #74786E
  static const Color inverseSurface = Color(0xFF171914);
  static const Color inverseOnSurface = Color(0xFFF7F8F5);
  static const Color inversePrimary = Color(0xFFC6F536);

  // Outlines & Borders
  static const Color outline = Color(0xFF74786E);
  static const Color outlineVariant = Color(0xFFE5E8DF); // Borders #E5E8DF
  static const Color border = Color(0xFFE5E8DF);
  static const Color divider = Color(0xFFE5E8DF);

  // Feedback Tokens
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF410002);
  static const Color success = Color(0xFF2E7D32);
}
