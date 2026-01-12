import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';
import '../../core/utils/currency.dart';
import '../../domain/entities/autosave_plan.dart';

class AutosaveStatusCard extends StatelessWidget {
  const AutosaveStatusCard({
    super.key,
    required this.enabled,
    required this.plans,
  });

  final bool enabled;
  final List<AutosavePlan> plans;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monthlyTotal = plans
        .where((plan) => plan.date.month == DateTime.now().month)
        .fold<double>(0, (sum, plan) => sum + plan.amount);

    final headerColor =
        enabled ? theme.colorScheme.primary : AppColors.surfaceAlt;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surfaceAlt),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A1E3A8A),
            blurRadius: 24,
            offset: Offset(0, 16),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: headerColor.withAlpha(enabled ? 36 : 80),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.savings_rounded,
                      color: enabled
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      enabled ? 'Autosave Aktif' : 'Autosave Nonaktif',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: enabled
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Switch.adaptive(
                value: enabled,
                onChanged: null, // purely informasi
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            enabled
                ? 'Total target bulan ini'
                : 'Aktifkan mode Safe Days untuk rekomendasi tanggal menabung.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                enabled
                    ? CurrencyUtils.format(monthlyTotal)
                    : CurrencyUtils.format(0),
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: enabled
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (enabled) ...[
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '${plans.length} jadwal aman',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          if (enabled && plans.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jadwal terdekat',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ...plans.take(3).map(
                      (plan) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceAlt,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 18,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${plan.date.day}/${plan.date.month}/${plan.date.year}',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Rekomendasi hari aman',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              CurrencyUtils.format(plan.amount),
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            )
          else
            Text(
              'SmartSave akan membantumu memilih hari dengan cashflow paling aman.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}
