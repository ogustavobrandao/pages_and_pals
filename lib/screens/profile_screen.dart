import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../services/user_repository.dart';
import '../widgets/avatar.dart';
import '../widgets/primary_button.dart';
import 'book_search_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  final _userRepository = UserRepository();
  final _storageService = StorageService();

  bool _deleting = false;

  Future<void> _signOut() => _authService.signOut();

  Future<void> _confirmDelete(AppUser user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Excluir conta', style: appSerif(fontSize: 20)),
        content: const Text(
          'Essa ação não pode ser desfeita. Todos os seus dados serão excluídos permanentemente.',
          style: TextStyle(color: AppColors.textMedium),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final password = await _askPassword();
    if (password == null || password.isEmpty || !mounted) return;

    setState(() => _deleting = true);
    try {
      await _authService.reauthenticate(password);
      await _userRepository.deleteUser(user.uid);
      await _storageService.deleteProfilePhoto(user.uid);
      await _authService.deleteCurrentUser();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  Future<String?> _askPassword() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Confirme sua senha', style: appSerif(fontSize: 18)),
        content: TextField(
          controller: controller,
          obscureText: true,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Senha atual'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final authUser = _authService.currentUser;
    if (authUser == null) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: StreamBuilder<AppUser?>(
        stream: _userRepository.watchUser(authUser.uid),
        builder: (context, snapshot) {
          final user = snapshot.data ??
              AppUser(
                uid: authUser.uid,
                name: authUser.displayName ?? '',
                email: authUser.email ?? '',
                photoUrl: authUser.photoURL,
              );

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: AppColors.surfaceMuted,
                    padding: const EdgeInsets.fromLTRB(24, 30, 24, 26),
                    child: Column(
                      children: [
                        Avatar(initial: user.initial, photoUrl: user.photoUrl),
                        const SizedBox(height: 12),
                        Text(
                          user.name.isEmpty ? 'Sem nome' : user.name,
                          style: appSerif(fontSize: 24, color: AppColors.textDark),
                        ),
                        const SizedBox(height: 3),
                        Text(user.email, style: const TextStyle(fontSize: 13.5, color: Color(0xFF7A6048))),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 42,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => EditProfileScreen(user: user)),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: AppColors.background,
                              foregroundColor: AppColors.accent,
                              side: const BorderSide(color: Color(0xFFC99C63), width: 1.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                              padding: const EdgeInsets.symmetric(horizontal: 22),
                            ),
                            child: const Text('Editar perfil', style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SecondaryButton(
                          label: 'Buscar livros',
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const BookSearchScreen()),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SecondaryButton(label: 'Sair', onPressed: _signOut, color: AppColors.danger, borderColor: AppColors.dangerBorder),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 50,
                          child: TextButton(
                            onPressed: _deleting ? null : () => _confirmDelete(user),
                            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
                            child: _deleting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2.4, color: AppColors.danger),
                                  )
                                : const Text('Excluir conta', style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
