import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../providers/auth_providers.dart';

/// Forgot Password Page
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.sendPasswordResetEmail(_emailController.text.trim());

      if (!mounted) return;
      setState(() => _emailSent = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim email: $e'),
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
                        // Icon
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(40),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            _emailSent
                                ? Icons.mark_email_read_rounded
                                : Icons.lock_reset_rounded,
                            size: 50,
                            color: AppColors.primary,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .scale(duration: 600.ms),
                        const SizedBox(height: 24),

                        // Title
                        Text(
                          _emailSent ? 'Email Terkirim' : 'Reset Password',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
                        ).animate().fadeIn(delay: 200.ms),
                        const SizedBox(height: 8),
                        Text(
                          _emailSent
                              ? 'Link reset password telah dikirim ke email Anda'
                              : 'Masukkan email untuk reset password',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withAlpha(230),
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(delay: 300.ms),
                        const SizedBox(height: 32),

                        // Card
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
                          child: _emailSent
                              ? Column(
                                  children: [
                                    Text(
                                      'Periksa inbox email Anda dan klik link untuk reset password.',
                                      style: theme.textTheme.bodyLarge,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 24),
                                    FilledButton(
                                      onPressed: () => context.pop(),
                                      style: FilledButton.styleFrom(
                                        padding:
                                            const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: const Text('Kembali ke Login'),
                                    ),
                                  ],
                                )
                              : Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
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
                                      const SizedBox(height: 24),

                                      // Send Button
                                      FilledButton(
                                        onPressed: _isLoading ? null : _sendResetEmail,
                                        style: FilledButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
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
                                            : const Text('Kirim Link Reset'),
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
            ],
          ),
        ),
      ),
    );
  }
}











