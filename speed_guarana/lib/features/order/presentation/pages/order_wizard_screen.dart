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
    final state = controller.state;

    return Scaffold(
      body: Stack(
        children: [
          // Background Premium
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0F0F0F), Color(0xFF1C1C1C)],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // 1. Header (Steps & Price)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StepIndicator(currentStep: state.currentStep),
                      _GlassBadge(
                        child: Text(
                          "R\$ ${state.totalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: AppColors.neonGreen,
                            fontSize: 18, fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Área do Copo (Rive)
                Expanded(
                  flex: 4,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      LiveCupWidget(controller: controller),
                      if (state.selectedFlavor == null)
                        const Positioned(
                          bottom: 20,
                          child: Text("Selecione um sabor para começar", style: TextStyle(color: Colors.white38)),
                        ),
                    ],
                  ),
                ),

                // 3. Área de Seleção (Wizard Dinâmico)
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                      boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 20, offset: Offset(0, -5))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título do Passo
                        Text(
                          controller.stepTitle, 
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 16),

                        // Grid de Itens
                        Expanded(
                          child: state.isLoading
                              ? const Center(child: CircularProgressIndicator(color: AppColors.neonGreen))
                              : GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 0.8,
                                    crossAxisSpacing: 12, mainAxisSpacing: 12,
                                  ),
                                  itemCount: controller.currentStepItems.length,
                                  itemBuilder: (context, index) {
                                    final item = controller.currentStepItems[index];
                                    final isSelected = _isItemSelected(state, item);
                                    
                                    return _IngredientCard(
                                      ingredient: item,
                                      isSelected: isSelected,
                                      onTap: () => controller.selectItem(item),
                                    );
                                  },
                                ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Botões de Navegação
                        Row(
                          children: [
                            if (state.currentStep != OrderStep.flavor)
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: IconButton(
                                  onPressed: controller.previousStep,
                                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                                  style: IconButton.styleFrom(backgroundColor: Colors.white10),
                                ),
                              ),
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _canProceed(state) ? controller.nextStep : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.neonGreen,
                                    disabledBackgroundColor: Colors.white10,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                  child: Text(
                                    state.currentStep == OrderStep.review ? "FINALIZAR PEDIDO" : "PRÓXIMO",
                                    style: TextStyle(
                                      fontSize: 16, 
                                      fontWeight: FontWeight.bold,
                                      color: _canProceed(state) ? Colors.black : Colors.white24
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isItemSelected(WizardState state, Ingredient item) {
    if (item.type == IngredientType.flavor) return state.selectedFlavor?.id == item.id;
    if (item.type == IngredientType.complement) return state.selectedComplements.contains(item);
    if (item.type == IngredientType.topping) return state.selectedToppings.contains(item);
    return false;
  }

  bool _canProceed(WizardState state) {
    if (state.currentStep == OrderStep.flavor) return state.selectedFlavor != null;
    return true; // Complementos e Coberturas são opcionais? Se sim, true.
  }
}

// --- Widgets Auxiliares ---

class _StepIndicator extends StatelessWidget {
  final OrderStep currentStep;
  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    int stepIndex = currentStep.index;
    return Row(
      children: List.generate(4, (index) {
        bool isActive = index <= stepIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.neonGreen : Colors.white10,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
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
            Container( // Placeholder do Ícone
              height: 40, width: 40,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.neonGreen : Colors.white10,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconForType(ingredient.type), 
                color: isSelected ? Colors.black : Colors.white54
              ),
            ),
            const SizedBox(height: 10),
            Text(
              ingredient.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[400],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            if (ingredient.price > 0)
              Text(
                "+ R\$ ${ingredient.price.toStringAsFixed(2)}",
                style: const TextStyle(color: AppColors.neonGreen, fontSize: 11),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(IngredientType type) {
    switch (type) {
      case IngredientType.flavor: return Icons.local_drink;
      case IngredientType.complement: return Icons.cookie;
      case IngredientType.topping: return Icons.water_drop;
    }
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
