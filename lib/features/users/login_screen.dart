import 'package:flutter/material.dart';

import '../../core/services/auth_service.dart';
import '../../core/design_system/widgets/app_text_field.dart';
import '../../core/design_system/widgets/password_field.dart';
import '../../core/design_system/widgets/primary_button.dart';
import '../users/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _authService = AuthService();

  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    try {
      await _authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        authErrorMessage(e),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showMessage(
        'Informe seu e-mail para redefinir a senha.',
      );

      return;
    }

    try {
      await _authService.sendPasswordResetEmail(email);

      if (!mounted) return;

      _showMessage(
        'Enviamos um link de redefinição para $email.',
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        authErrorMessage(e),
      );
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 24,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 360,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),

                    // Logo
                    Center(
                      child: Container(
                        width: 64,
                        height: 64,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              colors.primaryContainer,
                              colors.primary,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colors.primary.withValues(
                                alpha: 0.22,
                              ),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Text(
                          'P',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: colors.onPrimary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Nome do app
                    Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Pages',
                            ),
                            TextSpan(
                              text: '&',
                              style: TextStyle(
                                color: colors.primary,
                              ),
                            ),
                            const TextSpan(
                              text: 'Pals',
                            ),
                          ],
                        ),
                        style: theme.textTheme.headlineLarge,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Sua estante e sua turma de leitura',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 44),

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

                    const SizedBox(height: 16),

                    PasswordField(
                      label: 'Senha',
                      controller: _passwordController,
                      hintText: '••••••••',
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe sua senha.';
                        }

                        return null;
                      },
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _forgotPassword,
                        child: const Text(
                          'Esqueci minha senha',
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),

                    PrimaryButton(
                      label: 'Entrar',
                      onPressed: _submit,
                      loading: _loading,
                    ),

                    const SizedBox(height: 32),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Não tem conta?',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),

                        const SizedBox(width: 4),

                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const SignupScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Cadastre-se',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}