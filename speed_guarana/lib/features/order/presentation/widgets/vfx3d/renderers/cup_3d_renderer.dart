import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class Cup3DRenderer {
  // Parâmetros do copo
  static const double cupWidth = 120;
  static const double cupHeight = 180;
  static const double cupTopWidth = 140;
  static const double cupBottomWidth = 100;
  static const double cupWallThickness = 8;

  // Renderiza o copo em perspectiva 3D
  void render(Canvas canvas, Size size, {required double rotationY}) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Perspectiva 3D
    final perspective = 0.0008;
    
    // Cria os pontos do copo em 3D e projeta para 2D
    final cupTopLeft = _project3D(center, -cupTopWidth / 2, -cupHeight / 2, 0, rotationY, perspective);
    final cupTopRight = _project3D(center, cupTopWidth / 2, -cupHeight / 2, 0, rotationY, perspective);
    final cupBottomLeft = _project3D(center, -cupBottomWidth / 2, cupHeight / 2, 0, rotationY, perspective);
    final cupBottomRight = _project3D(center, cupBottomWidth / 2, cupHeight / 2, 0, rotationY, perspective);

    // Parede frontal do copo
    final frontPath = Path()
      ..moveTo(cupBottomLeft.dx, cupBottomLeft.dy)
      ..lineTo(cupBottomRight.dx, cupBottomRight.dy)
      ..lineTo(cupTopRight.dx, cupTopRight.dy)
      ..lineTo(cupTopLeft.dx, cupTopLeft.dy)
      ..close();

    // Gradiente para profundidade
    final bounds = frontPath.getBounds();
    final cupPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.white.withAlpha((255 * 0.2).round()),
          Colors.white.withAlpha((255 * 0.35).round()),
          Colors.white.withAlpha((255 * 0.2).round()),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(bounds);

    canvas.drawPath(frontPath, cupPaint);

    // Borda superior do copo (brilho)
    final rimPath = Path()
      ..moveTo(cupTopLeft.dx, cupTopLeft.dy)
      ..lineTo(cupTopRight.dx, cupTopRight.dy);

    final rimPaint = Paint()
      ..color = Colors.white.withAlpha((255 * 0.5).round())
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawPath(rimPath, rimPaint);

    // Borda do copo (contorno)
    final borderPaint = Paint()
      ..color = Colors.white.withAlpha((255 * 0.25).round())
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(frontPath, borderPaint);

    // Reflexo interno (efeito de vidro)
    final reflectionPath = Path()
      ..moveTo(cupBottomLeft.dx + 15, cupBottomLeft.dy)
      ..quadraticBezierTo(
        cupBottomLeft.dx + 25,
        center.dy,
        cupTopLeft.dx + 15,
        cupTopLeft.dy,
      );

    final reflectionPaint = Paint()
      ..color = Colors.white.withAlpha((255 * 0.15).round())
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(reflectionPath, reflectionPaint);

    // Segundo reflexo (mais sutil)
    final reflectionPath2 = Path()
      ..moveTo(cupBottomRight.dx - 12, cupBottomRight.dy)
      ..quadraticBezierTo(
        cupBottomRight.dx - 20,
        center.dy,
        cupTopRight.dx - 12,
        cupTopRight.dy,
      );

    final reflectionPaint2 = Paint()
      ..color = Colors.white.withAlpha((255 * 0.08).round())
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(reflectionPath2, reflectionPaint2);

    // Sombra na parte inferior
    final shadowPath = Path()
      ..addOval(Rect.fromLTWH(
        center.dx - cupBottomWidth / 2,
        cupBottomLeft.dy - 5,
        cupBottomWidth,
        10,
      ));

    final shadowPaint = Paint()
      ..color = Colors.black.withAlpha((255 * 0.2).round())
      ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, 5);

    canvas.drawPath(shadowPath, shadowPaint);
  }

  Offset _project3D(
    Offset center,
    double x,
    double y,
    double z,
    double rotationY,
    double perspective,
  ) {
    // Rotação Y
    final cosY = cos(rotationY);
    final sinY = sin(rotationY);
    final rotatedX = x * cosY + z * sinY;
    final rotatedZ = -x * sinY + z * cosY;

    // Projeção perspectiva
    final scale = 1 / (1 + rotatedZ * perspective);
    final projectedX = rotatedX * scale;
    final projectedY = y * scale;

    return Offset(
      center.dx + projectedX,
      center.dy + projectedY,
    );
  }

  // Retorna o path do copo para clipping do líquido
  Path getCupClippingPath(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Path trapezoidal para o copo
    final path = Path();
    final topY = center.dy - cupHeight / 2;
    final bottomY = center.dy + cupHeight / 2;
    
    path.moveTo(center.dx - cupTopWidth / 2, topY);
    path.lineTo(center.dx + cupTopWidth / 2, topY);
    path.lineTo(center.dx + cupBottomWidth / 2, bottomY - 10);
    path.lineTo(center.dx - cupBottomWidth / 2, bottomY - 10);
    path.close();

    return path;
  }

  // Retorna a área do líquido
  Rect getLiquidArea(Size size, double liquidLevel) {
    final center = Offset(size.width / 2, size.height / 2);
    final topY = center.dy - cupHeight / 2 + 10;
    final bottomY = center.dy + cupHeight / 2 - 20;
    final liquidY = topY + (bottomY - topY) * (1 - liquidLevel);

    return Rect.fromLTWH(
      center.dx - cupTopWidth / 2,
      liquidY,
      cupTopWidth,
      bottomY - liquidY,
    );
  }
}
