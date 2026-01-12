import 'package:flutter/material.dart';


/// App icon logo widget WITHOUT green/teal elements
/// Only blue gradient, clean minimalist design
/// Use this for generating app icon PNG
class AppIconLogoNoGreen extends StatelessWidget {
  const AppIconLogoNoGreen({
    super.key,
    this.size = 1024,
  });

  final double size;

  @override
  Widget build(BuildContext context) => Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        // Only blue gradient (NO green/teal)
        gradient: LinearGradient(
          colors: [
            Color(0xFF1E3A8A), // Dark blue
            Color(0xFF2563EB), // Primary blue
            Color(0xFF60A5FA), // Light blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: CustomPaint(
        size: Size(size, size),
        painter: _MinimalistIconPainterNoGreen(),
      ),
    );
}

/// Minimalist icon painter WITHOUT green/teal
/// Simple ascending chart line with single dot
/// NO orbital band, NO green colors, NO complex elements
class _MinimalistIconPainterNoGreen extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Clean white chart line
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = Colors.white;

    // Draw smooth ascending chart line (NO orbital band, NO green)
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

    // Single accent dot at peak (white, NO orange/green)
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














