import 'package:flutter/material.dart';

import '../app_theme.dart';
import 'primary_button.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 40, color: AppColors.textFaint),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14.5, color: AppColors.textMedium),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 180,
              child: PrimaryButton(label: 'Tentar de novo', onPressed: onRetry),
            ),
          ],
        ),
      ),
    );
  }
}
