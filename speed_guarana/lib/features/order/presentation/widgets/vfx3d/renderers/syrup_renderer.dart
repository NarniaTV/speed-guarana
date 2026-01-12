import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class SyrupRenderer {
  final List<Path> _drizzlePaths = [];
  final Random _random;

  SyrupRenderer({int seed = 0}) : _random = Random(seed);

  void generateDrizzles(Size size, int count) {
    _drizzlePaths.clear();
    for (int i = 0; i < count; i++) {
      _drizzlePaths.add(_createDrizzlePath(size));
    }
  }

  Path _createDrizzlePath(Size size) {
    final path = Path();
    final startX = size.width * (0.1 + _random.nextDouble() * 0.8);
    final startY = size.height * 0.2 + (size.height * 0.1 * _random.nextDouble());
    final dripLength = size.height * (0.3 + _random.nextDouble() * 0.4);
    final controlPointCount = 3 + _random.nextInt(3); // 3 a 5 pontos de controle

    path.moveTo(startX, startY);

    double currentY = startY;
    double currentX = startX;

    for (int i = 0; i < controlPointCount; i++) {
      final nextY = startY + (dripLength / controlPointCount) * (i + 1);
      final xSway = (size.width * 0.05) * (_random.nextDouble() - 0.5);
      final nextX = startX + xSway;
      final cp1X = currentX + (size.width * 0.02 * (_random.nextDouble() - 0.5));
      final cp1Y = currentY + (nextY - currentY) * 0.3;
      final cp2X = nextX - (size.width * 0.02 * (_random.nextDouble() - 0.5));
      final cp2Y = nextY - (nextY - currentY) * 0.3;
      path.cubicTo(cp1X, cp1Y, cp2X, cp2Y, nextX, nextY);
      currentX = nextX;
      currentY = nextY;
    }

    return path;
  }

  void render(Canvas canvas, Size size, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0 + _random.nextDouble() * 5.0 // Varia a espessura da calda
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 1.5);

    for (final path in _drizzlePaths) {
      canvas.drawPath(path, paint);
    }
  }
}
