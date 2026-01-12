import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/currency.dart';
import '../../../core/utils/date.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/repositories/finance_repository_impl.dart';
import '../../../domain/usecases/get_dashboard_summary.dart';
import '../../../providers/accounts_home_providers.dart';
import '../../../providers/predictive_providers.dart' as pred;
import '../../../providers/profile_providers.dart';
import '../../features/accounts_meta/accounts_meta_list_page.dart';
import '../../features/accounts_meta/edit_account_metadata_page.dart';
import '../../../core/utils/haptic_feedback.dart';
import '../../widgets/account_summary_card.dart';
import '../../widgets/alert_list.dart';
import '../../widgets/app_page_decoration.dart';
import '../../widgets/autosave_status_card.dart';
import '../../widgets/balance_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/forecast_area_chart.dart';
import '../../widgets/health_score_gauge.dart';
import '../../widgets/section_header.dart';
import '../../widgets/skeleton_loader.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(getDashboardSummaryProvider);
    final forecastPoints = ref.watch(pred.forecastProvider);
    final smartAlerts = ref.watch(pred.smartAlertsProvider);
    final profileNameAsync = ref.watch(profileControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: summary.when(
        data: (data) {
          // Check if accounts are empty
          final hasAccounts = data.accounts.isNotEmpty;
          
          final chartPoints =
              forecastPoints.isNotEmpty ? forecastPoints : data.forecast;
          final alerts = smartAlerts.isNotEmpty ? smartAlerts : data.alerts;
          final avgPerAccount = hasAccounts
              ? data.aggregateBalance / data.accounts.length
              : 0;
          final riskDays =
              chartPoints.where((point) => point.risky).toList();

          // If no accounts, show empty state
          if (!hasAccounts) {
            return AppPageContainer(
              topPadding: 12,
              child: RefreshIndicator(
                onRefresh: () async {
                  // Refresh cache di repository terlebih dahulu
                  final repository = ref.read(financeRepositoryProvider);
                  await repository.refreshAccounts();
                  await repository.refreshTransactions();
                  // Invalidate providers untuk memaksa rebuild
                  ref
                    ..invalidate(getDashboardSummaryProvider)
                    ..invalidate(accountViewsProvider)
                    ..invalidate(totalBalanceProvider);
                  // Tunggu sedikit untuk memastikan data ter-refresh
                  await Future<void>.delayed(const Duration(milliseconds: 300));
                },
                child: ListView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: EdgeInsets.zero,
                  children: [
                    SectionCard(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          AppColors.primaryLight,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 28,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Halo, ${profileNameAsync.valueOrNull ?? 'Spend-IQ'}!',
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateUtilsX.formatFull(DateTime.now()),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withAlpha(220),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Semantics(
                                button: true,
                                label: 'Profil',
                                child: InkWell(
                                  onTap: () {
                                    HapticUtils.selectionClick();
                                    context.push(AppRoute.profile.path);
                                  },
                                  borderRadius: BorderRadius.circular(24),
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.white.withAlpha(28),
                                    child: const Icon(
                                      Icons.person_outline,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SectionGap.large(),
                    EmptyState(
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'Belum Ada Akun Banking',
                      subtitle: 'Untuk memulai menggunakan Spend-IQ, Anda perlu menambahkan akun banking terlebih dahulu. Hubungkan akun bank Anda untuk melihat saldo, forecast, dan insight keuangan.',
                      actionLabel: 'Hubungkan Bank',
                      onAction: () {
                        HapticUtils.selectionClick();
                        context.push(AppRoute.connectBanks.path);
                      },
                    ),
                    const SectionGap.large(),
                    const SectionHeader(
                      title: 'Mulai dengan Spend-IQ',
                      subtitle: 'Langkah-langkah untuk memulai menggunakan aplikasi.',
                    ),
                    const SectionGap.medium(),
                    SectionCard(
                      child: Column(
                        children: [
                          _SetupStep(
                            step: 1,
                            icon: Icons.account_balance_rounded,
                            title: 'Hubungkan Bank',
                            description: 'Pilih bank yang ingin Anda hubungkan dengan Spend-IQ.',
                            onTap: () {
                              HapticUtils.selectionClick();
                              context.push(AppRoute.connectBanks.path);
                            },
                          ),
                          const Divider(),
                          _SetupStep(
                            step: 2,
                            icon: Icons.person_add_outlined,
                            title: 'Tambahkan Metadata Akun',
                            description: 'Tambahkan nama, bank, dan nomor rekening untuk memudahkan tracking.',
                            onTap: () {
                              HapticUtils.selectionClick();
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const AccountsMetaListPage(),
                                ),
                              );
                            },
                          ),
                          const Divider(),
                          _SetupStep(
                            step: 3,
                            icon: Icons.notifications_active_outlined,
                            title: 'Aktifkan Notifikasi',
                            description: 'Dapatkan alert dan notifikasi penting tentang keuangan Anda.',
                            onTap: () {
                              HapticUtils.selectionClick();
                              context.push(AppRoute.permissions.path);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SectionGap.large(),
                  ],
                ),
              ),
            );
          }

          // Normal view with accounts
          return AppPageContainer(
            topPadding: 12,
            child: RefreshIndicator(
              onRefresh: () async {
                // Refresh semua data yang terkait
                ref
                  ..invalidate(getDashboardSummaryProvider)
                  ..invalidate(accountViewsProvider)
                  ..invalidate(totalBalanceProvider);
                // Tunggu sedikit untuk memastikan data ter-refresh
                await Future<void>.delayed(const Duration(milliseconds: 500));
              },
          child: ListView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
            padding: EdgeInsets.zero,
            children: [
                  SectionCard(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      AppColors.primaryLight,
                    ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 28,
                    ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                  'Halo, ${profileNameAsync.valueOrNull ?? 'SmartSaver'}!',
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateUtilsX.formatFull(DateTime.now()),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withAlpha(220),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                            Semantics(
                              button: true,
                              label: 'Profil',
                              child: InkWell(
                                onTap: () {
                                  HapticUtils.selectionClick();
                                  context.push(AppRoute.profile.path);
                                },
                          borderRadius: BorderRadius.circular(24),
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.white.withAlpha(28),
                                  child: const Icon(
                                    Icons.person_outline,
                              color: Colors.white,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                        const SizedBox(height: 28),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final spacing =
                            ResponsiveUtils.spacing(context, base: 12);
                        int columns = 1;
                        if (constraints.maxWidth >= 640) {
                          columns = 3;
                        } else if (constraints.maxWidth >= 360) {
                          columns = 2;
                        }
                        final itemWidth = columns == 1
                            ? constraints.maxWidth
                            : (constraints.maxWidth -
                                    spacing * (columns - 1)) /
                                columns;
                        return Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: [
                            SizedBox(
                              width: itemWidth,
                              child: _QuickMetric(
                                icon: Icons.timeline_rounded,
                                label: 'Skor hari ini',
                                value: '${data.health.score}',
                              ),
                            ),
                            SizedBox(
                              width: itemWidth,
                              child: _QuickMetric(
                                icon: Icons.calendar_today_rounded,
                                label: 'Rencana autosave',
                                value: '${data.autoSavePlans.length} jadwal',
                              ),
                            ),
                            SizedBox(
                              width: itemWidth,
                              child: _QuickMetric(
                                icon: Icons.notifications_active_rounded,
                                label: 'Alert aktif',
                                value: '${alerts.length}',
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                        const SizedBox(height: 28),
                        BalanceCard(
                          balance: data.aggregateBalance,
                          accounts: data.accounts,
                        ).animate().fadeIn(duration: 350.ms).moveY(begin: 18),
                      ],
                    ),
                  ),
                  const SectionGap.large(),
                  const SectionHeader(
                    title: 'Ringkasan Hari Ini',
                    subtitle:
                        'Pantau saldo agregat, kesehatan finansial, dan insight AI terbaru.',
                  ),
                  const SectionGap.medium(),
                  const _AggregateAndAccountsSection(),
                  const SectionGap.large(),
                  SectionHeader(
                    title: 'Kesehatan Finansial',
                    action: TextButton(
                      onPressed: () => context.push(AppRoute.insights.path),
                      child: const Text('Lihat Insight'),
                    ),
                    subtitle:
                        'Perhatikan skor dan faktor yang mempengaruhi kesehatan finansial Anda.',
                  ),
                  const SectionGap.medium(),
                  SectionCard(
                child: Column(
                  children: [
                    HealthScoreGauge(
                      score: data.health.score,
                      label: data.health.label,
                        ),
                        const SectionGap.medium(),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            // Use responsive breakpoint instead of fixed 400
                            final screenWidth = MediaQuery.of(context).size.width;
                            final isNarrow = screenWidth < 480; // Better breakpoint for mobile
                            
                            if (isNarrow) {
                              return Column(
                                children: [
                                  _InsightPill(
                                    icon: Icons.account_balance_wallet_outlined,
                                    title: 'Rata-rata saldo per akun',
                                    value: CurrencyUtils.format(avgPerAccount),
                                    description:
                                        'Nilai rata-rata dari ${data.accounts.length} akun terhubung.',
                                  ),
                                  SizedBox(height: ResponsiveUtils.spacing(context, base: 12)),
                                  _InsightPill(
                                    icon: Icons.calendar_today_rounded,
                                    title: 'Hari risiko tinggi',
                                    value: '${riskDays.length} hari',
                                    description: riskDays.isEmpty
                                        ? 'Tidak ada hari dengan risiko pengeluaran tinggi.'
                                        : 'Periksa rencana belanja pada ${riskDays.length} hari yang ditandai.',
                                  ),
                                ],
                              );
                            }
                            return Row(
                              children: [
                                Expanded(
                                  child: _InsightPill(
                                    icon: Icons.account_balance_wallet_outlined,
                                    title: 'Rata-rata saldo per akun',
                                    value: CurrencyUtils.format(avgPerAccount),
                                    description:
                                        'Nilai rata-rata dari ${data.accounts.length} akun terhubung.',
                                  ),
                                ),
                                SizedBox(width: ResponsiveUtils.spacing(context, base: 12)),
                                Expanded(
                                  child: _InsightPill(
                                    icon: Icons.calendar_today_rounded,
                                    title: 'Hari risiko tinggi',
                                    value: '${riskDays.length} hari',
                                    description: riskDays.isEmpty
                                        ? 'Tidak ada hari dengan risiko pengeluaran tinggi.'
                                        : 'Periksa rencana belanja pada ${riskDays.length} hari yang ditandai.',
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SectionGap.large(),
                  const SectionHeader(
                    title: 'Forecast Pengeluaran',
                    subtitle:
                        'AI memprediksi pengeluaran 14 hari ke depan dan menandai hari risiko tinggi.',
                  ),
                  const SectionGap.medium(),
                  SectionCard(
                    child: ForecastAreaChart(points: chartPoints),
                  ),
                  const SectionGap.large(),
                  SectionHeader(
                    title: 'Smart Alerts',
                    action: TextButton(
                      onPressed: () => context.push(AppRoute.alerts.path),
                      child: const Text('Semua Alert'),
                    ),
                    subtitle:
                        'Prioritas AI dari tagihan, risiko saldo, dan peluang menabung.',
                  ),
                  const SectionGap.medium(),
                  SectionCard(
                    child: AlertList(alerts: alerts),
                  ),
                  const SectionGap.large(),
                  SectionHeader(
                    title: 'Status Autosave',
                    action: TextButton(
                      onPressed: () => context.push(AppRoute.autosave.path),
                      child: const Text('Kelola Autosave'),
                    ),
                    subtitle:
                        'Aktifkan safe days dan review performa tabungan otomatis Anda.',
                  ),
                  const SectionGap.medium(),
                  SectionCard(
                    child: AutosaveStatusCard(
                      enabled: data.autoSaveEnabled,
                      plans: data.autoSavePlans,
                    ),
                  ),
                  const SectionGap.large(),
                  const SectionHeader(
                    title: 'Tindakan Cepat',
                    subtitle:
                        'Akses cepat ke akun, metadata, dan preferensi alert.',
                  ),
                  const SectionGap.medium(),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final spacing =
                          ResponsiveUtils.spacing(context, base: 12);
                      int columns = 1;
                      if (constraints.maxWidth >= 720) {
                        columns = 3;
                      } else if (constraints.maxWidth >= 440) {
                        columns = 2;
                      }
                      final itemWidth = columns == 1
                          ? constraints.maxWidth
                          : (constraints.maxWidth -
                                  spacing * (columns - 1)) /
                              columns;
                      return Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        children: [
                          SizedBox(
                            width: itemWidth,
                            child: _ActionShortcut(
                              icon: Icons.account_tree_rounded,
                              label: 'Kelola Metadata',
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const AccountsMetaListPage(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: itemWidth,
                            child: _ActionShortcut(
                              icon: Icons.chat_bubble_outline_rounded,
                              label: 'Tanya Smart AI',
                              onTap: () => context.push(AppRoute.chat.path),
                            ),
                          ),
                          SizedBox(
                            width: itemWidth,
                            child: _ActionShortcut(
                              icon: Icons.calendar_month_rounded,
                              label: 'Forecast Harian',
                              onTap: () => context.push(AppRoute.insights.path),
                            ),
                          ),
                          SizedBox(
                            width: itemWidth,
                            child: _ActionShortcut(
                              icon: Icons.receipt_long_rounded,
                              label: 'Riwayat Transaksi',
                              onTap: () =>
                                  context.push(AppRoute.transactions.path),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SectionGap.large(),
                ],
              ),
            ),
          );
        },
        loading: () => AppPageContainer(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SkeletonCard(),
              const SizedBox(height: 20),
              const SkeletonCard(),
              const SizedBox(height: 20),
              const SkeletonCard(),
            ],
          ),
        ),
        error: (error, stackTrace) => AppPageContainer(
          child: ErrorState(
            message: _getErrorMessage(error),
            onRetry: () => ref.invalidate(getDashboardSummaryProvider),
          ),
        ),
      ),
    );
  }

  String _getErrorMessage(Object error) {
    final errorString = error.toString().toLowerCase();
    if (errorString.contains('network') || errorString.contains('connection')) {
      return 'Tidak ada koneksi internet. Periksa koneksi Anda dan coba lagi.';
    } else if (errorString.contains('timeout')) {
      return 'Permintaan timeout. Silakan coba lagi.';
    } else {
      return 'Gagal memuat data. Silakan coba lagi.';
    }
  }
}

class _QuickMetric extends StatelessWidget {
  const _QuickMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(30),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withAlpha(60)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: Colors.white),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white.withAlpha(210),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AggregateAndAccountsSection extends ConsumerWidget {
  const _AggregateAndAccountsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final total = ref.watch(totalBalanceProvider);
    final viewsAsync = ref.watch(accountViewsProvider);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.12),
                  theme.colorScheme.primary.withValues(alpha: 0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saldo Agregat',
                style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 6),
              Text(
                CurrencyUtils.format(total),
                  style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
          const SectionGap.medium(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                'Akun Terhubung',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AccountsMetaListPage(),
                  ),
                );
              },
              icon: const Icon(Icons.manage_accounts_outlined),
                label: const Text('Kelola Metadata'),
            ),
          ],
        ),
        viewsAsync.when(
          data: (views) {
            final items = views.length > 5 ? views.take(5).toList() : views;
            if (items.isEmpty) {
              return EmptyState(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Belum ada akun',
                subtitle: 'Tambahkan metadata akun untuk memulai tracking keuangan Anda.',
                actionLabel: 'Tambah Metadata',
                onAction: () {
                  HapticUtils.selectionClick();
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const AccountsMetaListPage(),
                    ),
                  );
                },
              );
            }
            return Column(
              children: [
                for (final view in items) ...[
                  AccountSummaryCard(
                    view: view,
                    onEditMeta: () {
                      HapticUtils.selectionClick();
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              EditAccountMetadataPage(accountId: view.accountId),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            );
          },
          loading: () => Column(
            children: [
              for (int i = 0; i < 3; i++) ...[
                const SkeletonListTile(),
                const SizedBox(height: 12),
              ],
            ],
          ),
          error: (error, _) => ErrorState(
            message: 'Gagal memuat akun. Silakan coba lagi.',
            onRetry: () => ref.invalidate(accountViewsProvider),
          ),
        ),
        ],
      ),
    );
  }
}

class _InsightPill extends StatelessWidget {
  const _InsightPill({
    required this.icon,
    required this.title,
    required this.value,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String value;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: theme.textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _SetupStep extends StatelessWidget {
  const _SetupStep({
    required this.step,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final int step;
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '$step',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        icon,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionShortcut extends StatelessWidget {
  const _ActionShortcut({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: () {
          HapticUtils.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.colorScheme.outline.withAlpha(40)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

