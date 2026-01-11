import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/glass_card.dart';
import '../../../../core/providers/cart_provider.dart'; // Importe o Provider
import '../../domain/models/ingredient.dart';
import '../../domain/models/cup_size.dart';
import '../controllers/cup_controller.dart';

class CupBuilderScreen extends StatelessWidget {
  const CupBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Injetamos o Controller LOCAL para a montagem
    return ChangeNotifierProvider(
      create: (_) => CupController(),
      child: const _CupBuilderContent(),
    );
  }
}

class _CupBuilderContent extends StatelessWidget {
  const _CupBuilderContent();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CupController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Fundo
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1A0524), Colors.black],
                ),
              ),
            ),
          ),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // --- APP BAR ---
              SliverAppBar(
                backgroundColor: AppColors.backgroundDark.withOpacity(0.9),
                expandedHeight: 100.0,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => context.go('/'),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text("Monte do seu jeito"),
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 16),
                  background: Container(color: Colors.black26),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh, color: AppColors.guaranaRed),
                    onPressed: controller.reset,
                  )
                ],
              ),

              // --- 1. TAMANHO ---
              _buildSectionHeader(context, "1. Qual o tamanho da fome?"),
              SliverToBoxAdapter(
                child: Container(
                  height: 120,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: mockCupSizes.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 15),
                    itemBuilder: (context, index) {
                      final size = mockCupSizes[index];
                      final isSelected = controller.selectedSize.id == size.id;
                      return _buildSizeCard(context, size, isSelected, () {
                        controller.selectSize(size);
                      });
                    },
                  ),
                ),
              ),

              // --- 2. BASE (Max 1) ---
              _buildSectionHeader(context, "2. Escolha a Base (Obrigatório)"),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final ingredient = mockBases[index];
                    final isSelected = controller.selectedBase?.id == ingredient.id;
                    return _buildSelectionTile(
                      context: context,
                      ingredient: ingredient,
                      isSelected: isSelected,
                      onTap: () => controller.selectBase(ingredient),
                      type: 'radio',
                    );
                  },
                  childCount: mockBases.length,
                ),
              ),

              // --- 3. CROCANTES (Max 2) ---
              _buildSectionHeader(
                context, 
                "3. Crocantes (Máx 2)", 
                subtitle: "${controller.selectedToppings.length}/2 selecionados"
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final ingredient = mockToppings[index];
                    final isSelected = controller.selectedToppings.contains(ingredient);
                    // Desabilita se já tem 2 e este não está selecionado
                    final isDisabled = !isSelected && controller.selectedToppings.length >= 2;

                    return _buildSelectionTile(
                      context: context,
                      ingredient: ingredient,
                      isSelected: isSelected,
                      isDisabled: isDisabled,
                      onTap: () {
                        if (!isDisabled) controller.toggleTopping(ingredient);
                      },
                      type: 'checkbox',
                    );
                  },
                  childCount: mockToppings.length,
                ),
              ),

              // --- 4. COBERTURA (Max 1) ---
              _buildSectionHeader(context, "4. Finalizar com Cobertura"),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final ingredient = mockSyrups[index];
                    final isSelected = controller.selectedSyrup?.id == ingredient.id;
                    return _buildSelectionTile(
                      context: context,
                      ingredient: ingredient,
                      isSelected: isSelected,
                      onTap: () => controller.toggleSyrup(ingredient),
                      type: 'radio',
                    );
                  },
                  childCount: mockSyrups.length,
                ),
              ),

              // --- 5. UTENSÍLIOS ---
              _buildSectionHeader(context, "5. Como vai tomar?"),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(child: _buildUtensilOption(context, "Colher", Icons.soup_kitchen, controller)),
                      const SizedBox(width: 15),
                      Expanded(child: _buildUtensilOption(context, "Canudo", Icons.local_drink, controller)),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 140)), // Espaço fundo
            ],
          ),

          // --- BOTTOM BAR ---
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(context, controller),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildSectionHeader(BuildContext context, String title, {String? subtitle}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            if (subtitle != null)
              Text(subtitle, style: const TextStyle(color: AppColors.neonGreen, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeCard(BuildContext context, CupSize size, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        width: 100,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.acaiPurple.withOpacity(0.8) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.neonGreen : Colors.white12,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(size.label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 5),
            Text("R\$ ${size.basePrice.toStringAsFixed(0)}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionTile({
    required BuildContext context,
    required Ingredient ingredient,
    required bool isSelected,
    required VoidCallback onTap,
    required String type,
    bool isDisabled = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          // MUDANÇA DE FUNDO AO SELECIONAR
          color: isSelected 
              ? AppColors.acaiPurple.withOpacity(0.3) 
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? AppColors.neonGreen 
                : Colors.white10,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Bolinha de Cor
            Container(
              width: 12, height: 12,
              decoration: BoxDecoration(
                color: ingredient.colorPrimary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                ingredient.name,
                style: TextStyle(
                  color: isDisabled ? Colors.white30 : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (ingredient.price > 0)
              Text(
                "+ R\$ ${ingredient.price.toStringAsFixed(2)}",
                style: TextStyle(color: isSelected ? AppColors.neonGreen : Colors.white54, fontSize: 12),
              ),
            const SizedBox(width: 10),
            
            // Checkbox ou Radio Visual
            Icon(
              isSelected 
                  ? (type == 'radio' ? Icons.radio_button_checked : Icons.check_circle)
                  : (type == 'radio' ? Icons.radio_button_unchecked : Icons.circle_outlined),
              color: isSelected ? AppColors.neonGreen : (isDisabled ? Colors.white10 : Colors.white30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUtensilOption(BuildContext context, String label, IconData icon, CupController controller) {
    final isSelected = controller.selectedUtensil == label;
    return GestureDetector(
      onTap: () => controller.setUtensil(label),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.neonGreen.withOpacity(0.2) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.neonGreen : Colors.white10),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? AppColors.neonGreen : Colors.white54),
            const SizedBox(height: 5),
            Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.white54, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, CupController controller) {
    final bool isValid = controller.selectedBase != null;

    return GlassCard(
      blur: 20,
      opacity: 0.95,
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // CONTROLE DE QUANTIDADE DO COPO
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Quantidade:", style: TextStyle(color: Colors.white70)),
              const SizedBox(width: 15),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, color: Colors.white),
                      onPressed: controller.decrementQuantity,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "${controller.cupQuantity}",
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: AppColors.neonGreen),
                      onPressed: controller.incrementQuantity,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // BOTÃO ADICIONAR E TOTAL
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Total", style: TextStyle(color: Colors.black54, fontSize: 12)),
                    Text(
                      "R\$ ${controller.totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(color: AppColors.acaiPurple, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: isValid ? () {
                    final item = controller.buildCartItem();
                    if (item != null) {
                      // Adiciona ao Carrinho Global
                      context.read<CartProvider>().addItem(item);
                      
                      // Feedback e Volta
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Adicionado à sacola com sucesso!"),
                          backgroundColor: AppColors.neonGreen,
                          behavior: SnackBarBehavior.floating,
                        )
                      );
                      context.pop(); // Volta para Home
                    }
                  } : null, // Desabilitado se não tiver base
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isValid ? AppColors.acaiPurple : Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    isValid ? "ADICIONAR À SACOLA" : "ESCOLHA A BASE",
                    style: TextStyle(color: isValid ? Colors.white : Colors.white30, fontWeight: FontWeight.bold),
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