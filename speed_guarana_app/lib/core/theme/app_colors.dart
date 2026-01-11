import 'package:flutter/material.dart';

class AppColors {
  // Cores Primárias do Produto
  static const Color acaiPurple = Color(0xFF4B0082); // Roxo Profundo
  static const Color guaranaRed = Color(0xFFB22222); // Vermelho Intenso
  
  // Cores de Interface & Ação
  static const Color neonGreen = Color(0xFF39FF14); // Ação/Confirmar (Gamer vibes)
  static const Color backgroundDark = Color(0xFF121212); // Fundo Dark Mode
  static const Color surfaceGlass = Color(0x1AFFFFFF); // Branco com 10% opacidade para vidro
  
  // Gradientes
  static const LinearGradient mainGradient = LinearGradient(
    colors: [acaiPurple, Color(0xFF2E004F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}