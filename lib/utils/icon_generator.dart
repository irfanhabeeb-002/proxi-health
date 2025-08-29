import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AppIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Background gradient
    final backgroundPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF1A2332),
          const Color(0xFF1E3A8A),
          const Color(0xFF06B6D4),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(size.width * 0.2),
      ),
      backgroundPaint,
    );
    
    // Heart shape - left circle
    paint.color = const Color(0xFF1E3A8A);
    canvas.drawCircle(
      Offset(size.width * 0.35, size.height * 0.4),
      size.width * 0.15,
      paint,
    );
    
    // Heart shape - right circle
    paint.color = const Color(0xFF06B6D4);
    canvas.drawCircle(
      Offset(size.width * 0.65, size.height * 0.4),
      size.width * 0.15,
      paint,
    );
    
    // Heart shape - bottom triangle
    paint.color = const Color(0xFF06B6D4);
    final path = Path();
    path.moveTo(size.width * 0.25, size.height * 0.5);
    path.lineTo(size.width * 0.75, size.height * 0.5);
    path.lineTo(size.width * 0.5, size.height * 0.8);
    path.close();
    canvas.drawPath(path, paint);
    
    // Plus sign
    paint.color = Colors.white;
    paint.strokeWidth = size.width * 0.08;
    paint.strokeCap = StrokeCap.round;
    paint.style = PaintingStyle.stroke;
    
    // Horizontal line
    canvas.drawLine(
      Offset(size.width * 0.35, size.height * 0.5),
      Offset(size.width * 0.65, size.height * 0.5),
      paint,
    );
    
    // Vertical line
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.35),
      Offset(size.width * 0.5, size.height * 0.65),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class AppIconWidget extends StatelessWidget {
  final double size;

  const AppIconWidget({super.key, this.size = 512});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: CustomPaint(
        painter: AppIconPainter(),
      ),
    );
  }
}