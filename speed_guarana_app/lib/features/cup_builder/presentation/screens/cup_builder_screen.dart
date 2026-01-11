import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/glass_card.dart';
import '../../domain/models/ingredient.dart';
import '../../domain/models/cup_size.dart';
import '../controllers/cup_controller.dart';

class CupBuilderScreen extends StatelessWidget {
  const CupBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          // Fundo com Gradiente Sutil
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF2E004F), Colors.black],
                  stops: [0.0, 0.4],
                ),
              ),
            ),
          ),

          // Conteúdo com Rolagem (Slivers)
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. App Bar Expansível
              SliverAppBar(
                backgroundColor: AppColors.backgroundDark.withOpacity(0.9),
                expandedHeight: 120.0,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => context.go('/'),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    "Monte seu Guaraná",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  centerTitle: false,
                  titlePadding: const EdgeInsets.only(left: 60, bottom: 16),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.delete_sweep_outlined, color: Colors.white70),
                    onPressed: controller.reset,
                  )
                ],
              ),

              // 2. Título da Seção: Tamanho
              _buildSectionHeader(context, "1. Escolha o Tamanho"),

              // 3. Seletor de Tamanhos (Cards Horizontais)
              SliverToBoxAdapter(
                child: Container(
                  height: 140,
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

              // 4. Título da Seção: Bases
              _buildSectionHeader(context, "2. Escolha a Base"),

              // 5. Lista de Bases
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final ingredient = mockBases[index];
                    return _buildIngredientTile(context, ingredient, controller);
                  },
                  childCount: mockBases.length,
                ),
              ),

              // 6. Título da Seção: Crocantes & Adicionais
              _buildSectionHeader(context, "3. Turbinar (Crocantes)"),

              // 7. Lista de Adicionais
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final ingredient = mockToppings[index];
                    return _buildIngredientTile(context, ingredient, controller);
                  },
                  childCount: mockToppings.length,
                ),
              ),

               // 8. Título da Seção: Cobertura
              _buildSectionHeader(context, "4. Finalizar (Cobertura)"),

              // 9. Lista de Coberturas
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final ingredient = mockSyrups[index];
                    return _buildIngredientTile(context, ingredient, controller);
                  },
                  childCount: mockSyrups.length,
                ),
              ),

              // Espaço extra para não esconder conteúdo atrás da Bottom Bar
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),

          // Bottom Bar Flutuante (Checkout)
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

  Widget _buildSectionHeader(BuildContext context, String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSizeCard(BuildContext context, CupSize size, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        width: 110,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.acaiPurple : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.neonGreen : Colors.white10,
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_drink_rounded, 
              size: 32, 
              color: isSelected ? Colors.white : Colors.white30
            ),
            const SizedBox(height: 8),
            Text(
              size.label,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              "R\$ ${size.basePrice.toStringAsFixed(2)}",
              style: TextStyle(color: isSelected ? AppColors.neonGreen : Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientTile(BuildContext context, Ingredient ingredient, CupController controller) {
    final quantity = controller.getQuantity(ingredient);
    final isSelected = quantity > 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: GlassCard(
        opacity: 0.05,
        blur: 10,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Ícone/Cor do Ingrediente
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: ingredient.colorPrimary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ingredient.colorPrimary.withOpacity(0.5)),
              ),
              child: Icon(Icons.fastfood, color: ingredient.colorPrimary, size: 20),
            ),
            const SizedBox(width: 15),
            
            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ingredient.name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  Text(
                    ingredient.price == 0 ? "Grátis" : "+ R\$ ${ingredient.price.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
            ),

            // Controles de Quantidade
            if (!isSelected)
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.white54),
                onPressed: () => controller.incrementIngredient(ingredient),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: AppColors.neonGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.neonGreen.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 18, color: Colors.white),
                      onPressed: () => controller.decrementIngredient(ingredient),
                      constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
                      padding: EdgeInsets.zero,
                    ),
                    Text(
                      "$quantity",
                      style: const TextStyle(color: AppColors.neonGreen, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 18, color: Colors.white),
                      onPressed: () => controller.incrementIngredient(ingredient),
                      constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ).animate().fadeIn().scale(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, CupController controller) {
    return GlassCard(
      blur: 20,
      opacity: 0.9, // Mais opaco para dar leitura
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Total a pagar", style: TextStyle(color: Colors.black54, fontSize: 12)),
                Text(
                  "R\$ ${controller.totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: AppColors.acaiPurple,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Ação de adicionar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Adicionado à sacola!")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.acaiPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                ),
                child: const Text(
                  "ADICIONAR", 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}