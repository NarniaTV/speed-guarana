import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/ingredient.dart';
import '../controllers/wizard_controller.dart';
import '../widgets/live_cup_widget.dart';

class OrderWizardScreen extends StatelessWidget {
  const OrderWizardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<WizardController>();
    final state = controller.value;

    return Scaffold(
      body: Stack(
        children: [
          // Fundo Dark
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0F0F0F), Color(0xFF1A1A1A)],
              ),
            ),
          ),
          
          Column(
            children: [
              // Área do Copo
              Expanded(
                flex: 45,
                child: SafeArea(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      LiveCupWidget(controller: controller),
                      Positioned(
                        top: 20, right: 20,
                        child: _GlassBadge(
                          child: Text(
                            "R\$ ${state.totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: AppColors.neonGreen,
                              fontSize: 20, fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Área de Seleção (Menu)
              Expanded(
                flex: 55,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 20, offset: Offset(0, -5))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Adicione Energia", 
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${state.selectedToppings.length}/2 selecionados", 
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                      const SizedBox(height: 20),

                      Expanded(
                        child: state.isLoading
                            ? const Center(child: CircularProgressIndicator(color: AppColors.neonGreen))
                            : GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.85,
                                  crossAxisSpacing: 12, mainAxisSpacing: 12,
                                ),
                                itemCount: state.menu.length,
                                itemBuilder: (context, index) {
                                  final ingredient = state.menu[index];
                                  final isSelected = state.selectedToppings.any((i) => i.id == ingredient.id);
                                  
                                  return _IngredientCard(
                                    ingredient: ingredient,
                                    isSelected: isSelected,
                                    onTap: () {
                                      if (isSelected) controller.removeTopping(ingredient);
                                      else controller.addTopping(ingredient);
                                    },
                                  );
                                },
                              ),
                      ),
                      
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity, height: 56,
                        child: ElevatedButton(
                          onPressed: state.selectedToppings.isEmpty ? null : () {
                            // TODO: Navegar para carrinho
                          },
                          child: const Text("AVANÇAR", style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IngredientCard extends StatelessWidget {
  final Ingredient ingredient;
  final bool isSelected;
  final VoidCallback onTap;

  const _IngredientCard({required this.ingredient, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.neonGreen.withOpacity(0.15) : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.neonGreen : Colors.white10,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40, width: 40,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.neonGreen : Colors.grey[800],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.eco, color: isSelected ? Colors.black : Colors.white54),
            ),
            const SizedBox(height: 12),
            Text(
              ingredient.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[400],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "+ R\$ ${ingredient.price.toStringAsFixed(2)}",
              style: TextStyle(color: isSelected ? AppColors.neonGreen : Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassBadge extends StatelessWidget {
  final Widget child;
  const _GlassBadge({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: child,
    );
  }
}
