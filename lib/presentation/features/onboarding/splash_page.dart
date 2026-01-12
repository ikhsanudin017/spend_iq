import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:smartspend_ai/data/repositories/finance_repository_impl.dart';

import '../../../core/constants/colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/responsive.dart';
import '../../../providers/auth_providers.dart';

/// Splash page yang rapi dan responsive
/// Menampilkan logo dan loading indicator
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Tunggu untuk animasi splash
    await Future<void>.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    // Step 1: Cek Firebase Authentication
    bool isAuthenticated = false;
    bool hasCompletedOnboarding = false;
    
    try {
      final authRepo = ref.read(authRepositoryProvider);
      final currentUser = await authRepo.getCurrentUser();

      if (currentUser != null) {
        isAuthenticated = true;
        hasCompletedOnboarding = currentUser.hasCompletedOnboarding;
      }
    } catch (e) {
      // Firebase tidak tersedia, anggap belum login
      debugPrint('Firebase auth not available: $e');
    }

    if (!mounted) return;

    // Step 2: Jika belum login, ke halaman login
    if (!isAuthenticated) {
      context.go(AppRoute.login.path);
      return;
    }

    // Step 3: Jika belum selesai onboarding, ke halaman onboarding
    if (!hasCompletedOnboarding) {
      context.go(AppRoute.onboarding.path);
      return;
    }

    // Step 4: Cek bank connections
    final repo = ref.read(financeRepositoryProvider);
    await repo.seedIfNeeded();
    final banks = await repo.getConnectedBanks();

    if (!mounted) return;

    if (banks.isEmpty) {
      context.go(AppRoute.connectBanks.path);
      return;
    }

    // Step 5: Cek permissions
    final notificationGranted = await Permission.notification.isGranted;

    if (!mounted) return;

    if (!notificationGranted) {
      context.go(AppRoute.permissions.path);
      return;
    }

    // Step 6: Semua selesai, ke home
    context.go(AppRoute.home.path);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUtils.screenWidth(context);
    final screenHeight = ResponsiveUtils.screenHeight(context);
    
    // Responsive logo size
    final logoSize = screenWidth < ResponsiveUtils.mobileSmall
        ? 100.0
        : screenWidth < ResponsiveUtils.mobileMedium
            ? 120.0
            : screenWidth < ResponsiveUtils.mobileLarge
                ? 140.0
                : 160.0;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryDark,
              AppColors.primary,
              AppColors.primaryLight,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo container
                Container(
                  width: logoSize,
                  height: logoSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 40,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: EdgeInsets.all(logoSize * 0.15),
                      child: Image.asset(
                        'assets/images/logo_smarts_iq.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.auto_graph_rounded,
                          size: logoSize * 0.5,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      duration: 800.ms,
                      curve: Curves.easeOutBack,
                    ),
                
                SizedBox(height: screenHeight * 0.04),
                
                // App name
                Text(
                  'Spend-IQ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveUtils.fontSize(context, 36),
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.5,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 600.ms)
                    .slideY(
                      begin: 0.3,
                      duration: 600.ms,
                      curve: Curves.easeOut,
                    ),
                
                SizedBox(height: screenHeight * 0.015),
                
                // Tagline
                Text(
                  'Smart Financial Intelligence',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: ResponsiveUtils.fontSize(context, 15),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 600.ms)
                    .slideY(
                      begin: 0.3,
                      duration: 600.ms,
                      curve: Curves.easeOut,
                    ),
                
                SizedBox(height: screenHeight * 0.06),
                
                // Loading indicator
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withValues(alpha: 0.8),
                    ),
                    strokeWidth: 3,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                  ),
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .fadeIn(delay: 700.ms, duration: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

