import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'weman_colors.dart';
import 'weman_typography.dart';

/// Complete ThemeData setup for WEMAN
class WemanTheme {
  WemanTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: WemanColors.surface,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: WemanColors.primary,
        onPrimary: WemanColors.onPrimary,
        primaryContainer: WemanColors.voltGreen,
        onPrimaryContainer: WemanColors.onPrimaryContainer,
        secondary: WemanColors.secondary,
        onSecondary: WemanColors.onSecondary,
        secondaryContainer: WemanColors.secondaryContainer,
        onSecondaryContainer: WemanColors.onSecondaryContainer,
        surface: WemanColors.surface,
        onSurface: WemanColors.onSurface,
        onSurfaceVariant: WemanColors.onSurfaceVariant,
        outline: WemanColors.outline,
        outlineVariant: WemanColors.outlineVariant,
        error: WemanColors.error,
        onError: WemanColors.onError,
        errorContainer: WemanColors.errorContainer,
        onErrorContainer: WemanColors.onErrorContainer,
        inverseSurface: WemanColors.inverseSurface,
        onInverseSurface: WemanColors.inverseOnSurface,
        inversePrimary: WemanColors.inversePrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: WemanColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: WemanColors.onSurface),
        titleTextStyle: WemanTypography.headlineLarge,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: WemanColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
          side: const BorderSide(color: WemanColors.outlineVariant, width: 0.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: WemanColors.surfaceContainerLow,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
              const BorderSide(color: WemanColors.outlineVariant, width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: WemanColors.primary, width: 1.5),
        ),
        hintStyle:
            WemanTypography.bodyMedium.copyWith(color: WemanColors.textMuted),
        prefixIconColor: WemanColors.onSurfaceVariant,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: WemanColors.voltGreen,
          foregroundColor: WemanColors.onPrimaryContainer,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: WemanTypography.labelLarge,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: WemanColors.cardBg,
        selectedItemColor: WemanColors.onSurface,
        unselectedItemColor: WemanColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: WemanColors.darkBackground,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: WemanColors.voltGreen,
        onPrimary: WemanColors.onPrimaryContainer,
        primaryContainer: WemanColors.primary,
        onPrimaryContainer: WemanColors.voltGreen,
        secondary: WemanColors.secondaryContainer,
        onSecondary: WemanColors.onSecondaryContainer,
        surface: WemanColors.darkSurface,
        onSurface: Colors.white,
        onSurfaceVariant: Color(0xFFB0B3B8),
        outline: WemanColors.outline,
        outlineVariant: WemanColors.darkSurfaceBorder,
        error: WemanColors.error,
        onError: WemanColors.onError,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: WemanColors.darkBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }
}
