import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../services/auth_service.dart';
import '../widgets/app_text_field.dart';
import '../widgets/password_field.dart';
import '../widgets/primary_button.dart';
import 'signup_screen.dart';

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
    setState(() => _loading = true);
    try {
      await _authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Informe seu e-mail para redefinir a senha.')));
      return;
    }
    try {
      await _authService.sendPasswordResetEmail(email);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Enviamos um link de redefinição para $email.')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authErrorMessage(e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    Center(
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFE9A542), AppColors.accentStrong],
                          ),
                          boxShadow: const [
                            BoxShadow(color: Color(0x47B47828), blurRadius: 20, offset: Offset(0, 8)),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text('P', style: appSerif(fontSize: 34)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: appSerif(fontSize: 32, letterSpacing: -0.4),
                          children: const [
                            TextSpan(text: 'Pages'),
                            TextSpan(text: '&', style: TextStyle(color: AppColors.accentStrong)),
                            TextSpan(text: 'Pals'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Center(
                      child: Text(
                        'Sua estante e sua turma de leitura',
                        style: TextStyle(fontSize: 14, color: AppColors.textMuted),
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
                        if (value == null || value.trim().isEmpty) return 'Informe seu e-mail.';
                        if (!value.contains('@')) return 'E-mail inválido.';
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
                        if (value == null || value.isEmpty) return 'Informe sua senha.';
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _forgotPassword,
                        style: TextButton.styleFrom(foregroundColor: AppColors.accent),
                        child: const Text('Esqueci minha senha', style: TextStyle(fontWeight: FontWeight.w500)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    PrimaryButton(label: 'Entrar', onPressed: _submit, loading: _loading),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Não tem conta?', style: TextStyle(fontSize: 14, color: AppColors.textMuted)),
                        const SizedBox(width: 6),
                        TextButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const SignupScreen()),
                          ),
                          style: TextButton.styleFrom(foregroundColor: AppColors.accent, padding: EdgeInsets.zero),
                          child: const Text('Cadastre-se', style: TextStyle(fontWeight: FontWeight.w700)),
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
