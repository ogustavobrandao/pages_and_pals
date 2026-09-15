import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'app_user.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/user_repository.dart';
import '../../core/design_system/widgets/app_text_field.dart';
import '../../core/design_system/widgets/password_field.dart';
import '../../core/design_system/widgets/primary_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final _authService = AuthService();
  final _userRepository = UserRepository();

  bool _acceptedTerms = false;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Você precisa aceitar os Termos de uso e a Política de privacidade.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();

      final user = await _authService.signUp(
        name: name,
        email: email,
        password: _passwordController.text,
      );

      await _userRepository.createUser(
        AppUser(
          uid: user.uid,
          name: name,
          email: email,
        ),
      );

      if (!mounted) return;

      Navigator.of(context).popUntil(
        (route) => route.isFirst,
      );
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
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            28,
            12,
            28,
            28,
          ),
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
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.chevron_left,
                          color: colors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  'Criar conta',
                  style: theme.textTheme.headlineMedium,
                ),

                const SizedBox(height: 6),

                Text(
                  'Monte sua estante e acompanhe amigos leitores.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 26),

                AppTextField(
                  label: 'Nome',
                  controller: _nameController,
                  hintText: 'Como quer ser chamado',
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe seu nome.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                AppTextField(
                  label: 'E-mail',
                  controller: _emailController,
                  hintText: 'voce@email.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe seu e-mail.';
                    }

                    if (!value.contains('@')) {
                      return 'E-mail inválido.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                PasswordField(
                  label: 'Senha',
                  controller: _passwordController,
                  hintText: 'Mínimo 8 caracteres',
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe uma senha.';
                    }

                    if (value.length < 8) {
                      return 'A senha precisa ter pelo menos 8 caracteres.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                PasswordField(
                  label: 'Confirmar senha',
                  controller: _confirmController,
                  hintText: 'Repita a senha',
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'As senhas não coincidem.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 6),

                InkWell(
                  onTap: () {
                    setState(() {
                      _acceptedTerms = !_acceptedTerms;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          margin: const EdgeInsets.only(top: 1),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color: _acceptedTerms
                                  ? colors.primary
                                  : colors.outline,
                              width: 1.5,
                            ),
                            color: _acceptedTerms
                                ? colors.primary
                                : Colors.transparent,
                          ),
                          child: _acceptedTerms
                              ? Icon(
                                  Icons.check,
                                  size: 14,
                                  color: colors.onPrimary,
                                )
                              : null,
                        ),

                        const SizedBox(width: 11),

                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Li e aceito os ',
                                ),
                                TextSpan(
                                  text: 'Termos de uso',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: colors.primary,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {},
                                ),
                                const TextSpan(
                                  text: ' e a ',
                                ),
                                TextSpan(
                                  text: 'Política de privacidade',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: colors.primary,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {},
                                ),
                                const TextSpan(
                                  text: '.',
                                ),
                              ],
                            ),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                PrimaryButton(
                  label: 'Criar conta',
                  onPressed: _submit,
                  loading: _loading,
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Já tem conta?',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(width: 6),

                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Entrar',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}