import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../app_theme.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../services/user_repository.dart';
import '../widgets/app_text_field.dart';
import '../widgets/avatar.dart';
import '../widgets/primary_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.user});

  final AppUser user;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.user.name);
  late final _bioController = TextEditingController(text: widget.user.bio);
  late final _emailController = TextEditingController(text: widget.user.email);

  final _authService = AuthService();
  final _userRepository = UserRepository();
  final _storageService = StorageService();
  final _imagePicker = ImagePicker();

  File? _pickedPhoto;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: AppColors.accent),
              title: const Text('Tirar foto'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: AppColors.accent),
              title: const Text('Escolher da galeria'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    final picked = await _imagePicker.pickImage(source: source, imageQuality: 85);
    if (picked == null) return;
    setState(() => _pickedPhoto = File(picked.path));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      String? photoUrl;
      if (_pickedPhoto != null) {
        photoUrl = await _storageService.uploadProfilePhoto(widget.user.uid, _pickedPhoto!);
      }

      final name = _nameController.text.trim();
      final bio = _bioController.text.trim();

      await _userRepository.updateProfile(
        uid: widget.user.uid,
        name: name,
        bio: bio,
        photoUrl: photoUrl,
      );
      await _authService.updateNameAndPhoto(name: name, photoUrl: photoUrl);

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(color: AppColors.chip, borderRadius: BorderRadius.circular(12)),
                        alignment: Alignment.center,
                        child: const Icon(Icons.chevron_left, color: AppColors.accent),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text('Editar perfil', style: appSerif(fontSize: 22)),
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: _pickPhoto,
                        customBorder: const CircleBorder(),
                        child: Stack(
                          children: [
                            Avatar(
                              initial: widget.user.initial,
                              photoUrl: widget.user.photoUrl,
                              localFile: _pickedPhoto,
                              size: 104,
                            ),
                            Positioned(
                              right: -2,
                              bottom: -2,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.background, width: 3),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(Icons.camera_alt_outlined,
                                    size: 17, color: AppColors.accentOnDark),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: _pickPhoto,
                        style: TextButton.styleFrom(foregroundColor: AppColors.accent),
                        child: const Text('Alterar foto', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                AppTextField(
                  label: 'Nome',
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'Informe seu nome.' : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'E-mail',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Bio',
                  controller: _bioController,
                  hintText: 'Conte o que você gosta de ler',
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 32),
                PrimaryButton(label: 'Salvar alterações', onPressed: _save, loading: _saving),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
