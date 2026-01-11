import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    super.initState();
    // O "Filme" dura 3 segundos e corta para a ação
    Timer(const Duration(seconds: 3), () {
      if (mounted) context.go('/wizard');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF1A0524)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Efeito de texto "entrando em cena"
            Text(
              "Faça seu pedido\nem poucos segundos",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ).animate()
             .fadeIn(duration: 600.ms)
             .moveY(begin: 20, end: 0, curve: Curves.easeOut),

            const SizedBox(height: 20),

            Text(
              "com a Speed Guaraná",
              style: TextStyle(
                color: AppColors.neonGreen,
                fontSize: 18,
                letterSpacing: 2,
              ),
            ).animate(delay: 500.ms)
             .fadeIn()
             .scale(),

            const SizedBox(height: 60),
            
            // Loading sutil
            const SizedBox(
              width: 40, 
              height: 40, 
              child: CircularProgressIndicator(color: AppColors.acaiPurple, strokeWidth: 2)
            ).animate(delay: 1000.ms).fadeIn(),
          ],
        ),
      ),
    );
  }
}