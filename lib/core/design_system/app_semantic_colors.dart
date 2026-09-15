import 'package:flutter/material.dart';

class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  final Color textSecondary;
  final Color textMuted;
  final Color navigationInactive;
  final Color rating;
  final Color surfaceSoft;
  final Color surfaceStrong;

  const AppSemanticColors({
    required this.textSecondary,
    required this.textMuted,
    required this.navigationInactive,
    required this.rating,
    required this.surfaceSoft,
    required this.surfaceStrong,
  });

  @override
  AppSemanticColors copyWith({
    Color? textSecondary,
    Color? textMuted,
    Color? navigationInactive,
    Color? rating,
    Color? surfaceSoft,
    Color? surfaceStrong,
  }) {
    return AppSemanticColors(
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      navigationInactive:
          navigationInactive ?? this.navigationInactive,
      rating: rating ?? this.rating,
      surfaceSoft: surfaceSoft ?? this.surfaceSoft,
      surfaceStrong: surfaceStrong ?? this.surfaceStrong,
    );
  }

  @override
  AppSemanticColors lerp(
    covariant AppSemanticColors? other,
    double t,
  ) {
    if (other == null) return this;

    return AppSemanticColors(
      textSecondary: Color.lerp(
        textSecondary,
        other.textSecondary,
        t,
      )!,
      textMuted: Color.lerp(
        textMuted,
        other.textMuted,
        t,
      )!,
      navigationInactive: Color.lerp(
        navigationInactive,
        other.navigationInactive,
        t,
      )!,
      rating: Color.lerp(
        rating,
        other.rating,
        t,
      )!,
      surfaceSoft: Color.lerp(
        surfaceSoft,
        other.surfaceSoft,
        t,
      )!,
      surfaceStrong: Color.lerp(
        surfaceStrong,
        other.surfaceStrong,
        t,
      )!,
    );
  }
}