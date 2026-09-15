import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const textTheme = TextTheme(
    displaySmall: TextStyle(
      fontFamily: 'Lora',
      fontSize: 28,
      fontWeight: FontWeight.w700,
    ),

    headlineLarge: TextStyle(
      fontFamily: 'Lora',
      fontSize: 26,
      fontWeight: FontWeight.w700,
    ),

    headlineMedium: TextStyle(
      fontFamily: 'Lora',
      fontSize: 22,
      fontWeight: FontWeight.w700,
    ),

    titleLarge: TextStyle(
      fontFamily: 'Lora',
      fontSize: 17,
      fontWeight: FontWeight.w700,
    ),

    titleMedium: TextStyle(
      fontFamily: 'Lora',
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),

    bodyLarge: TextStyle(
      fontFamily: 'DM Sans',
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),

    bodyMedium: TextStyle(
      fontFamily: 'DM Sans',
      fontSize: 13,
      fontWeight: FontWeight.w400,
    ),

    labelLarge: TextStyle(
      fontFamily: 'DM Sans',
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),

    labelMedium: TextStyle(
      fontFamily: 'DM Sans',
      fontSize: 13,
      fontWeight: FontWeight.w700,
    ),

    labelSmall: TextStyle(
      fontFamily: 'DM Sans',
      fontSize: 11,
      fontWeight: FontWeight.w400,
    ),
  );

  static const metadata = TextStyle(
    fontFamily: 'IBM Plex Mono',
    fontSize: 12,
  );

  static const metadataSmall = TextStyle(
    fontFamily: 'IBM Plex Mono',
    fontSize: 11,
  );
}