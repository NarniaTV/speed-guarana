import 'package:flutter/material.dart';
import 'app_colors.dart';
// import 'package:google_fonts/google_fonts.dart'; // Descomente após instalar google_fonts

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundBlack,
      primaryColor: AppColors.acaiPurple,
      
      // Esquema de Cores (Material 3)
      colorScheme: const ColorScheme.dark(
        primary: AppColors.neonGreen,    // Botões e Ações principais
        secondary: AppColors.guaranaRed, // Detalhes e Alertas
        surface: AppColors.surfaceDark,
        background: AppColors.backgroundBlack,
      ),

      // Tipografia (Descomente se tiver o pacote google_fonts)
      /*
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: AppColors.textSecondary),
      ),
      */

      // Estilo Padrão dos Botões
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonGreen,
          foregroundColor: Colors.black, // Texto preto no botão neon para contraste
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      
      // Estilo dos Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.neonGreen), // Brilha quando focado
        ),
      ),
    );
  }
}