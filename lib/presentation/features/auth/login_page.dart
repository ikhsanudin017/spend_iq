import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/router/app_router.dart';
import '../../../providers/auth_providers.dart';

/// Login Page
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.signInWithGoogle();

      if (!mounted) return;
      // Kembali ke splash untuk cek onboarding status
      context.go(AppRoute.splash.path);
    } catch (e) {
      if (!mounted) return;
      final errorMessage = e.toString().replaceAll('AuthException: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: const TextStyle(fontSize: 14),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.signInWithEmailPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;
      // Kembali ke splash untuk cek onboarding status
      context.go(AppRoute.splash.path);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login gagal: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryDark,
              AppColors.primary,
              AppColors.primaryLight,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(60),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Image.asset(
                          'assets/images/logo_smarts_iq.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .scale(duration: 600.ms),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    'Spend-IQ',
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 8),
                  Text(
                    'Optimalkan Cashflow dengan AI',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withAlpha(230),
                    ),
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 48),

                  // Login Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(40),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Google Sign In Button
                          FilledButton.icon(
                            onPressed: _isLoading ? null : _signInWithGoogle,
                            icon: const Icon(Icons.g_mobiledata_rounded, size: 32),
                            label: const Text('Masuk dengan Google'),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black87,
                              elevation: 2,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Divider
                          Row(
                            children: [
                              Expanded(child: Divider(color: Colors.grey.shade300)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'atau',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              Expanded(child: Divider(color: Colors.grey.shade300)),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              if (!value.contains('@')) {
                                return 'Format email tidak valid';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () =>
                                    setState(() => _obscurePassword = !_obscurePassword),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                context.push(AppRoute.forgotPassword.path);
                              },
                              child: const Text('Lupa Password?'),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Login Button
                          FilledButton(
                            onPressed: _isLoading ? null : _signInWithEmail,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Masuk'),
                          ),
                          const SizedBox(height: 16),

                          // Register Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Belum punya akun? ',
                                style: theme.textTheme.bodyMedium,
                              ),
                              TextButton(
                                onPressed: () {
                                  context.push(AppRoute.register.path);
                                },
                                child: const Text('Daftar'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(
                        begin: 0.2,
                        duration: 600.ms,
                        curve: Curves.easeOutCubic,
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




