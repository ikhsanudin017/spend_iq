import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/colors.dart';

/// Modern, clean logo widget for Spend-IQ
/// Ultra-minimalist design with gradient and smooth chart line
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 120,
    this.showText = false,
    this.animated = false,
  });

  final double size;
  final bool showText;
  final bool animated;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget logoWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Hanya gradient biru (TANPA hijau/teal/accent)
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryDark, // Dark blue
            AppColors.primary, // Primary blue
            AppColors.primaryLight, // Light blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(100),
            blurRadius: size * 0.3,
            spreadRadius: size * 0.1,
            offset: Offset(0, size * 0.08),
          ),
        ],
      ),
      child: CustomPaint(
        size: Size(size, size),
        painter: _SmartSpendLogoPainter(),
      ),
    );

    if (animated) {
      logoWidget = logoWidget
          .animate()
          .fadeIn(duration: 600.ms, curve: Curves.easeOut)
          .scale(
            begin: const Offset(0.7, 0.7),
            end: const Offset(1, 1),
            duration: 800.ms,
            curve: Curves.easeOutCubic,
          )
          .then()
          .shimmer(
            duration: 1500.ms,
            color: Colors.white.withAlpha(30),
            delay: 400.ms,
          );
    }

    if (showText) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          logoWidget,
          const SizedBox(height: 16),
          Text(
            'Spend-IQ',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'AI',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
              color: Colors.white.withAlpha(200),
            ),
          ),
        ],
      );
    }

    return logoWidget;
  }
}

/// Custom painter for ultra-minimalist Spend-IQ logo
/// Clean, smooth ascending chart line with single accent dot
class _SmartSpendLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Clean, smooth chart line
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.14
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = Colors.white;

    // Draw smooth ascending chart line (bottom-left to top-right)
    final path = Path()
      ..moveTo(size.width * 0.15, size.height * 0.8)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.6,
        size.width * 0.5,
        size.height * 0.45,
      )
      ..quadraticBezierTo(
        size.width * 0.65,
        size.height * 0.3,
        size.width * 0.85,
        size.height * 0.2,
      );

    canvas.drawPath(path, paint);

    // Single accent dot at the peak (ultra-minimalist)
    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.2),
      size.width * 0.07,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

