import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/glass_card.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../domain/models/ingredient.dart';
import '../../domain/models/cup_size.dart';
import '../controllers/wizard_controller.dart';

class OrderWizardScreen extends StatelessWidget {
  const OrderWizardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WizardController(),
      child: const _WizardContent(),
    );
  }
}

class _WizardContent extends StatelessWidget {
  const _WizardContent();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<WizardController>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Fundo Minimalista Dark
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [Color(0xFF220033), Colors.black],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header (Só aparece se não for Review ou Qty)
                if (controller.currentStep != WizardStep.quantity && controller.currentStep != WizardStep.review)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "PEDIDO ${controller.currentCupIndex}",
                          style: const TextStyle(
                            color: AppColors.neonGreen, 
                            fontWeight: FontWeight.bold, 
                            letterSpacing: 1.5
                          ),
                        ).animate().fadeIn(),
                        Text(
                          "passo ${_stepIndex(controller.currentStep)}/5",
                          style: const TextStyle(color: Colors.white30),
                        ),
                      ],
                    ),
                  ),

                // O CONTEÚDO PRINCIPAL (Muda conforme o passo)
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: _buildCurrentStep(context, controller),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _stepIndex(WizardStep step) {
    switch(step) {
      case WizardStep.size: return 1;
      case WizardStep.base: return 2;
      case WizardStep.toppings: return 3;
      case WizardStep.syrup: return 4;
      case WizardStep.utensil: return 5;
      default: return 0;
    }
  }

  Widget _buildCurrentStep(BuildContext context, WizardController controller) {
    // Chave única para forçar a animação na troca de passo
    final Key key = ValueKey(controller.currentStep);

    switch (controller.currentStep) {
      case WizardStep.quantity:
        return _QuantityStep(key: key, controller: controller);
      case WizardStep.size:
        return _SelectionStep<CupSize>(
          key: key,
          title: "Qual o tamanho?",
          items: mockCupSizes,
          selectedItem: controller.tempSize,
          onSelect: controller.selectSize,
          itemLabel: (s) => s.label,
          itemSubtitle: (s) => s.description,
          itemPrice: (s) => s.basePrice,
        );
      case WizardStep.base:
        return _SelectionStep<Ingredient>(
          key: key,
          title: "Escolha a base",
          items: mockBases,
          selectedItem: controller.tempBase,
          onSelect: controller.selectBase,
          itemLabel: (i) => i.name,
          itemColor: (i) => i.colorPrimary,
        );
      case WizardStep.toppings:
        return _MultiSelectionStep(
          key: key,
          title: "Crocantes (Max 2)",
          items: mockToppings,
          selectedItems: controller.tempToppings,
          onToggle: controller.toggleTopping,
          onNext: controller.nextFromToppings,
        );
      case WizardStep.syrup:
        return _MultiSelectionStep(
          key: key,
          title: "Cobertura",
          items: mockSyrups,
          selectedItems: controller.tempSyrup != null ? [controller.tempSyrup!] : [],
          onToggle: controller.toggleSyrup,
          onNext: controller.nextFromSyrup,
          isSingle: true, // Modo Radio visual
        );
      case WizardStep.utensil:
        return _UtensilStep(key: key, controller: controller);
      case WizardStep.review:
        return _ReviewStep(key: key, controller: controller);
    }
  }
}

// --- PASSO 1: QUANTIDADE (O INÍCIO RÁPIDO) ---
class _QuantityStep extends StatelessWidget {
  final WizardController controller;
  const _QuantityStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final TextEditingController textCtrl = TextEditingController();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Quantos Guaranás\nvocê vai querer?",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ).animate().fadeIn().moveY(begin: 20, end: 0),
          
          const SizedBox(height: 40),

          // Botões 1 e 2
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _BigButton(label: "1", onTap: () => controller.setQuantity(1)),
              const SizedBox(width: 20),
              _BigButton(label: "2", onTap: () => controller.setQuantity(2)),
            ],
          ).animate(delay: 200.ms).fadeIn(),

          const SizedBox(height: 20),

          // Input de "Mais"
          SizedBox(
            width: 200,
            child: TextField(
              controller: textCtrl,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                hintText: "Outra quantidade",
                hintStyle: const TextStyle(color: Colors.white30),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: AppColors.neonGreen),
                  onPressed: () {
                     if (textCtrl.text.isNotEmpty) {
                       controller.setQuantity(int.tryParse(textCtrl.text) ?? 1);
                     }
                  },
                )
              ),
            ),
          ).animate(delay: 400.ms).fadeIn(),
        ],
      ),
    );
  }
}

