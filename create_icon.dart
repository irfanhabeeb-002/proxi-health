import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Create the icon
  await createAppIcon();
  print('App icon created successfully!');
}

Future<void> createAppIcon() async {
  const size = 512.0;
  
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  
  // Background gradient
  final backgroundPaint = Paint()
    ..shader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF1A2332),
        Color(0xFF1E3A8A),
        Color(0xFF06B6D4),
      ],
    ).createShader(const Rect.fromLTWH(0, 0, size, size));
  
  // Draw background with rounded corners
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(0, 0, size, size),
      const Radius.circular(size * 0.2),
    ),
    backgroundPaint,
  );
  
  final paint = Paint()..style = PaintingStyle.fill;
  
  // Heart shape - left circle
  paint.color = const Color(0xFF1E3A8A);
  canvas.drawCircle(
    const Offset(size * 0.35, size * 0.4),
    size * 0.15,
    paint,
  );
  
  // Heart shape - right circle
  paint.color = const Color(0xFF06B6D4);
  canvas.drawCircle(
    const Offset(size * 0.65, size * 0.4),
    size * 0.15,
    paint,
  );
  
  // Heart shape - bottom triangle
  paint.color = const Color(0xFF06B6D4);
  final path = Path();
  path.moveTo(size * 0.25, size * 0.5);
  path.lineTo(size * 0.75, size * 0.5);
  path.lineTo(size * 0.5, size * 0.8);
  path.close();
  canvas.drawPath(path, paint);
  
  // Plus sign
  paint.color = Colors.white;
  paint.strokeWidth = size * 0.08;
  paint.strokeCap = StrokeCap.round;
  paint.style = PaintingStyle.stroke;
  
  // Horizontal line
  canvas.drawLine(
    const Offset(size * 0.35, size * 0.5),
    const Offset(size * 0.65, size * 0.5),
    paint,
  );
  
  // Vertical line
  canvas.drawLine(
    const Offset(size * 0.5, size * 0.35),
    const Offset(size * 0.5, size * 0.65),
    paint,
  );
  
  final picture = recorder.endRecording();
  final img = await picture.toImage(size.toInt(), size.toInt());
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  final pngBytes = byteData!.buffer.asUint8List();
  
  // Save the icon
  final file = File('assets/icons/app_icon.png');
  await file.writeAsBytes(pngBytes);
}