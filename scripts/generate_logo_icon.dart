import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

/// Script to generate the Spend-IQ app icon as a PNG using pure canvas drawing.
/// Usage: dart scripts/generate_logo_icon.dart
Future<void> main() async {
  const size = 1024.0;
  final bytes = await _generateLogo(size);

  final file = File('assets/images/logo_spend_iq.png');
  await file.writeAsBytes(bytes);

  stdout
    ..writeln('Logo generated successfully!')
    ..writeln('Location: ${file.absolute.path}')
    ..writeln('Size: ${size.toInt()}x${size.toInt()} px')
    ..writeln()
    ..writeln('Next steps:')
    ..writeln('1. Run: flutter pub run flutter_launcher_icons')
    ..writeln('2. Clean: flutter clean')
    ..writeln('3. Rebuild: flutter build apk --release');
}

Future<Uint8List> _generateLogo(double size) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder, ui.Rect.fromLTWH(0, 0, size, size));

  _paintBackground(canvas, size);
  _paintIcon(canvas, size);

  final picture = recorder.endRecording();
  final image = await picture.toImage(size.toInt(), size.toInt());
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  return byteData!.buffer.asUint8List();
}

void _paintBackground(ui.Canvas canvas, double size) {
  final gradient = ui.Gradient.linear(
    ui.Offset.zero,
    ui.Offset(size, size),
    const [
      ui.Color(0xFF1E3A8A), // Dark blue
      ui.Color(0xFF2563EB), // Primary blue
      ui.Color(0xFF60A5FA), // Light blue
    ],
    const [0.0, 0.5, 1.0],
  );

  final paint = ui.Paint()..shader = gradient;
  canvas.drawCircle(ui.Offset(size / 2, size / 2), size / 2, paint);
}

void _paintIcon(ui.Canvas canvas, double size) {
  final strokePaint = ui.Paint()
    ..style = ui.PaintingStyle.stroke
    ..strokeWidth = size * 0.12
    ..strokeCap = ui.StrokeCap.round
    ..strokeJoin = ui.StrokeJoin.round
    ..color = const ui.Color(0xFFFFFFFF);

  final path = ui.Path()
    ..moveTo(size * 0.15, size * 0.8)
    ..quadraticBezierTo(size * 0.35, size * 0.6, size * 0.5, size * 0.45)
    ..quadraticBezierTo(size * 0.65, size * 0.3, size * 0.85, size * 0.2);

  canvas.drawPath(path, strokePaint);

  final dotPaint = ui.Paint()
    ..style = ui.PaintingStyle.fill
    ..color = const ui.Color(0xFFFFFFFF);

  canvas.drawCircle(
    ui.Offset(size * 0.85, size * 0.2),
    size * 0.07,
    dotPaint,
  );
}
