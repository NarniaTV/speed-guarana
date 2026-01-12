import 'dart:math';
import 'package:flutter/material.dart';
import '../models/particle.dart';

class ParticleSystem {
  final List<Particle> particles = [];
  final Random random = Random();

  void burst({
    required Offset position,
    required Color color,
    int count = 30,
    double spread = 100,
  }) {
    for (int i = 0; i < count; i++) {
      final angle = (random.nextDouble() * 2 * pi) - pi;
      final speed = 50 + random.nextDouble() * 100;
      particles.add(Particle(
        position: position,
        velocity: Offset(
          cos(angle) * speed,
          sin(angle) * speed - 50,
        ),
        color: color.withAlpha((255 * 0.8).round()),
        size: 3 + random.nextDouble() * 5,
        life: 0.5 + random.nextDouble() * 1.0,
        maxLife: 0.5 + random.nextDouble() * 1.0,
        rotation: random.nextDouble() * 2 * pi,
        rotationSpeed: (random.nextDouble() - 0.5) * 5,
      ));
    }
  }

  void update(double dt) {
    particles.removeWhere((p) => !p.isAlive);
    for (var particle in particles) {
      particle.update(dt);
    }
  }

  void render(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.plus;

    for (var particle in particles) {
      final alpha = particle.life / particle.maxLife;
      paint.color = particle.color.withAlpha((alpha * 255 * 0.8).round());

      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);
      canvas.drawCircle(
        Offset.zero,
        particle.size,
        paint,
      );
      canvas.restore();
    }
  }

  void clear() {
    particles.clear();
  }
}
