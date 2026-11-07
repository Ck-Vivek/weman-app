import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'weman_colors.dart';

/// WEMAN Design System Typography Tokens
/// Uses Space Grotesk for Headings and Brand Labels, DM Sans for Body and UI.
class WemanTypography {
  WemanTypography._();

  // Display Styles (Space Grotesk)
  static TextStyle displayLarge = GoogleFonts.spaceGrotesk(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: WemanColors.onSurface,
    height: 1.2,
  );

  static TextStyle displayMedium = GoogleFonts.spaceGrotesk(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: WemanColors.onSurface,
    height: 1.25,
  );

  static TextStyle displaySmall = GoogleFonts.spaceGrotesk(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: WemanColors.onSurface,
    height: 1.3,
  );

  // Headline Styles (Space Grotesk)
  static TextStyle headlineLarge = GoogleFonts.spaceGrotesk(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: WemanColors.onSurface,
  );

  static TextStyle headlineMedium = GoogleFonts.spaceGrotesk(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: WemanColors.onSurface,
  );

  static TextStyle headlineSmall = GoogleFonts.spaceGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: WemanColors.onSurface,
  );

  // Title & Label Styles (Space Grotesk / DM Sans)
  static TextStyle titleMedium = GoogleFonts.spaceGrotesk(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: WemanColors.onSurface,
  );

  static TextStyle titleSmall = GoogleFonts.spaceGrotesk(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: WemanColors.onSurface,
  );

  static TextStyle labelLarge = GoogleFonts.spaceGrotesk(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: WemanColors.onSurface,
  );

  static TextStyle labelMedium = GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.25,
    color: WemanColors.onSurfaceVariant,
  );

  static TextStyle labelSmall = GoogleFonts.dmSans(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.25,
    color: WemanColors.textMuted,
  );

  // Body Styles (DM Sans)
  static TextStyle bodyLarge = GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: WemanColors.onSurface,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: WemanColors.onSurfaceVariant,
    height: 1.45,
  );

  static TextStyle bodySmall = GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: WemanColors.textMuted,
    height: 1.4,
  );

  // Monospace or Stat Styles
  static TextStyle statCounter = GoogleFonts.spaceGrotesk(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: WemanColors.onSurface,
  );
}
