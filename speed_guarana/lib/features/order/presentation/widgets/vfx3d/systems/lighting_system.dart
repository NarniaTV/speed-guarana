import 'dart:math';
import 'package:flutter/material.dart';

class LightingSystem {
  Offset lightPosition = const Offset(200, 100);
  Color lightColor = Colors.white;
  double lightIntensity = 1.0;

  // Calcula a iluminação em um ponto baseado na posição da luz
  double calculateLighting(Offset point, Offset normal) {
    final lightDir = (lightPosition - point).normalize();
    final dot = max(0, lightDir.dx * normal.dx + lightDir.dy * normal.dy);
    return dot * lightIntensity;
  }

  // Cria um gradiente baseado na iluminação
  Gradient createLightGradient({
    required Offset start,
    required Offset end,
    required Color baseColor,
    required double lightFactor,
  }) {
    final light = (lightFactor * 0.5 + 0.5).clamp(0.0, 1.0);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        baseColor.withAlpha((255 * (0.3 + light * 0.4)).round()),
        baseColor.withAlpha((255 * (0.1 + light * 0.3)).round()),
        baseColor.withAlpha((255 * (0.05 + light * 0.2)).round()),
      ],
      stops: const [0.0, 0.5, 1.0],
    );
  }

  // Cria um gradiente radial para o brilho
  Gradient createGlowGradient({
    required Color color,
    required double intensity,
  }) {
    return RadialGradient(
      colors: [
        color.withAlpha((255 * intensity).round()),
        color.withAlpha((255 * intensity * 0.5).round()),
        color.withAlpha(0),
      ],
      stops: const [0.0, 0.5, 1.0],
    );
  }
}

extension OffsetExtension on Offset {
  Offset normalize() {
    final length = distance;
    if (length == 0) return Offset.zero;
    return Offset(dx / length, dy / length);
  }
}
