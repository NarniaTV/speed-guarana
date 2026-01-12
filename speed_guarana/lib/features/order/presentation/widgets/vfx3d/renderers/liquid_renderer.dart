import 'dart:math';
import 'package:flutter/material.dart';
import '../models/liquid_wave.dart';

class LiquidRenderer {
  final List<LiquidWave> waves = [
    LiquidWave(amplitude: 2, frequency: 0.03, speed: 1.5),
    LiquidWave(amplitude: 3, frequency: 0.02, speed: -1.2),
  ];

  void update(double dt) {
    for (var wave in waves) {
      wave.update(dt);
    }
  }

  void render(
    Canvas canvas,
    Rect liquidArea,
    Color liquidColor, {
    bool isCreamy = false, // <- Flag para o novo estilo
  }) {
    if (liquidArea.height <= 0) return;

    final path = Path();
    path.moveTo(liquidArea.left, liquidArea.top);

    for (double x = liquidArea.left; x <= liquidArea.right; x++) {
      double y = liquidArea.top;
      for (var wave in waves) {
        y += wave.getValue(x);
      }
      path.lineTo(x, y);
    }

    path.lineTo(liquidArea.right, liquidArea.bottom);
    path.lineTo(liquidArea.left, liquidArea.bottom);
    path.close();

    // Gradiente Cremoso e Opaco
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          _lighten(liquidColor, 0.1),
          liquidColor,
          _darken(liquidColor, 0.1),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(liquidArea);

    canvas.drawPath(path, paint);
  }

  Color _lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  Color _darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
