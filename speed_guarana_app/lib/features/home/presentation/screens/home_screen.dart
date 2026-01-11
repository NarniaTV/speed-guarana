import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/glass_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  "SPEED\nGUARANÁ",
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.neonGreen,
                    letterSpacing: 2,
                    height: 1.0,
                  ),
                ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2),
                
                const SizedBox(height: 10),
                Text(
                  "O Ecossistema do Açaí",
                  style: Theme.of(context).textTheme.bodyLarge,
                ).animate().fadeIn(delay: 300.ms),

                const Spacer(),

                // Menu de Módulos (Simulação)
                _buildModuleCard(
                  context,
                  title: "Sou Cliente",
                  subtitle: "Quero montar meu copo",
                  icon: Icons.local_drink_rounded,
                  color: AppColors.acaiPurple,
                  delay: 400,
                ),
                const SizedBox(height: 16),
                _buildModuleCard(
                  context,
                  title: "Garçom / Balcão",
                  subtitle: "PDV Ágil & Pedidos",
                  icon: Icons.point_of_sale,
                  color: AppColors.guaranaRed,
                  delay: 600,
                ),
                const SizedBox(height: 16),
                _buildModuleCard(
                  context,
                  title: "Dono / Admin",
                  subtitle: "Gestão & Dashboard",
                  icon: Icons.dashboard_customize,
                  color: Colors.blueGrey,
                  delay: 800,
                ),
                
                const Spacer(),
                Center(
                  child: Text(
                    "v1.0.0 - Powered by Flutter",
                    style: TextStyle(color: Colors.white30, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int delay,
  }) {
    return GlassCard(
      onTap: () {
        // TODO: Navegar para a rota específica
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Acessando módulo: $title")),
        );
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 1,
                )
              ]
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, color: Colors.white30, size: 16),
        ],
      ),
    ).animate(delay: delay.ms).fadeIn().slideY(begin: 0.2);
  }
}