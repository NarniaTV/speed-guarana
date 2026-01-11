import 'package:flutter/material.dart';

class Ingredient {
  final String id;
  final String name;
  final double price;
  final Color color; // A cor que vai aparecer no copo visual
  final String type; // 'base' (açaí/cupuaçu) ou 'topping' (adicional)

  const Ingredient({
    required this.id,
    required this.name,
    required this.price,
    required this.color,
    required this.type,
  });
}

// Dados de teste para começarmos rápido
final List<Ingredient> mockIngredients = [
  // Bases
  const Ingredient(id: '1', name: 'Açaí Tradicional', price: 0.0, color: Color(0xFF4B0082), type: 'base'),
  const Ingredient(id: '2', name: 'Cupuaçu', price: 0.0, color: Color(0xFFFAFAD2), type: 'base'),
  
  // Adicionais
  const Ingredient(id: '3', name: 'Leite em Pó', price: 2.0, color: Color(0xFFFFFDD0), type: 'topping'),
  const Ingredient(id: '4', name: 'Paçoca', price: 1.5, color: Color(0xFFD2691E), type: 'topping'),
  const Ingredient(id: '5', name: 'Morango', price: 3.0, color: Color(0xFFFF0000), type: 'topping'),
  const Ingredient(id: '6', name: 'Banana', price: 1.0, color: Color(0xFFFFE135), type: 'topping'),
  const Ingredient(id: '7', name: 'Leite Cond.', price: 2.5, color: Color(0xFFF0E68C), type: 'topping'),
  const Ingredient(id: '8', name: 'Granola', price: 1.5, color: Color(0xFFDEB887), type: 'topping'),
];