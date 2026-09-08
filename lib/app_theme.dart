import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const background = Color(0xFFFBF6F0);
  static const backgroundAlt = Color(0xFFEFE6DC);
  static const surface = Color(0xFFFFFDFB);
  static const surfaceMuted = Color(0xFFF3E7D8);
  static const chip = Color(0xFFF5EADE);
  static const border = Color(0xFFE4D6C6);
  static const borderMuted = Color(0xFFEFE2D3);

  static const accent = Color(0xFFA9662A);
  static const accentHover = Color(0xFF96581F);
  static const accentStrong = Color(0xFFD98A28);
  static const accentOnDark = Color(0xFFFFF7EC);

  static const textStrong = Color(0xFF43290F);
  static const textDark = Color(0xFF3B2410);
  static const textMedium = Color(0xFF6B513B);
  static const textMuted = Color(0xFF8A705A);
  static const textFaint = Color(0xFF9C8571);
  static const placeholder = Color(0xFFB09A86);

  static const danger = Color(0xFFB0472C);
  static const dangerBorder = Color(0xFFE0C6BC);
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      surface: AppColors.background,
    ),
    textTheme: GoogleFonts.dmSansTextTheme(),
  );

  return base.copyWith(
    textTheme: base.textTheme.copyWith(
      headlineMedium: GoogleFonts.lora(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.textStrong,
      ),
      titleLarge: GoogleFonts.lora(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textStrong,
      ),
    ),
  );
}

TextStyle appSerif({
  double fontSize = 24,
  FontWeight fontWeight = FontWeight.w600,
  Color color = AppColors.textStrong,
  double? letterSpacing,
}) {
  return GoogleFonts.lora(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    letterSpacing: letterSpacing,
  );
}
