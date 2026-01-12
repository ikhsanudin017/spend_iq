import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';
import '../../core/utils/date.dart';
import '../../domain/entities/alert_item.dart';

class AlertList extends StatelessWidget {
  const AlertList({super.key, required this.alerts});

  final List<AlertItem> alerts;

  IconData _icon(AlertType type) {
    switch (type) {
      case AlertType.bill:
        return Icons.receipt_long_rounded;
      case AlertType.risk:
        return Icons.warning_rounded;
      case AlertType.save:
        return Icons.savings_rounded;
    }
  }

  Color _tone(AlertType type) {
    switch (type) {
      case AlertType.bill:
        return AppColors.primaryLight;
      case AlertType.risk:
        return AppColors.danger;
      case AlertType.save:
        return AppColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (alerts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.surfaceAlt),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Smart Alerts',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Belum ada notifikasi penting. Spend-IQ akan memberi tahu saat ada tagihan atau risiko cashflow.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surfaceAlt),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Smart Alerts',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.filter_list_rounded, size: 18),
                label: const Text('Kelola'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...alerts.take(3).map((alert) {
            final tone = _tone(alert.type);
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: tone.withAlpha(18),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: tone.withAlpha(38),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      _icon(alert.type),
                      color: tone,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: tone.withAlpha(26),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  alert.type.name.toUpperCase(),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: tone,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.4,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                DateUtilsX.formatFull(alert.date),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          alert.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          alert.detail,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

