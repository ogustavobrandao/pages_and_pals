import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:pages_and_pals/app/app.dart';
import 'package:pages_and_pals/core/design_system/theme_controller.dart';
import 'package:pages_and_pals/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeController = ThemeController();
  await themeController.load();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    App(
      themeController: themeController,
    ),
  );
}