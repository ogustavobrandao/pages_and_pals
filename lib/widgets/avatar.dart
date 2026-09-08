import 'dart:io';

import 'package:flutter/material.dart';

import '../app_theme.dart';

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
    ImageProvider? image;
    if (localFile != null) {
      image = FileImage(localFile!);
    } else if (photoUrl != null && photoUrl!.isNotEmpty) {
      image = photoUrl!.startsWith('http') ? NetworkImage(photoUrl!) : FileImage(File(photoUrl!));
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFE3CDB3),
        border: Border.all(color: AppColors.background, width: 3),
        image: image != null ? DecorationImage(image: image, fit: BoxFit.cover) : null,
        boxShadow: const [
          BoxShadow(color: Color(0x2E5A3C19), blurRadius: 20, offset: Offset(0, 8)),
        ],
      ),
      alignment: Alignment.center,
      child: image == null
          ? Text(
              initial,
              style: appSerif(fontSize: size * 0.37, color: const Color(0xFF7A4718)),
            )
          : null,
    );
  }
}
