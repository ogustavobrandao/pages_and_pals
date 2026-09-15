import 'package:flutter/material.dart';

import 'app_semantic_colors.dart';

extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => Theme.of(this).colorScheme;

  AppSemanticColors get semanticColors =>
      Theme.of(this).extension<AppSemanticColors>()!;
}