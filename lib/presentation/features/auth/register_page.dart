import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/router/app_router.dart';
import '../../../providers/auth_providers.dart';

/// Register Page
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUpWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.registerWithEmailPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        displayName: _nameController.text.trim(),
      );

      if (!mounted) return;
      // Redirect ke onboarding untuk user baru
      context.go(AppRoute.onboarding.path);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registrasi gagal: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signUpWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.signInWithGoogle();

      if (!mounted) return;
      // Redirect ke onboarding untuk user baru
      context.go(AppRoute.onboarding.path);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registrasi gagal: $e'),
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
          child: Column(
            children: [
              // Back Button
              Padding(
                padding: const EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: Colors.white,
                  ),
                ),
              ),
              // Content
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title
                        Text(
                          'Buat Akun Baru',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
                        ).animate().fadeIn(delay: 100.ms),
                        const SizedBox(height: 8),
                        Text(
                          'Mulai kelola keuangan dengan AI',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withAlpha(230),
                          ),
                        ).animate().fadeIn(delay: 200.ms),
                        const SizedBox(height: 32),

                        // Register Card
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
                                // Google Sign Up Button
                                FilledButton.icon(
                                  onPressed: _isLoading ? null : _signUpWithGoogle,
                                  icon: const Icon(Icons.g_mobiledata_rounded, size: 32),
                                  label: const Text('Daftar dengan Google'),
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
                                    Expanded(
                                      child: Divider(color: Colors.grey.shade300),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        'atau',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(color: Colors.grey.shade300),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // Name Field
                                TextFormField(
                                  controller: _nameController,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                    labelText: 'Nama Lengkap',
                                    prefixIcon: const Icon(Icons.person_outline),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Nama tidak boleh kosong';
                                    }
                                    if (value.trim().length < 3) {
                                      return 'Nama minimal 3 karakter';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

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
                                      onPressed: () => setState(
                                        () => _obscurePassword = !_obscurePassword,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password tidak boleh kosong';
                                    }
                                    if (value.length < 6) {
                                      return 'Password minimal 6 karakter';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Confirm Password Field
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: _obscureConfirmPassword,
                                  decoration: InputDecoration(
                                    labelText: 'Konfirmasi Password',
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmPassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                      ),
                                      onPressed: () => setState(
                                        () => _obscureConfirmPassword =
                                            !_obscureConfirmPassword,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Konfirmasi password tidak boleh kosong';
                                    }
                                    if (value != _passwordController.text) {
                                      return 'Password tidak cocok';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),

                                // Register Button
                                FilledButton(
                                  onPressed: _isLoading ? null : _signUpWithEmail,
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
                                      : const Text('Daftar'),
                                ),
                                const SizedBox(height: 16),

                                // Login Link
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Sudah punya akun? ',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    TextButton(
                                      onPressed: () => context.pop(),
                                      child: const Text('Masuk'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(delay: 300.ms).slideY(
                              begin: 0.2,
                              duration: 600.ms,
                              curve: Curves.easeOutCubic,
                            ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}











