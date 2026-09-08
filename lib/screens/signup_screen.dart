import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import '../app_theme.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';
import '../services/user_repository.dart';
import '../widgets/app_text_field.dart';
import '../widgets/password_field.dart';
import '../widgets/primary_button.dart';

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
        const SnackBar(content: Text('Você precisa aceitar os Termos de uso e a Política de privacidade.')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final user = await _authService.signUp(
        name: name,
        email: email,
        password: _passwordController.text,
      );
      await _userRepository.createUser(AppUser(uid: user.uid, name: name, email: email));
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 12, 28, 28),
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
                        decoration: BoxDecoration(
                          color: AppColors.chip,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.chevron_left, color: AppColors.accent),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Criar conta', style: appSerif(fontSize: 28, letterSpacing: -0.3)),
                const SizedBox(height: 6),
                const Text(
                  'Monte sua estante e acompanhe amigos leitores.',
                  style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                ),
                const SizedBox(height: 26),
                AppTextField(
                  label: 'Nome',
                  controller: _nameController,
                  hintText: 'Como quer ser chamado',
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'Informe seu nome.' : null,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'E-mail',
                  controller: _emailController,
                  hintText: 'voce@email.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Informe seu e-mail.';
                    if (!value.contains('@')) return 'E-mail inválido.';
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
                    if (value == null || value.isEmpty) return 'Informe uma senha.';
                    if (value.length < 8) return 'A senha precisa ter pelo menos 8 caracteres.';
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
                    if (value != _passwordController.text) return 'As senhas não coincidem.';
                    return null;
                  },
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          margin: const EdgeInsets.only(top: 1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color: _acceptedTerms ? AppColors.accentStrong : AppColors.border,
                              width: 1.5,
                            ),
                            color: _acceptedTerms ? AppColors.accent : Colors.transparent,
                          ),
                          alignment: Alignment.center,
                          child: _acceptedTerms
                              ? const Icon(Icons.check, size: 14, color: AppColors.accentOnDark)
                              : null,
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              style: const TextStyle(fontSize: 13.5, height: 1.45, color: AppColors.textMedium),
                              children: [
                                const TextSpan(text: 'Li e aceito os '),
                                TextSpan(
                                  text: 'Termos de uso',
                                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.accent),
                                  recognizer: TapGestureRecognizer()..onTap = () {},
                                ),
                                const TextSpan(text: ' e a '),
                                TextSpan(
                                  text: 'Política de privacidade',
                                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.accent),
                                  recognizer: TapGestureRecognizer()..onTap = () {},
                                ),
                                const TextSpan(text: '.'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                PrimaryButton(label: 'Criar conta', onPressed: _submit, loading: _loading),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Já tem conta?', style: TextStyle(fontSize: 14, color: AppColors.textMuted)),
                    const SizedBox(width: 6),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(foregroundColor: AppColors.accent, padding: EdgeInsets.zero),
                      child: const Text('Entrar', style: TextStyle(fontWeight: FontWeight.w700)),
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
