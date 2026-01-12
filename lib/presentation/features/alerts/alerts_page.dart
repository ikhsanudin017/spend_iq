import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/date.dart';
import '../../../domain/entities/alert_item.dart';
import '../../../domain/usecases/get_alerts.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/skeleton_loader.dart';

class AlertsPage extends ConsumerWidget {
  const AlertsPage({super.key});

  static const _filters = [
    null,
    AlertType.risk,
    AlertType.bill,
    AlertType.save,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return DefaultTabController(
      length: _filters.length,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(          title: const Text('Smart Alerts'),
          actions: [
            IconButton(              tooltip: 'Profil',
              icon: const Icon(Icons.person_outline),
              onPressed: () => context.push(AppRoute.profile.path),
            ),
          ],
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(64),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.surfaceAlt),
                ),
                child: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicator: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(36),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: theme.colorScheme.primary,
                  unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                  labelStyle: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overlayColor: WidgetStateProperty.all(
                    theme.colorScheme.primary.withAlpha(24),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  tabs: [
                    const Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Semua'),
                      ),
                    ),
                    const Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Risiko'),
                      ),
                    ),
                    const Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Tagihan'),
                      ),
                    ),
                    const Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Menabung'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TabBarView(
            physics: const BouncingScrollPhysics(),
            children:
                _filters.map((filter) => _AlertList(filter: filter)).toList(),
          ),
        ),
      ),
    );
  }
}

class _AlertList extends ConsumerWidget {
  const _AlertList({required this.filter});

  final AlertType? filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(getAlertsProvider(filter));

    return alerts.when(
      data: (items) {
        if (items.isEmpty) {
          return const EmptyState(
            icon: Icons.notifications_off_rounded,
            title: 'Tidak ada alert',
            subtitle: 'Tidak ada alert pada kategori ini. Semua baik-baik saja!',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.only(top: 20, bottom: 32),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final alert = items[index];
            return _AlertCard(alert: alert);
          },
        );
      },
      loading: () => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (int i = 0; i < 5; i++) ...[
            const SkeletonListTile(),
            const SizedBox(height: 8),
          ],
        ],
      ),
      error: (error, stackTrace) => ErrorState(
        message: 'Tidak dapat memuat alert. Silakan coba lagi.',
        onRetry: () => ref.invalidate(getAlertsProvider(filter)),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert});

  final AlertItem alert;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visual = _AlertVisual.fromType(alert.type);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surfaceAlt),
        boxShadow: const [
          BoxShadow(
            color: Color(0x151E3A8A),
            blurRadius: 22,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: visual.background,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(visual.icon, color: visual.iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateUtilsX.formatFull(alert.date),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  alert.detail,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.chevron_right_rounded,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _AlertVisual {
  const _AlertVisual({
    required this.icon,
    required this.background,
    required this.iconColor,
  });

  factory _AlertVisual.fromType(AlertType type) {
    switch (type) {
      case AlertType.bill:
        return _AlertVisual(
          icon: Icons.receipt_long_rounded,
          background: AppColors.warning.withAlpha(40),
          iconColor: AppColors.warning,
        );
      case AlertType.risk:
        return _AlertVisual(
          icon: Icons.warning_amber_rounded,
          background: AppColors.danger.withAlpha(36),
          iconColor: AppColors.danger,
        );
      case AlertType.save:
        return _AlertVisual(
          icon: Icons.savings_rounded,
          background: AppColors.success.withAlpha(40),
          iconColor: AppColors.success,
        );
    }
  }

  final IconData icon;
  final Color background;
  final Color iconColor;
}