class _BigButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _BigButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80, height: 80,
        decoration: BoxDecoration(
          color: AppColors.acaiPurple,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: AppColors.acaiPurple.withOpacity(0.5), blurRadius: 20)]
        ),
        child: Center(
          child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

// --- PASSO GENÉRICO DE SELEÇÃO ÚNICA (SIZE, BASE) ---
class _SelectionStep<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final T? selectedItem;
  final Function(T) onSelect;
  final String Function(T) itemLabel;
  final String Function(T)? itemSubtitle;
  final Color Function(T)? itemColor;
  final double Function(T)? itemPrice;

  const _SelectionStep({
    super.key, required this.title, required this.items, required this.selectedItem, required this.onSelect,
    required this.itemLabel, this.itemSubtitle, this.itemColor, this.itemPrice
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 1),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 30),
        
        // Lista Centralizada
        Column(
          children: items.map((item) {
            final isSelected = selectedItem == item;
            return GestureDetector(
              onTap: () => onSelect(item),
              child: AnimatedContainer(
                duration: 200.ms,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.acaiPurple : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                  border: isSelected ? Border.all(color: AppColors.neonGreen, width: 2) : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (itemColor != null)
                          Container(width: 15, height: 15, margin: const EdgeInsets.only(right: 15), decoration: BoxDecoration(color: itemColor!(item), shape: BoxShape.circle)),
                        Text(itemLabel(item), style: const TextStyle(color: Colors.white, fontSize: 18)),
                      ],
                    ),
                    if (itemPrice != null)
                       Text("R\$ ${itemPrice!(item).toStringAsFixed(2)}", style: const TextStyle(color: Colors.white54)),
                  ],
                ),
              ),
            );
          }).toList(),
        ).animate().fadeIn().slideY(begin: 0.1, end: 0),
        const Spacer(flex: 2),
      ],
    );
  }
}

// --- PASSO DE MULTI-SELEÇÃO (TOPPINGS, SYRUP) ---
class _MultiSelectionStep extends StatelessWidget {
  final String title;
  final List<Ingredient> items;
  final List<Ingredient> selectedItems;
  final Function(Ingredient) onToggle;
  final VoidCallback onNext;
  final bool isSingle;

  const _MultiSelectionStep({
    super.key, required this.title, required this.items, required this.selectedItems,
    required this.onToggle, required this.onNext, this.isSingle = false
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = selectedItems.contains(item);
              return GestureDetector(
                onTap: () => onToggle(item),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.acaiPurple.withOpacity(0.5) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSelected ? AppColors.neonGreen : Colors.white10),
                  ),
                  child: Row(
                    children: [
                      Container(width: 30, height: 30, decoration: BoxDecoration(color: item.colorPrimary, shape: BoxShape.circle)),
                      const SizedBox(width: 15),
                      Text(item.name, style: const TextStyle(color: Colors.white, fontSize: 16)),
                      const Spacer(),
                      if (isSelected) const Icon(Icons.check, color: AppColors.neonGreen)
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        GlassCard(
          opacity: 0.1,
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonGreen, padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text("PRÓXIMO", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
        )
      ],
    );
  }
}

// --- PASSO FINAL DE CADA COPO: UTENSÍLIO ---
class _UtensilStep extends StatelessWidget {
  final WizardController controller;
  const _UtensilStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Para finalizar:", style: TextStyle(color: Colors.white54, fontSize: 18)),
        const SizedBox(height: 10),
        const Text("Colher ou Canudo?", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _UtensilButton(icon: Icons.soup_kitchen, label: "Colher", onTap: () => controller.selectUtensil("Colher")),
            const SizedBox(width: 30),
            _UtensilButton(icon: Icons.local_drink, label: "Canudo", onTap: () => controller.selectUtensil("Canudo")),
          ],
        )
      ],
    );
  }
}

class _UtensilButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _UtensilButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle, border: Border.all(color: Colors.white30)),
            child: Icon(icon, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 15),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 18))
        ],
      ),
    );
  }
}

// --- TELA DE RESUMO FINAL (CHECKOUT) ---
class _ReviewStep extends StatelessWidget {
  final WizardController controller;
  const _ReviewStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    double grandTotal = controller.completedCups.fold(0, (sum, item) => sum + item.totalPrice);

    return Column(
      children: [
        const SizedBox(height: 20),
        const Icon(Icons.check_circle_outline, color: AppColors.neonGreen, size: 60),
        const SizedBox(height: 20),
        const Text("Tudo pronto!", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const Text("Confira seu pedido", style: TextStyle(color: Colors.white54)),
        
        const SizedBox(height: 30),
        
        // Lista dos Pedidos Feitos
        Expanded(
          child: ListView.builder(
            itemCount: controller.completedCups.length,
            itemBuilder: (context, index) {
              final item = controller.completedCups[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColors.acaiPurple.withOpacity(0.2), shape: BoxShape.circle),
                      child: Text("${index + 1}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${item.size.label} - ${item.base?.name ?? 'S/ Base'}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text(item.toppings.map((t) => t.name).join(", "), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                    ),
                    Text("R\$ ${item.totalPrice.toStringAsFixed(2)}", style: const TextStyle(color: AppColors.neonGreen)),
                  ],
                ),
              );
            },
          ),
        ),

        // Botão Final
        GlassCard(
          opacity: 0.2,
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Final", style: TextStyle(color: Colors.white)),
                  Text("R\$ ${grandTotal.toStringAsFixed(2)}", style: const TextStyle(color: AppColors.neonGreen, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                     // Adiciona tudo ao Carrinho Global
                     final cart = context.read<CartProvider>();
                     for (var item in controller.completedCups) {
                       cart.addItem(item);
                     }
                     
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pedido Enviado à Cozinha! 🚀")));
                     context.go('/'); // Volta ao Menu Principal
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonGreen, padding: const EdgeInsets.symmetric(vertical: 18)),
                  child: const Text("CONCLUIR PEDIDO", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}