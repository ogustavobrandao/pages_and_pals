import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pages_and_pals/core/design_system/app_theme.dart';
import 'package:pages_and_pals/core/design_system/theme_controller.dart';
import 'package:pages_and_pals/app/auth_gate.dart';

class App extends StatelessWidget {
  final ThemeController themeController;

  const App({
    super.key,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: themeController,
      child: const _AppView(),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return MaterialApp(
      title: 'Pages&Pals',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeController.themeMode,
      home: const AuthGate(),
    );
  }
}