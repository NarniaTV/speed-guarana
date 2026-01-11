import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/ingredient.dart';
import '../controllers/cup_controller.dart';
import '../widgets/cup_visualizer.dart';

class CupBuilderScreen extends StatefulWidget {
  const CupBuilderScreen({super.key});

  @override
  State<CupBuilderScreen> createState() => _CupBuilderScreenState();
}

class _CupBuilderScreenState extends State<CupBuilderScreen> {
  // Controle de Abas (Categorias)
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ["Massa", "Crocante", "Cobertura"];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CupController(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => context.go('/'),
          ),
          title: Text(
            "Monte seu Guaraná", 
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)
          ),
          centerTitle: true,
          actions: [
            Consumer<CupController>(
              builder: (context, controller, _) => IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.guaranaRed),
                onPressed: controller.resetCup,
              ),
            ),
          ],
        ),
        body: Container(
          // Fundo mais sofisticado (Vignette)
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.2),
              radius: 1.3,
              colors: [Color(0xFF2C2C2C), Colors.black],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // 1. ÁREA DO COPO (Destaque Central)
                Expanded(
                  flex: 6,
                  child: Center(
                    child: Consumer<CupController>(
                      builder: (context, controller, _) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // Glow atrás do copo
                            Container(
                              width: 250,
                              height: 300,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.acaiPurple.withOpacity(0.3),
                                    blurRadius: 60,
                                    spreadRadius: 10,
                                  )
                                ]
                              ),
                            ),
                            CupVisualizer(layers: controller.layers),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                // 2. PAINEL DE CONTROLE (Preço + Seleção)
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
                    ),
                    child: Column(
                      children: [
                        // Valor Total
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Consumer<CupController>(
                            builder: (context, controller, _) => Text(
                              "R\$ ${controller.totalPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: AppColors.neonGreen,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),

                        // Tabs de Categorias
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: List.generate(_categories.length, (index) {
                              final isSelected = _selectedCategoryIndex == index;
                              return GestureDetector(
                                onTap: () => setState(() => _selectedCategoryIndex = index),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 15),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: isSelected ? Colors.transparent : Colors.white24),
                                  ),
                                  child: Text(
                                    _categories[index],
                                    style: TextStyle(
                                      color: isSelected ? Colors.black : Colors.white54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Lista de Ingredientes da Categoria Selecionada
                        Expanded(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            children: _getCurrentIngredients().map((ingredient) {
                              return _buildIngredientCard(ingredient);
                            }).toList(),
                          ),
                        ),
                        
                        // Botão de Ação
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                // Futuro: Ir para Checkout
                              },
                              child: const Text("AVANÇAR PARA ENTREGA"),
                            ),
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

  List<Ingredient> _getCurrentIngredients() {
    switch (_selectedCategoryIndex) {
      case 0: return mockBases;
      case 1: return mockToppings;
      case 2: return mockSyrups;
      default: return [];
    }
  }

  Widget _buildIngredientCard(Ingredient ingredient) {
    return Consumer<CupController>(
      builder: (context, controller, _) {
        return GestureDetector(
          onTap: () => controller.addLayer(ingredient),
          child: Container(
            width: 100,
            margin: const EdgeInsets.only(right: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Círculo de cor/textura
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [ingredient.colorPrimary, ingredient.colorSecondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(color: ingredient.colorPrimary.withOpacity(0.4), blurRadius: 8)
                    ]
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  ingredient.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                ),
                Text(
                  ingredient.price == 0 ? "Grátis" : "+R\$ ${ingredient.price.toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.white54, fontSize: 10),
                ),
              ],
            ),
          ).animate().scale(duration: 200.ms),
        );
      },
    );
  }
}