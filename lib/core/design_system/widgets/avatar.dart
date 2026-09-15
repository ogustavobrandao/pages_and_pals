import 'dart:io';

import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.initial,
    this.photoUrl,
    this.localFile,
    this.size = 92,
  });

  final String initial;
  final String? photoUrl;
  final File? localFile;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    ImageProvider? image;

    if (localFile != null) {
      image = FileImage(localFile!);
    } else if (photoUrl != null && photoUrl!.isNotEmpty) {
      image = photoUrl!.startsWith('http')
          ? NetworkImage(photoUrl!)
          : FileImage(File(photoUrl!));
    }

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.primaryContainer,
        border: Border.all(
          color: colors.surface,
          width: 3,
        ),
        image: image != null
            ? DecorationImage(
                image: image,
                fit: BoxFit.cover,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: image == null
          ? Text(
              initial,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: size * 0.37,
                color: colors.onPrimaryContainer,
              ),
            )
          : null,
    );
  }
}