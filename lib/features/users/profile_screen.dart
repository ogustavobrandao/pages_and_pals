import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pages_and_pals/core/design_system/theme_controller.dart';

import 'app_user.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/user_repository.dart';
import '../../core/design_system/widgets/avatar.dart';
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
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);

        return AlertDialog(
          title: Text(
            'Excluir conta',
            style: theme.textTheme.titleLarge,
          ),
          content: Text(
            'Essa ação não pode ser desfeita. '
            'Todos os seus dados serão excluídos permanentemente.',
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    final password = await _askPassword();

    if (password == null || password.isEmpty || !mounted) {
      return;
    }

    setState(() {
      _deleting = true;
    });

    try {
      await _authService.reauthenticate(password);

      await _userRepository.deleteUser(user.uid);

      await _storageService.deleteProfilePhoto(user.uid);

      await _authService.deleteCurrentUser();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authErrorMessage(e),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _deleting = false;
        });
      }
    }
  }

  Future<String?> _askPassword() async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);

        return AlertDialog(
          title: Text(
            'Confirme sua senha',
            style: theme.textTheme.titleLarge,
          ),
          content: TextField(
            controller: controller,
            obscureText: true,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Senha atual',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(
                  controller.text,
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    return result;
  }

  String _themeLabel(ThemeMode themeMode) {
    return switch (themeMode) {
      ThemeMode.system => 'Sistema',
      ThemeMode.light => 'Claro',
      ThemeMode.dark => 'Escuro',
    };
  }

  void _showThemePicker() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return const _ThemeBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authUser = _authService.currentUser;

    if (authUser == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final themeMode = context.watch<ThemeController>().themeMode;

    return Scaffold(
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
                  // Cabeçalho do perfil
                  Container(
                    color: colors.surfaceContainerLow,
                    padding: const EdgeInsets.fromLTRB(
                      24,
                      30,
                      24,
                      26,
                    ),
                    child: Column(
                      children: [
                        Avatar(
                          initial: user.initial,
                          photoUrl: user.photoUrl,
                        ),

                        const SizedBox(height: 12),

                        Text(
                          user.name.isEmpty
                              ? 'Sem nome'
                              : user.name,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium,
                        ),

                        const SizedBox(height: 4),

                        Text(
                          user.email,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          height: 42,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => EditProfileScreen(
                                    user: user,
                                  ),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colors.primary,
                              side: BorderSide(
                                color: colors.outline,
                                width: 1.2,
                              ),
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                              ),
                            ),
                            child: const Text(
                              'Editar perfil',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      24,
                      26,
                      24,
                      30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Configurações',
                          style: theme.textTheme.titleLarge,
                        ),

                        const SizedBox(height: 12),

                        _ProfileOption(
                          icon: Icons.palette_outlined,
                          title: 'Aparência',
                          value: _themeLabel(themeMode),
                          onTap: _showThemePicker,
                        ),

                        const SizedBox(height: 28),

                        OutlinedButton(
                          onPressed: _signOut,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            foregroundColor: colors.error,
                            side: BorderSide(
                              color: colors.error,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Sair',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        SizedBox(
                          height: 50,
                          child: TextButton(
                            onPressed: _deleting
                                ? null
                                : () => _confirmDelete(user),
                            style: TextButton.styleFrom(
                              foregroundColor: colors.error,
                            ),
                            child: _deleting
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      color: colors.error,
                                    ),
                                  )
                                : const Text(
                                    'Excluir conta',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
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

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.onTap,
    this.value,
  });

  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colors.outlineVariant,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 21,
              color: colors.primary,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            if (value != null) ...[
              Text(
                value!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 6),
            ],

            Icon(
              Icons.chevron_right_rounded,
              size: 21,
              color: colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeBottomSheet extends StatelessWidget {
  const _ThemeBottomSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final selectedTheme =
        context.watch<ThemeController>().themeMode;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          24,
          4,
          24,
          24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aparência',
              style: theme.textTheme.headlineMedium,
            ),

            const SizedBox(height: 6),

            Text(
              'Escolha como o Pages & Pals deve aparecer.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 18),

            _ThemeOption(
              title: 'Sistema',
              subtitle: 'Usar a configuração do aparelho',
              icon: Icons.settings_outlined,
              value: ThemeMode.system,
              selectedValue: selectedTheme,
            ),

            _ThemeOption(
              title: 'Claro',
              subtitle: 'Sempre usar o tema claro',
              icon: Icons.light_mode_outlined,
              value: ThemeMode.light,
              selectedValue: selectedTheme,
            ),

            _ThemeOption(
              title: 'Escuro',
              subtitle: 'Sempre usar o tema escuro',
              icon: Icons.dark_mode_outlined,
              value: ThemeMode.dark,
              selectedValue: selectedTheme,
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.selectedValue,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final ThemeMode value;
  final ThemeMode selectedValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final isSelected = value == selectedValue;

    return InkWell(
      onTap: () async {
        await context
            .read<ThemeController>()
            .setTheme(value);

        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.primaryContainer
                    : colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 21,
                color: isSelected
                    ? colors.primary
                    : colors.onSurfaceVariant,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: isSelected
                  ? colors.primary
                  : colors.outline,
            ),
          ],
        ),
      ),
    );
  }
}