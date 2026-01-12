import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';
import '../../domain/entities/financial_health.dart';

class HealthScoreGauge extends StatelessWidget {
  const HealthScoreGauge({
    super.key,
    required this.score,
    required this.label,
  });

  final int score;
  final FinancialHealthLabel label;

  Color _labelColor() {
    switch (label) {
      case FinancialHealthLabel.healthy:
        return AppColors.accent;
      case FinancialHealthLabel.stable:
        return AppColors.primaryLight;
      case FinancialHealthLabel.caution:
        return AppColors.warning;
      case FinancialHealthLabel.risk:
        return AppColors.danger;
    }
  }

  String _labelText() {
    switch (label) {
      case FinancialHealthLabel.healthy:
        return 'Sehat';
      case FinancialHealthLabel.stable:
        return 'Stabil';
      case FinancialHealthLabel.caution:
        return 'Waspada';
      case FinancialHealthLabel.risk:
        return 'Risiko';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _labelColor();

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.background,
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.surfaceAlt,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            height: 110,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(110, 110),
                  painter: _GaugePainter(
                    value: score / 100,
                    color: color,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$score',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '/100',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Financial Health',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _labelText(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Optimalkan arus kas dengan mengikuti rekomendasi insight Spend-IQ.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _ChipBadge(
                      icon: Icons.savings_rounded,
                      color: AppColors.primary,
                      label: 'Target tercapai ${(score / 1.2).round()}%',
                    ),
                    _ChipBadge(
                      icon: Icons.check_circle_rounded,
                      color: AppColors.accent,
                      label: 'Komitmen menabung ${(score / 1.4).round()}%',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipBadge extends StatelessWidget {
  const _ChipBadge({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(28),
        borderRadius: BorderRadius.circular(14),
      ),
      constraints: const BoxConstraints(maxWidth: 200),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({
    required this.value,
    required this.color,
  });

  final double value;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    const startAngle = pi;
    final sweepAngle = pi * value.clamp(0.0, 1.0);

    final backgroundPaint = Paint()
      ..color = color.withAlpha(40)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    final valuePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color,
          AppColors.accent,
        ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final arcRect = rect.deflate(14);
    canvas
      ..drawArc(arcRect, startAngle, pi, false, backgroundPaint)
      ..drawArc(arcRect, startAngle, sweepAngle, false, valuePaint);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.color != color;
}

