import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/glass_card.dart';
import '../../domain/models/ingredient.dart';
import '../controllers/cup_controller.dart';
import '../widgets/cup_visualizer.dart';

class CupBuilderScreen extends StatelessWidget {
  const CupBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Injetamos o Controller apenas para essa árvore de widgets
    return ChangeNotifierProvider(
      create: (_) => CupController(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => context.go('/'),
          ),
          title: const Text("Monte seu Copo", style: TextStyle(color: Colors.white)),
          actions: [
            // Botão Reset
            Consumer<CupController>(
              builder: (context, controller, _) => IconButton(
                icon: const Icon(Icons.refresh, color: AppColors.neonGreen),
                onPressed: controller.resetCup,
              ),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(gradient: AppColors.mainGradient),
          child: SafeArea(
            child: Column(
              children: [
                // 1. Área Visual do Copo
                Expanded(
                  flex: 5,
                  child: Center(
                    child: Consumer<CupController>(
                      builder: (context, controller, _) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CupVisualizer(layers: controller.layers),
                            const SizedBox(height: 20),
                            // Mostrador de Preço
                            Text(
                              "R\$ ${controller.totalPrice.toStringAsFixed(2)}",
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: AppColors.neonGreen,
                                fontSize: 40,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                // 2. Seletor de Ingredientes
                Expanded(
                  flex: 4,
                  child: GlassCard(
                    blur: 20,
                    opacity: 0.1,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10, bottom: 10),
                          child: Text(
                            "Adicionar Camada:",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16, 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: mockIngredients.length,
                            itemBuilder: (context, index) {
                              final ingredient = mockIngredients[index];
                              return _buildIngredientButton(context, ingredient);
                            },
                          ),
                        ),
                        // Botão de Finalizar
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Enviando para a cozinha...")),
                              );
                              // Futuro: Navegar para Checkout
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text("FINALIZAR PEDIDO"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientButton(BuildContext context, Ingredient ingredient) {
    return Consumer<CupController>(
      builder: (context, controller, _) {
        return GestureDetector(
          onTap: () {
            controller.addLayer(ingredient);
            // Feedback Tátil (Vibração) quando possível
            // HapticFeedback.lightImpact(); 
          },
          child: Column(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: ingredient.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white30, width: 2),
                  boxShadow: [
                    if (ingredient.color == Colors.black || ingredient.color == AppColors.acaiPurple)
                       BoxShadow(color: Colors.white.withOpacity(0.2), blurRadius: 5)
                  ]
                ),
                child: Center(
                  child: Text(
                    "+", 
                    style: TextStyle(
                      color: ingredient.color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                ingredient.name,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 10),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "+R\$${ingredient.price.toStringAsFixed(2)}",
                style: const TextStyle(color: AppColors.neonGreen, fontSize: 9),
              ),
            ],
          ),
        );
      },
    );
  }
}