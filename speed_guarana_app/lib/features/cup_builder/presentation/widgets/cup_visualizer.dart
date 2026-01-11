import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../domain/models/ingredient.dart';

class CupVisualizer extends StatefulWidget {
  final List<Ingredient> layers;
  final double height;
  final double width;

  const CupVisualizer({
    super.key,
    required this.layers,
    this.height = 380,
    this.width = 220,
  });

  @override
  State<CupVisualizer> createState() => _CupVisualizerState();
}

class _CupVisualizerState extends State<CupVisualizer> with SingleTickerProviderStateMixin {
  // Animação de rotação para dar o efeito 3D
  double _rotationY = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          // Permite girar o copo horizontalmente ao arrastar
          _rotationY += details.delta.dx * 0.01;
        });
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: widget.layers.length.toDouble()),
        duration: const Duration(milliseconds: 800),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return CustomPaint(
            size: Size(widget.width, widget.height),
            painter: _Realistic3DCupPainter(
              layers: widget.layers,
              rotation: _rotationY,
              animValue: value,
            ),
          );
        },
      ),
    );
  }
}

class _Realistic3DCupPainter extends CustomPainter {
  final List<Ingredient> layers;
  final double rotation;
  final double animValue;

  _Realistic3DCupPainter({
    required this.layers,
    required this.rotation,
    required this.animValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final centerX = w / 2;
    
    // Configuração da Perspectiva (O quanto a boca do copo é aberta)
    final double perspective = 0.15; // 15% de achatamento nas elipses
    final double bottomScale = 0.65; // Base é 65% do topo

    // 1. DESENHAR O CORPO DO COPO (VIDRO TRÁS)
    final pathGlass = Path();
    pathGlass.moveTo(w * (1 - bottomScale) / 2, h - 30); // Bottom Left
    pathGlass.quadraticBezierTo(centerX, h, w - (w * (1 - bottomScale) / 2), h - 30); // Base curve
    pathGlass.lineTo(w, 0); // Top Right
    pathGlass.lineTo(0, 0); // Top Left
    pathGlass.close();

    // Pintar vidro traseiro (Dark Glass)
    canvas.drawPath(pathGlass, Paint()..color = Colors.black.withOpacity(0.2));

    // 2. DESENHAR CONTEÚDO (CAMADAS)
    double currentFillLevel = 0.0; // 0.0 a 1.0 (altura do copo)

    // Primeiro, calculamos o nível total da massa base
    double baseLevel = 0.0;
    for (var layer in layers) {
      if (layer.type == TextureType.base) {
        baseLevel += layer.volume;
      }
    }
    // Limita a 90% para não transbordar
    baseLevel = baseLevel.clamp(0.0, 0.9);

    if (baseLevel > 0) {
      _drawLiquid(canvas, size, baseLevel, bottomScale, perspective, layers);
    }

    // 3. DESENHAR O VIDRO DA FRENTE (BRILHO E REFLEXO)
    _drawGlassReflections(canvas, size, pathGlass);
  }

  void _drawLiquid(Canvas canvas, Size size, double level, double bottomScale, double perspective, List<Ingredient> ingredients) {
    final w = size.width;
    final h = size.height;
    
    // Altura do líquido em pixels
    final liquidHeight = h * level;
    final topY = h - liquidHeight; // Y onde começa o líquido (de cima pra baixo)

    // Largura da superfície do líquido nessa altura (interpolação linear)
    // Na base (h) a largura é w * bottomScale. No topo (0) é w.
    final currentScale = bottomScale + (1 - bottomScale) * (liquidHeight / h);
    final liquidTopWidth = w * currentScale;
    final liquidTopLeftX = (w - liquidTopWidth) / 2;

    // --- A. MASSA (CORPO) ---
    final baseIngredient = ingredients.firstWhere(
      (i) => i.type == TextureType.base, 
      orElse: () => ingredients.first // Fallback
    );

    final liquidPath = Path();
    liquidPath.moveTo(liquidTopLeftX, topY); // Top Left do Liquido
    // Curva da base do copo
    liquidPath.lineTo((w * (1 - bottomScale) / 2), h - 30); 
    liquidPath.quadraticBezierTo(w / 2, h, w - (w * (1 - bottomScale) / 2), h - 30);
    liquidPath.lineTo(liquidTopLeftX + liquidTopWidth, topY); // Top Right do Liquido
    
    // Fechamento da elipse superior da massa (Superfície)
    liquidPath.addOval(Rect.fromLTWH(
      liquidTopLeftX, 
      topY - (liquidTopWidth * perspective / 2), 
      liquidTopWidth, 
      liquidTopWidth * perspective
    ));

    // Pintura da Massa (Gradiente Cilíndrico)
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          baseIngredient.colorPrimary, // Lado escuro
          baseIngredient.colorSecondary, // Centro brilhante (volume)
          baseIngredient.colorPrimary, // Lado escuro
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    
    canvas.drawPath(liquidPath, paint);

    // --- B. SUPERFÍCIE (ONDE FICAM OS TOPPINGS) ---
    // A "boca" da massa onde jogamos as coisas
    final surfaceRect = Rect.fromLTWH(
      liquidTopLeftX, 
      topY - (liquidTopWidth * perspective / 2), 
      liquidTopWidth, 
      liquidTopWidth * perspective
    );

    // Desenha a "tampa" da massa
    canvas.drawOval(surfaceRect, Paint()..color = baseIngredient.colorSecondary);

    // --- C. RENDERIZAR CROCANTES E COBERTURA (SÓ NA SUPERFÍCIE) ---
    for (var ingredient in ingredients) {
      if (ingredient.type == TextureType.solid) {
        _drawToppings(canvas, surfaceRect, ingredient);
      } else if (ingredient.type == TextureType.syrup) {
        _drawSyrup(canvas, surfaceRect, topY, liquidTopWidth, ingredient);
      }
    }
  }

  void _drawToppings(Canvas canvas, Rect surfaceRect, Ingredient ingredient) {
    final random = math.Random(ingredient.id.hashCode);
    final paint = Paint()..color = ingredient.colorPrimary;
    
    // Desenha partículas espalhadas APENAS dentro da elipse da superfície
    int particleCount = 60; 
    
    for (int i = 0; i < particleCount; i++) {
      // Coordenadas polares para distribuir na elipse
      // r = raio (0 a 1), theta = ângulo (0 a 2pi)
      double r = math.sqrt(random.nextDouble()); // sqrt para distribuição uniforme
      double theta = random.nextDouble() * 2 * math.pi;

      // Converter para cartesiano (achatado pela elipse)
      double dx = r * (surfaceRect.width / 2) * math.cos(theta);
      double dy = r * (surfaceRect.height / 2) * math.sin(theta);

      // Centro da elipse
      double cx = surfaceRect.center.dx;
      double cy = surfaceRect.center.dy;

      // Tamanho da partícula
      double size = random.nextDouble() * 3 + 2;

      // Desenha (com leve sombra para dar altura)
      canvas.drawCircle(Offset(cx + dx, cy + dy + 1), size, Paint()..color = Colors.black26);
      canvas.drawCircle(Offset(cx + dx, cy + dy), size, paint);
    }
  }

  void _drawSyrup(Canvas canvas, Rect surfaceRect, double topY, double width, Ingredient ingredient) {
    // 1. Cobertura na superfície (brilhante e líquida)
    final paint = Paint()..color = ingredient.colorPrimary.withOpacity(0.9);
    
    // Reduzimos um pouco a elipse para a calda não cobrir 100% da borda
    canvas.drawOval(surfaceRect.deflate(5), paint);

    // Brilho especular na calda (parecer melado)
    canvas.drawOval(
      Rect.fromCenter(center: surfaceRect.center.translate(-10, -2), width: surfaceRect.width * 0.4, height: surfaceRect.height * 0.4), 
      Paint()..color = Colors.white.withOpacity(0.3)
    );

    // 2. Drips (Escorrendo pelas laterais)
    // Usamos Bézier para fazer gotas orgânicas
    final dripPath = Path();
    double startX = surfaceRect.left + 10;
    double endX = surfaceRect.right - 10;
    
    // Vamos fazer 3 gotas principais
    double yBase = surfaceRect.bottom - (surfaceRect.height / 2); // Linha da borda visual frontal

    // Gota 1
    dripPath.moveTo(startX + 20, yBase);
    dripPath.quadraticBezierTo(startX + 30, yBase + 40, startX + 40, yBase);
    
    // Gota 2 (Maior)
    dripPath.moveTo(startX + 60, yBase);
    dripPath.quadraticBezierTo(startX + 75, yBase + 80, startX + 90, yBase);

    // Gota 3
    dripPath.moveTo(endX - 50, yBase);
    dripPath.quadraticBezierTo(endX - 40, yBase + 30, endX - 30, yBase);

    final dripPaint = Paint()
      ..color = ingredient.colorPrimary
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(dripPath, dripPaint);
  }

  void _drawGlassReflections(Canvas canvas, Size size, Path cupPath) {
    // Reflexo Branco Lateral (Vidro)
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(cupPath, borderPaint);

    // Highligth vertical (Luz de estúdio)
    final highlightPath = Path();
    highlightPath.moveTo(size.width * 0.8, 20);
    highlightPath.lineTo(size.width * 0.75, size.height - 40);
    
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white.withOpacity(0.0), Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter
      ).createShader(Rect.fromLTWH(0,0,size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;
      
    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant _Realistic3DCupPainter oldDelegate) {
    return oldDelegate.layers != layers || oldDelegate.rotation != rotation;
  }
}