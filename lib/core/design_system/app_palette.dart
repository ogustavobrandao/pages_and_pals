import 'package:flutter/material.dart';

abstract final class AppPalette {
  // Brand
  static const primary = Color(0xFFA9662A);

  // Light
  static const lightBackground = Color(0xFFFBF6F0);
  static const lightSurface = Color(0xFFFFFDFB);
  static const lightSurfaceSoft = Color(0xFFF5EADE);
  static const lightSurfaceStrong = Color(0xFFF3E7D8);

  static const lightHeading = Color(0xFF43290F);
  static const lightTextPrimary = Color(0xFF6B513B);
  static const lightTextSecondary = Color(0xFF8A705A);
  static const lightTextMuted = Color(0xFF9C8571);

  static const lightBorder = Color(0xFFE4D6C6);
  static const lightBorderSoft = Color(0xFFEFE2D3);

  static const lightNavigationInactive = Color(0xFFB4A08B);
  static const lightRating = Color(0xFFD98A28);

  // Dark
  static const darkBackground = Color(0xFF1A130E);
  static const darkSurface = Color(0xFF241B15);
  static const darkSurfaceSoft = Color(0xFF2E221A);
  static const darkSurfaceStrong = Color(0xFF37291F);

  static const darkHeading = Color(0xFFFFF7EC);
  static const darkTextPrimary = Color(0xFFEAD8C6);
  static const darkTextSecondary = Color(0xFFD9C2AD);
  static const darkTextMuted = Color(0xFFB89D85);

  static const darkBorder = Color(0xFF584333);
  static const darkBorderSoft = Color(0xFF3D2E24);

  static const darkNavigationInactive = Color(0xFF947B67);
  static const darkRating = Color(0xFFE9A542);

  // Semantic
  static const lightDanger = Color(0xFFB0472C);
  static const darkDanger = Color(0xFFE5735C);

  // Scanner
  static const scannerBackground = Color(0xFF241608);
  static const scannerAccent = Color(0xFFE9A542);
  static const scannerText = Color(0xFFFBF0E1);
}