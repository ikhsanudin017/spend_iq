import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/router/app_router.dart';
import '../../../providers/auth_providers.dart';

/// Onboarding Page - Welcome Tour untuk user baru
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    final authRepo = ref.read(authRepositoryProvider);
    await authRepo.setOnboardingCompleted();

    if (!mounted) return;
    context.go(AppRoute.connectBanks.path);
  }

  void _skip() => context.go(AppRoute.connectBanks.path);

  @override
  Widget build(BuildContext context) => Scaffold(
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
                // Skip Button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: _skip,
                      child: Text(
                        'Lewati',
                        style: TextStyle(
                          color: Colors.white.withAlpha(230),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

              // Page View
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  children: [
                    _buildPage(
                      icon: Icons.auto_graph_rounded,
                      title: 'Prediksi Cashflow AI',
                      description:
                          'Prediksi akurat kapan uang habis dengan AI. Rencanakan pengeluaran lebih baik.',
                    ),
                    _buildPage(
                      icon: Icons.savings_rounded,
                      title: 'Autosave Cerdas',
                      description:
                          'AI menentukan hari aman untuk saving. Nabung otomatis tanpa khawatir uang habis.',
                    ),
                    _buildPage(
                      icon: Icons.notifications_active_rounded,
                      title: 'Smart Alerts',
                      description:
                          'Notifikasi proaktif untuk risiko cashflow. Tetap kontrol keuangan 24/7.',
                    ),
                  ],
                ),
              ),

              // Page Indicator
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white.withAlpha(100),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )
                        .animate(target: _currentPage == index ? 1 : 0)
                        .scaleX(
                          duration: 300.ms,
                          curve: Curves.easeOutCubic,
                        ),
                  ),
                ),
              ),

              // Next/Finish Button
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      if (_currentPage == 2) {
                        _finishOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: 400.ms,
                          curve: Curves.easeOutCubic,
                        );
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      _currentPage == 2 ? 'Mulai Sekarang' : 'Lanjut',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  Widget _buildPage({
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(60),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 60,
              color: AppColors.primary,
            ),
          ).animate().fadeIn(duration: 600.ms).scale(duration: 600.ms),
          const SizedBox(height: 48),

          // Title
          Text(
            title,
            style: theme.textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 300.ms).slideY(
                begin: 0.2,
                duration: 600.ms,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(height: 16),

          // Description
          Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withAlpha(230),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 500.ms).slideY(
                begin: 0.2,
                duration: 600.ms,
                curve: Curves.easeOutCubic,
              ),
        ],
      ),
    );
  }
}









