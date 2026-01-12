import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final icon = await _generateIcon();
  final pngBytes = await icon.toByteData(format: ui.ImageByteFormat.png);

  if (pngBytes != null) {
    final file = File('assets/images/app_launcher_icon.png');
    await file.writeAsBytes(pngBytes.buffer.asUint8List());
    stdout.writeln('Launcher icon generated: ${file.path}');
  }
}

Future<ui.Image> _generateIcon() async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  const size = 1024.0; // High resolution icon
  
  // Background gradient biru (sama seperti splash)
  final gradientPaint = Paint()
    ..shader = const LinearGradient(
      colors: [
        Color(0xFF1E3A8A), // primaryDark
        Color(0xFF2563EB), // primary
        Color(0xFF60A5FA), // primaryLight
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.0, 0.5, 1.0],
    ).createShader(const Rect.fromLTWH(0, 0, size, size));
  
  // Lingkaran putih (sama seperti splash)
  const circleSize = size * 0.65;
  const circleCenter = Offset(size / 2, size / 2);
  
  final circlePaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;
  
  // Shadow untuk lingkaran
  final shadowPaint = Paint()
    ..color = Colors.black.withValues(alpha: 0.2)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
  
  canvas
    ..drawRect(const Rect.fromLTWH(0, 0, size, size), gradientPaint)
    ..drawCircle(circleCenter, circleSize / 2, shadowPaint)
    ..drawCircle(circleCenter, circleSize / 2, circlePaint);
  
  // Logo di dalam lingkaran (simplified version)
  const logoSize = circleSize * 0.5;
  final logoRect = Rect.fromCenter(
    center: circleCenter,
    width: logoSize,
    height: logoSize,
  );
  
  // Gambar logo simplified (chart line)
  final logoPaint = Paint()
    ..color = const Color(0xFF2563EB)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 8
    ..strokeCap = StrokeCap.round;
  
  final path = Path();
  final startX = logoRect.left + logoSize * 0.2;
  final startY = logoRect.bottom - logoSize * 0.2;

  path
    ..moveTo(startX, startY)
    ..lineTo(startX + logoSize * 0.2, startY - logoSize * 0.15)
    ..lineTo(startX + logoSize * 0.4, startY - logoSize * 0.3)
    ..lineTo(startX + logoSize * 0.6, startY - logoSize * 0.5)
    ..lineTo(startX + logoSize * 0.8, startY - logoSize * 0.7);
  
  final dotPaint = Paint()
    ..color = const Color(0xFF2563EB)
    ..style = PaintingStyle.fill;
  
  canvas
    ..drawPath(path, logoPaint)
    ..drawCircle(
      Offset(startX + logoSize * 0.8, startY - logoSize * 0.7),
      6,
      dotPaint,
    );
  
  final picture = recorder.endRecording();
  return picture.toImage(size.toInt(), size.toInt());
}
