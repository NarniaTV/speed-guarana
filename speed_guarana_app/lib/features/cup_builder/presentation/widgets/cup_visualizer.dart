import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/models/ingredient.dart';

class CupVisualizer extends StatelessWidget {
  final List<Ingredient> layers;
  final double height;
  final double width;

  const CupVisualizer({
    super.key,
    required this.layers,
    this.height = 350,
    this.width = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // 1. O Copo (Fundo do Vidro)
          CustomPaint(
            size: Size(width, height),
            painter: _CupGlassPainter(isFront: false),
          ),

          // 2. Conteúdo (Massa e Recheios)
          // Usamos ClipPath para garantir que o conteúdo fique DENTRO do formato do copo
          ClipPath(
            clipper: _CupClipper(),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: _buildRealisticLayers(),
            ),
          ),

          // 3. Reflexo (Frente do Vidro)
          CustomPaint(
            size: Size(width, height),
            painter: _CupGlassPainter(isFront: true),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRealisticLayers() {
    if (layers.isEmpty) return [];

    // Lógica para empilhar visualmente
    List<Widget> widgetLayers = [];
    double currentHeightPercentage = 0.0;
    
    // Altura fixa por camada para simplificar a visualização proporcional
    final layerHeight = 1.0 / (layers.length > 0 ? layers.length : 1);

    for (int i = 0; i < layers.length; i++) {
      final ingredient = layers[i];
      
      widgetLayers.add(
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: height * ((i + 1) * layerHeight), // Empilha aumentando a altura
            width: double.infinity,
            child: CustomPaint(
              painter: _IngredientTexturePainter(
                ingredient: ingredient,
                seed: i, // Semente aleatória para partículas não ficarem iguais
              ),
            ),
          ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutBack),
        ),
      );
    }
    return widgetLayers;
  }
}

// --- PINTORES (A Parte Artística) ---

// 1. Recorte do Formato do Copo (Trapezoidal)
class _CupClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double w = size.width;
    double h = size.height;
    double bottomScale = 0.65; // A base é 65% da largura do topo

    path.moveTo(0, 0); // Top Left
    path.lineTo(w * (1 - bottomScale) / 2, h - 20); // Bottom Left (com curva)
    path.quadraticBezierTo(w * (1 - bottomScale) / 2, h, w / 2, h); // Base Curve
    path.quadraticBezierTo(w - (w * (1 - bottomScale) / 2), h, w - (w * (1 - bottomScale) / 2), h - 20); // Bottom Right
    path.lineTo(w, 0); // Top Right
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// 2. Texturas (Massa vs Granulado)
class _IngredientTexturePainter extends CustomPainter {
  final Ingredient ingredient;
  final int seed;

  _IngredientTexturePainter({required this.ingredient, required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint();

    if (ingredient.type == TextureType.base || ingredient.type == TextureType.syrup) {
      // GRADIENTE LÍQUIDO/CREMOSO
      paint.shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          ingredient.colorPrimary,
          ingredient.colorSecondary,
          ingredient.colorPrimary,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect);
      
      canvas.drawRect(rect, paint);
      
      // Se for Calda, adiciona brilho extra
      if(ingredient.type == TextureType.syrup) {
        final highlightPaint = Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
         // Simula escorrido
         // (Simplificado para este exemplo)
      }

    } else if (ingredient.type == TextureType.solid) {
      // PARTÍCULAS (AMENDOIM/FLOCOS)
      // Primeiro preenche o fundo um pouco transparente
      paint.color = ingredient.colorSecondary.withOpacity(0.8);
      canvas.drawRect(rect, paint);

      // Desenha "pedacinhos"
      final random = Random(seed);
      final particlePaint = Paint()..color = ingredient.colorPrimary;
      
      for (int i = 0; i < 150; i++) {
        double dx = random.nextDouble() * size.width;
        double dy = random.nextDouble() * size.height;
        double r = random.nextDouble() * 3 + 1; // Tamanho do grão
        canvas.drawCircle(Offset(dx, dy), r, particlePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 3. O Vidro do Copo
class _CupGlassPainter extends CustomPainter {
  final bool isFront;
  _CupGlassPainter({required this.isFront});

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    double bottomScale = 0.65;
    
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(w * (1 - bottomScale) / 2, h - 20);
    path.quadraticBezierTo(w * (1 - bottomScale) / 2, h, w / 2, h);
    path.quadraticBezierTo(w - (w * (1 - bottomScale) / 2), h, w - (w * (1 - bottomScale) / 2), h - 20);
    path.lineTo(w, 0);

    if (!isFront) {
      // Fundo do copo (escuro e fosco)
      Paint bgPaint = Paint()
        ..color = Colors.black.withOpacity(0.3)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, bgPaint);
    } else {
      // Frente do copo (Reflexos e Bordas)
      Paint borderPaint = Paint()
        ..color = Colors.white.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawPath(path, borderPaint);

      // Reflexo lateral (Glow)
      Paint reflectionPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.4),
            Colors.transparent,
            Colors.white.withOpacity(0.1),
          ],
        ).createShader(Rect.fromLTWH(0, 0, w, h));
      
      // Um reflexo curvado no lado direito
      Path reflectionPath = Path();
      reflectionPath.moveTo(w * 0.85, 10);
      reflectionPath.lineTo(w * 0.75, h - 30);
      reflectionPath.lineTo(w * 0.82, h - 30);
      reflectionPath.lineTo(w * 0.92, 10);
      canvas.drawPath(reflectionPath, reflectionPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}