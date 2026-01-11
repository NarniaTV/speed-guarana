import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/ingredient.dart';

class CupVisualizer extends StatelessWidget {
  final List<Ingredient> layers;
  final double height;
  final double width;

  const CupVisualizer({
    super.key,
    required this.layers,
    this.height = 300,
    this.width = 180,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // 1. O Copo (Recipiente)
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.acaiPurple.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(38),
                bottomRight: Radius.circular(38),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Se o copo estiver vazio, mostramos um placeholder sutil
                  if (layers.isEmpty)
                     Expanded(
                       child: Center(
                         child: Text(
                           "Monte seu\nGuaraná",
                           textAlign: TextAlign.center,
                           style: TextStyle(color: Colors.white.withOpacity(0.2)),
                         ),
                       ),
                     ),

                  // Renderização das Camadas (inverso para empilhar de baixo pra cima visualmente)
                  ...layers.reversed.map((ingredient) {
                    return Flexible(
                      flex: 1, // Todas as camadas têm o mesmo peso visual por enquanto
                      child: Container(
                        width: double.infinity,
                        color: ingredient.color,
                        child: Center(
                          child: Text(
                            ingredient.name[0], // Apenas a inicial para identificar
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5), 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ).animate().fadeIn().slideY(begin: -0.5, end: 0), 
                      // Animação de "cair" no copo
                    );
                  }),
                ],
              ),
            ),
          ),
          
          // 2. Reflexo do Vidro (Detalhe de UI para Glassmorphism)
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              width: 10,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white.withOpacity(0.4), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}