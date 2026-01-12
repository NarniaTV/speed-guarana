import 'package:flutter/material.dart';

class Particle {
  Offset position;
  Offset velocity;
  Color color;
  double size;
  double life;
  double maxLife;
  double rotation;
  double rotationSpeed;

  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.life,
    required this.maxLife,
    this.rotation = 0,
    this.rotationSpeed = 0,
  });

  bool get isAlive => life > 0;

  void update(double dt) {
    position += Offset(velocity.dx * dt, velocity.dy * dt);
    velocity += Offset(0, 50 * dt); // Gravidade
    life -= dt;
    rotation += rotationSpeed * dt;
    size = size * 0.98; // Shrink
  }
}
