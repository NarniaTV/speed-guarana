import 'package:flutter/material.dart';

enum TextureType {
  base,    // Enche o volume (Massa)
  solid,   // Fica boiando no topo (Amendoim, Granola)
  syrup    // Cobre o topo e escorre (Cobertura)
}

class Ingredient {
  final String id;
  final String name;
  final double price;
  final Color colorPrimary;
  final Color colorSecondary;
  final TextureType type;
  final double volume; // 0.0 a 1.0 (Quanto enche o copo)

  const Ingredient({
    required this.id,
    required this.name,
    required this.price,
    required this.colorPrimary,
    required this.colorSecondary,
    required this.type,
    this.volume = 0.0, // Default para toppings é 0 (não enche, só enfeita)
  });
}

// --- MOCKS ATUALIZADOS ---
final List<Ingredient> mockBases = [
  const Ingredient(
    id: 'b1', name: 'Massa Tradicional', price: 0.0, 
    colorPrimary: Color(0xFFC6A664), colorSecondary: Color(0xFF8B4513), // Bege Ouro
    type: TextureType.base, volume: 0.8 // Enche 80% do copo de cara
  ),
  const Ingredient(
    id: 'b2', name: 'Massa de Açaí', price: 0.0, 
    colorPrimary: Color(0xFF4B0082), colorSecondary: Color(0xFF240046), 
    type: TextureType.base, volume: 0.8
  ),
];

final List<Ingredient> mockToppings = [
  const Ingredient(
    id: 't1', name: 'Amendoim', price: 2.0, 
    colorPrimary: Color(0xFFA0522D), colorSecondary: Color(0xFF654321), 
    type: TextureType.solid
  ),
  const Ingredient(
    id: 't2', name: 'Flocos de Arroz', price: 1.5, 
    colorPrimary: Color(0xFFFFFFFF), colorSecondary: Color(0xFFDDDDDD), 
    type: TextureType.solid
  ),
  const Ingredient(
    id: 't3', name: 'Paçoca', price: 2.0, 
    colorPrimary: Color(0xFFD2691E), colorSecondary: Color(0xFF8B4513), 
    type: TextureType.solid
  ),
];

final List<Ingredient> mockSyrups = [
  const Ingredient(
    id: 's1', name: 'Morango', price: 0.0, 
    colorPrimary: Color(0xFFFF0040), colorSecondary: Color(0xFF990000), 
    type: TextureType.syrup
  ),
  const Ingredient(
    id: 's2', name: 'Chocolate', price: 0.0, 
    colorPrimary: Color(0xFF3E2723), colorSecondary: Color(0xFF1B0000), 
    type: TextureType.syrup
  ),
  const Ingredient(
    id: 's3', name: 'Leite Cond.', price: 2.5, 
    colorPrimary: Color(0xFFFFFDD0), colorSecondary: Color(0xFFE6E6FA), 
    type: TextureType.syrup
  ),
];