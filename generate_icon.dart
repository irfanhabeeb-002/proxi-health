import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

void main() async {
  print('Generating Proxi Health app icon...');
  
  // Create a simple colored square as placeholder
  const size = 512;
  final bytes = Uint8List(size * size * 4); // RGBA
  
  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      final index = (y * size + x) * 4;
      
      // Create gradient background
      final gradientFactor = (x + y) / (size * 2);
      final r = (26 + (30 - 26) * gradientFactor + (6 - 30) * gradientFactor * gradientFactor).round();
      final g = (35 + (58 - 35) * gradientFactor + (182 - 58) * gradientFactor * gradientFactor).round();
      final b = (50 + (138 - 50) * gradientFactor + (212 - 138) * gradientFactor * gradientFactor).round();
      
      bytes[index] = r;     // Red
      bytes[index + 1] = g; // Green
      bytes[index + 2] = b; // Blue
      bytes[index + 3] = 255; // Alpha
    }
  }
  
  // Add simple heart shape
  final centerX = size ~/ 2;
  final centerY = size ~/ 2;
  final radius = size ~/ 6;
  
  // Left circle of heart
  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      final dx = x - (centerX - radius ~/ 2);
      final dy = y - (centerY - radius ~/ 4);
      if (dx * dx + dy * dy <= radius * radius) {
        final index = (y * size + x) * 4;
        bytes[index] = 30;     // Blue
        bytes[index + 1] = 58;
        bytes[index + 2] = 138;
        bytes[index + 3] = 255;
      }
    }
  }
  
  // Right circle of heart
  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      final dx = x - (centerX + radius ~/ 2);
      final dy = y - (centerY - radius ~/ 4);
      if (dx * dx + dy * dy <= radius * radius) {
        final index = (y * size + x) * 4;
        bytes[index] = 6;      // Cyan
        bytes[index + 1] = 182;
        bytes[index + 2] = 212;
        bytes[index + 3] = 255;
      }
    }
  }
  
  // Simple plus sign
  final plusSize = radius;
  final plusThickness = radius ~/ 4;
  
  // Horizontal line
  for (int y = centerY - plusThickness; y < centerY + plusThickness; y++) {
    for (int x = centerX - plusSize; x < centerX + plusSize; x++) {
      if (x >= 0 && x < size && y >= 0 && y < size) {
        final index = (y * size + x) * 4;
        bytes[index] = 255;     // White
        bytes[index + 1] = 255;
        bytes[index + 2] = 255;
        bytes[index + 3] = 255;
      }
    }
  }
  
  // Vertical line
  for (int y = centerY - plusSize; y < centerY + plusSize; y++) {
    for (int x = centerX - plusThickness; x < centerX + plusThickness; x++) {
      if (x >= 0 && x < size && y >= 0 && y < size) {
        final index = (y * size + x) * 4;
        bytes[index] = 255;     // White
        bytes[index + 1] = 255;
        bytes[index + 2] = 255;
        bytes[index + 3] = 255;
      }
    }
  }
  
  // Create PNG header and data (simplified)
  final file = File('assets/icons/app_icon_raw.data');
  await file.writeAsBytes(bytes);
  
  print('Raw icon data generated. You can use an online converter to create PNG.');
  print('Icon size: ${size}x$size pixels');
  print('Colors used: Proxi Health brand colors (#1A2332, #1E3A8A, #06B6D4)');
}