import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';
import '../../core/utils/date.dart';
import '../../domain/entities/forecast_point.dart';

class ForecastAreaChart extends StatelessWidget {
  const ForecastAreaChart({
    super.key,
    required this.points,
  });

  final List<ForecastPoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final maxValue = points.fold<double>(
      0,
      (previousValue, element) => element.predictedSpend > previousValue
          ? element.predictedSpend
          : previousValue,
    );
    final riskCount = points.where((point) => point.risky).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 240,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: points.length.toDouble() - 1,
              minY: 0,
              maxY: (maxValue * 1.15).clamp(100000, double.infinity),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 3,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index < 0 || index >= points.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          DateUtilsX.formatShort(points[index].date),
                          style: theme.textTheme.labelSmall,
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: (maxValue / 4).clamp(100000, double.infinity),
                    getTitlesWidget: (value, _) => Text(
                      '${(value / 1000).round()}k',
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
                ),
                rightTitles: const AxisTitles(),
                topTitles: const AxisTitles(),
              ),
              gridData: FlGridData(
                horizontalInterval:
                    (maxValue / 4).clamp(100000, double.infinity),
                getDrawingHorizontalLine: (_) => const FlLine(
                  color: AppColors.surfaceAlt,
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipRoundedRadius: 12,
                  tooltipPadding: const EdgeInsets.all(12),
                  tooltipBorder: BorderSide(
                    color: theme.colorScheme.outline.withAlpha(28),
                  ),
                  getTooltipColor: (_) => theme.colorScheme.surface,
                  getTooltipItems: (items) => items
                      .map(
                        (item) => LineTooltipItem(
                          '${DateUtilsX.formatFull(points[item.x.toInt()].date)}\n'
                          '${points[item.x.toInt()].risky ? 'Risiko tinggi - ' : ''}'
                          '${points[item.x.toInt()].predictedSpend.toStringAsFixed(0)}',
                          theme.textTheme.bodyMedium!,
                        ),
                      )
                      .toList(),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    for (var i = 0; i < points.length; i++)
                      FlSpot(i.toDouble(), points[i].predictedSpend),
                  ],
                  isCurved: true,
                  barWidth: 3.5,
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.accent,
                    ],
                  ),
                  dotData: FlDotData(
                    getDotPainter: (spot, __, ___, ____) {
                      final risky = points[spot.x.toInt()].risky;
                      return FlDotCirclePainter(
                        radius: risky ? 5 : 3,
                        color: risky ? AppColors.danger : AppColors.primary,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primary.withAlpha(60),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            const _LegendChip(
              color: AppColors.primary,
              label: 'Prediksi harian',
            ),
            _LegendChip(
              color: AppColors.danger,
              label: '$riskCount hari risiko tinggi',
            ),
            _LegendChip(
              color: theme.colorScheme.primary,
              label: 'Horizon ${points.length} hari',
            ),
          ],
        ),
      ],
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(28),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
