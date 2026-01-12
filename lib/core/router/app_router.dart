// ignore_for_file: prefer_expression_function_bodies
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/features/alerts/alerts_page.dart';
import '../../presentation/features/auth/forgot_password_page.dart';
import '../../presentation/features/auth/login_page.dart';
import '../../presentation/features/auth/register_page.dart';
import '../../presentation/features/autosave/autosave_page.dart';
import '../../presentation/features/chat/chat_page.dart';
import '../../presentation/features/home/home_page.dart';
import '../../presentation/features/insights/insights_page.dart';
import '../../presentation/features/onboarding/connect_banks_page.dart';
import '../../presentation/features/onboarding/onboarding_page.dart';
import '../../presentation/features/onboarding/permissions_page.dart';
import '../../presentation/features/onboarding/splash_page.dart';
import '../../presentation/features/goals/goals_page.dart';
import '../../presentation/features/transactions/transactions_page.dart';
import '../../presentation/features/settings/settings_page.dart';
import '../../presentation/features/help/help_page.dart';
import '../../presentation/features/privacy/privacy_page.dart';
import '../../presentation/widgets/app_scaffold.dart';

enum AppRoute {
  splash('/'),
  login('/auth/login'),
  register('/auth/register'),
  forgotPassword('/auth/forgot-password'),
  onboarding('/onboarding'),
  connectBanks('/onboarding/connect-banks'),
  permissions('/onboarding/permissions'),
  home('/home'),
  insights('/insights'),
  autosave('/autosave'),
  goals('/goals'),
  alerts('/alerts'),
  chat('/chat'),
  profile('/profile'),
  transactions('/transactions'),
  settings('/settings'),
  help('/help'),
  privacy('/privacy');

  const AppRoute(this.path);

  final String path;
}

final appRouterProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: AppRoute.splash.path,
    routes: [
      // Splash
      GoRoute(
        path: AppRoute.splash.path,
        name: AppRoute.splash.name,
        builder: (_, __) => const SplashPage(),
      ),
      // Authentication
      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoute.register.path,
        name: AppRoute.register.name,
        builder: (_, __) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoute.forgotPassword.path,
        name: AppRoute.forgotPassword.name,
        builder: (_, __) => const ForgotPasswordPage(),
      ),
      // Onboarding
      GoRoute(
        path: AppRoute.onboarding.path,
        name: AppRoute.onboarding.name,
        builder: (_, __) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoute.connectBanks.path,
        name: AppRoute.connectBanks.name,
        builder: (_, __) => const ConnectBanksPage(),
      ),
      GoRoute(
        path: AppRoute.permissions.path,
        name: AppRoute.permissions.name,
        builder: (_, __) => const PermissionsPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.home.path,
                name: AppRoute.home.name,
                builder: (_, __) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.insights.path,
                name: AppRoute.insights.name,
                builder: (_, __) => const InsightsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.autosave.path,
                name: AppRoute.autosave.name,
                builder: (_, __) => const AutosavePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.alerts.path,
                name: AppRoute.alerts.name,
                builder: (_, __) => const AlertsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.chat.path,
                name: AppRoute.chat.name,
                builder: (_, __) => const ChatPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoute.goals.path,
        name: AppRoute.goals.name,
        builder: (_, __) => const GoalsPage(),
      ),
      GoRoute(
        path: AppRoute.profile.path,
        name: AppRoute.profile.name,
        redirect: (_, __) => AppRoute.settings.path,
      ),
      GoRoute(
        path: AppRoute.transactions.path,
        name: AppRoute.transactions.name,
        builder: (_, __) => const TransactionsPage(),
      ),
      GoRoute(
        path: AppRoute.settings.path,
        name: AppRoute.settings.name,
        builder: (_, __) => const SettingsPage(),
      ),
      GoRoute(
        path: AppRoute.help.path,
        name: AppRoute.help.name,
        builder: (_, __) => const HelpPage(),
      ),
      GoRoute(
        path: AppRoute.privacy.path,
        name: AppRoute.privacy.name,
        builder: (_, __) => const PrivacyPage(),
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      body: Center(
        child: Text('Oops: ${state.error}'),
      ),
    ),
  ),
);





