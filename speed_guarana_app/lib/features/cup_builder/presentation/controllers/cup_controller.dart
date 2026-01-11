import 'package:flutter/material.dart';
import '../../domain/models/ingredient.dart';
import '../../domain/models/cup_size.dart';

class CupController extends ChangeNotifier {
  // Estado
  CupSize _selectedSize = mockCupSizes[1]; // Começa com 500ml selecionado
  final Map<Ingredient, int> _selectedIngredients = {}; // Ingrediente -> Quantidade

  // Getters
  CupSize get selectedSize => _selectedSize;
  Map<Ingredient, int> get selectedIngredients => Map.unmodifiable(_selectedIngredients);

  double get totalPrice {
    double total = _selectedSize.basePrice;
    _selectedIngredients.forEach((ingredient, quantity) {
      total += (ingredient.price * quantity);
    });
    return total;
  }

  // Actions
  void selectSize(CupSize size) {
    _selectedSize = size;
    notifyListeners();
  }

  void incrementIngredient(Ingredient ingredient) {
    // Regra de Negócio: Se for Base (Massa), só pode ter 1 (ou substitui). 
    // Aqui vamos simplificar: Pode misturar.
    
    if (_selectedIngredients.containsKey(ingredient)) {
      _selectedIngredients[ingredient] = _selectedIngredients[ingredient]! + 1;
    } else {
      _selectedIngredients[ingredient] = 1;
    }
    notifyListeners();
  }

  void decrementIngredient(Ingredient ingredient) {
    if (_selectedIngredients.containsKey(ingredient) && _selectedIngredients[ingredient]! > 0) {
      _selectedIngredients[ingredient] = _selectedIngredients[ingredient]! - 1;
      if (_selectedIngredients[ingredient] == 0) {
        _selectedIngredients.remove(ingredient);
      }
      notifyListeners();
    }
  }
  
  int getQuantity(Ingredient ingredient) {
    return _selectedIngredients[ingredient] ?? 0;
  }

  void reset() {
    _selectedSize = mockCupSizes[1];
    _selectedIngredients.clear();
    notifyListeners();
  }
}