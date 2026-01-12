import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

/// Minimalist app icon widget
/// Clean, simple design for use in app bars, settings, etc.
class AppLogoIcon extends StatelessWidget {
  const AppLogoIcon({
    super.key,
    this.size = 40,
    this.showBackground = true,
  });

  final double size;
  final bool showBackground;

  @override
  Widget build(BuildContext context) {
    if (showBackground) {
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primaryLight,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: CustomPaint(
          size: Size(size * 0.65, size * 0.65),
          painter: _SimpleLogoPainter(),
        ),
      );
    }

    return CustomPaint(
      size: Size(size, size),
      painter: _SimpleLogoPainter(
        color: AppColors.primary,
      ),
    );
  }
}

/// Simple, clean logo painter - minimalist chart design
class _SimpleLogoPainter extends CustomPainter {
  _SimpleLogoPainter({Color? color}) : _color = color ?? Colors.white;

  final Color _color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.16
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = _color;

    // Draw smooth ascending chart line (minimalist)
    final path = Path()
      ..moveTo(size.width * 0.15, size.height * 0.8)
      ..quadraticBezierTo(
        size.width * 0.4,
        size.height * 0.5,
        size.width * 0.85,
        size.height * 0.2,
      );

    canvas.drawPath(path, paint);

    // Single dot at peak (ultra-minimalist)
    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = _color;

    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.2),
      size.width * 0.08,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

