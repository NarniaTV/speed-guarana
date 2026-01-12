import 'dart:math';

class LiquidWave {
  double amplitude;
  double frequency;
  double phase;
  double speed;

  LiquidWave({
    this.amplitude = 5.0,
    this.frequency = 0.02,
    this.phase = 0.0,
    this.speed = 2.0,
  });

  double getValue(double x) {
    return amplitude * sin((x * frequency) + phase);
  }

  void update(double dt) {
    phase += speed * dt;
  }
}
