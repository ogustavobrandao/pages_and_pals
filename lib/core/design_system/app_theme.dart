import 'package:flutter/material.dart';

import 'app_palette.dart';
import 'app_radius.dart';
import 'app_semantic_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light {
    const colorScheme = ColorScheme.light(
      primary: AppPalette.primary,
      onPrimary: Color(0xFFFFF7EC),

      primaryContainer: AppPalette.lightSurfaceSoft,
      onPrimaryContainer: AppPalette.lightHeading,

      surface: AppPalette.lightSurface,
      onSurface: AppPalette.lightHeading,

      error: AppPalette.lightDanger,

      outline: AppPalette.lightBorder,
      outlineVariant: AppPalette.lightBorderSoft,
    );

    const semanticColors = AppSemanticColors(
      textSecondary: AppPalette.lightTextSecondary,
      textMuted: AppPalette.lightTextMuted,
      navigationInactive: AppPalette.lightNavigationInactive,
      rating: AppPalette.lightRating,
      surfaceSoft: AppPalette.lightSurfaceSoft,
      surfaceStrong: AppPalette.lightSurfaceStrong,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      colorScheme: colorScheme,

      scaffoldBackgroundColor: AppPalette.lightBackground,

      textTheme: AppTypography.textTheme.apply(
        bodyColor: AppPalette.lightTextPrimary,
        displayColor: AppPalette.lightHeading,
      ),

      extensions: const [
        semanticColors,
      ],

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPalette.lightSurface,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
          borderSide: const BorderSide(
            color: AppPalette.lightBorder,
            width: 2,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
          borderSide: const BorderSide(
            color: AppPalette.lightBorder,
            width: 2,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
          borderSide: const BorderSide(
            color: AppPalette.primary,
            width: 2,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(54),

          backgroundColor: AppPalette.primary,
          foregroundColor: const Color(0xFFFFF7EC),

          textStyle: AppTypography.textTheme.labelLarge,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppRadius.field,
            ),
          ),
        ),
      ),
    );
  }

  static ThemeData get dark {
    const colorScheme = ColorScheme.dark(
      primary: AppPalette.darkRating,
      onPrimary: AppPalette.darkBackground,

      primaryContainer: AppPalette.darkSurfaceSoft,
      onPrimaryContainer: AppPalette.darkHeading,

      surface: AppPalette.darkSurface,
      onSurface: AppPalette.darkHeading,

      error: AppPalette.darkDanger,

      outline: AppPalette.darkBorder,
      outlineVariant: AppPalette.darkBorderSoft,
    );

    const semanticColors = AppSemanticColors(
      textSecondary: AppPalette.darkTextSecondary,
      textMuted: AppPalette.darkTextMuted,
      navigationInactive: AppPalette.darkNavigationInactive,
      rating: AppPalette.darkRating,
      surfaceSoft: AppPalette.darkSurfaceSoft,
      surfaceStrong: AppPalette.darkSurfaceStrong,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: colorScheme,

      scaffoldBackgroundColor: AppPalette.darkBackground,

      textTheme: AppTypography.textTheme.apply(
        bodyColor: AppPalette.darkTextPrimary,
        displayColor: AppPalette.darkHeading,
      ),

      extensions: const [
        semanticColors,
      ],

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPalette.darkSurface,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
          borderSide: const BorderSide(
            color: AppPalette.darkBorder,
            width: 2,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
          borderSide: const BorderSide(
            color: AppPalette.darkBorder,
            width: 2,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
          borderSide: const BorderSide(
            color: AppPalette.darkRating,
            width: 2,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(54),

          backgroundColor: AppPalette.darkRating,
          foregroundColor: AppPalette.darkBackground,

          textStyle: AppTypography.textTheme.labelLarge,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppRadius.field,
            ),
          ),
        ),
      ),
    );
  }
}