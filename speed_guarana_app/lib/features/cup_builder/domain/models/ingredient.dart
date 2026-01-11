import 'package:flutter/material.dart';

enum TextureType {
  base,    // A massa do guaraná/açaí (Gradiente denso)
  solid,   // Amendoim, Flocos (Partículas)
  syrup    // Cobertura (Líquido brilhante)
}

class Ingredient {
  final String id;
  final String name;
  final double price;
  final Color colorPrimary;
  final Color colorSecondary; // Para dar efeito de volume/gradiente
  final TextureType type;

  const Ingredient({
    required this.id,
    required this.name,
    required this.price,
    required this.colorPrimary,
    required this.colorSecondary,
    required this.type,
  });
}

// Catálogo Oficial do Guaraná da Amazônia
final List<Ingredient> mockBases = [
  const Ingredient(
    id: 'b1', name: 'Massa Tradicional', price: 0.0, 
    colorPrimary: Color(0xFFD2B48C), colorSecondary: Color(0xFF8B4513), // Bege/Marrom
    type: TextureType.base
  ),
  const Ingredient(
    id: 'b2', name: 'Massa de Açaí', price: 0.0, 
    colorPrimary: Color(0xFF6A0DAD), colorSecondary: Color(0xFF2E003E), // Roxo Profundo
    type: TextureType.base
  ),
];

final List<Ingredient> mockToppings = [
  const Ingredient(
    id: 't1', name: 'Amendoim Torrado', price: 2.0, 
    colorPrimary: Color(0xFFA0522D), colorSecondary: Color(0xFF8B4513), 
    type: TextureType.solid
  ),
  const Ingredient(
    id: 't2', name: 'Flocos de Arroz', price: 1.5, 
    colorPrimary: Color(0xFFFFFFFF), colorSecondary: Color(0xFFE0E0E0), 
    type: TextureType.solid
  ),
  const Ingredient(
    id: 't3', name: 'Granola Crocante', price: 2.5, 
    colorPrimary: Color(0xFFDEB887), colorSecondary: Color(0xFFCD853F), 
    type: TextureType.solid
  ),
];

final List<Ingredient> mockSyrups = [
  const Ingredient(
    id: 's1', name: 'Cobertura Morango', price: 0.0, 
    colorPrimary: Color(0xFFFF0000), colorSecondary: Color(0xFF8B0000), 
    type: TextureType.syrup
  ),
  const Ingredient(
    id: 's2', name: 'Cobertura Chocolate', price: 0.0, 
    colorPrimary: Color(0xFF3E2723), colorSecondary: Color(0xFF1B0000), 
    type: TextureType.syrup
  ),
  const Ingredient(
    id: 's3', name: 'Cobertura Kiwi', price: 0.0, 
    colorPrimary: Color(0xFF76FF03), colorSecondary: Color(0xFF33691E), 
    type: TextureType.syrup
  ),
];