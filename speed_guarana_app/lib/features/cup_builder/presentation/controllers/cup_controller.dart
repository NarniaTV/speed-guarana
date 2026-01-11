import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // Adicione ao pubspec: uuid: ^3.0.7 (ou use DateTime)
import '../../domain/models/ingredient.dart';
import '../../domain/models/cup_size.dart';
import '../../../../core/providers/cart_provider.dart';

class CupController extends ChangeNotifier {
  // Estado do Builder
  CupSize _selectedSize = mockCupSizes[1]; 
  Ingredient? _selectedBase;
  final List<Ingredient> _selectedToppings = [];
  Ingredient? _selectedSyrup;
  String _selectedUtensil = "Colher"; // Padrão
  
  // Quantidade de copos IGUAIS a este que serão adicionados
  int _cupQuantity = 1;

  // Getters
  CupSize get selectedSize => _selectedSize;
  Ingredient? get selectedBase => _selectedBase;
  List<Ingredient> get selectedToppings => List.unmodifiable(_selectedToppings);
  Ingredient? get selectedSyrup => _selectedSyrup;
  String get selectedUtensil => _selectedUtensil;
  int get cupQuantity => _cupQuantity;

  // Preço UNITÁRIO (de 1 copo)
  double get unitPrice {
    double total = _selectedSize.basePrice;
    // Bases e Caldas no nosso modelo Mock eram grátis, mas se tiverem preço, soma aqui
    if (_selectedBase != null) total += _selectedBase!.price;
    if (_selectedSyrup != null) total += _selectedSyrup!.price;
    
    for (var t in _selectedToppings) {
      total += t.price;
    }
    return total;
  }

  // Preço TOTAL (unitário * quantidade)
  double get totalPrice => unitPrice * _cupQuantity;

  // --- ACTIONS ---

  void selectSize(CupSize size) {
    _selectedSize = size;
    notifyListeners();
  }

  // Lógica Base: Apenas 1 (Radio)
  void selectBase(Ingredient base) {
    if (_selectedBase == base) return; // Já selecionado
    _selectedBase = base;
    notifyListeners();
  }

  // Lógica Crocantes: Max 2 (Checkbox Limitado)
  void toggleTopping(Ingredient topping) {
    if (_selectedToppings.contains(topping)) {
      _selectedToppings.remove(topping);
    } else {
      if (_selectedToppings.length < 2) {
        _selectedToppings.add(topping);
      } else {
        // Opcional: Avisar UI que chegou no limite (via callback ou estado extra)
      }
    }
    notifyListeners();
  }

  // Lógica Cobertura: Max 1 (Radio Toggle)
  void toggleSyrup(Ingredient syrup) {
    if (_selectedSyrup == syrup) {
      _selectedSyrup = null; // Permite desmarcar
    } else {
      _selectedSyrup = syrup;
    }
    notifyListeners();
  }

  void setUtensil(String type) {
    _selectedUtensil = type;
    notifyListeners();
  }

  void incrementQuantity() {
    _cupQuantity++;
    notifyListeners();
  }

  void decrementQuantity() {
    if (_cupQuantity > 1) {
      _cupQuantity--;
      notifyListeners();
    }
  }

  // Gerar o objeto para o Carrinho
  CartItem? buildCartItem() {
    if (_selectedBase == null) return null; // Validação mínima

    return CartItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // ID simples
      size: _selectedSize,
      base: _selectedBase,
      toppings: List.from(_selectedToppings),
      syrup: _selectedSyrup,
      utensil: _selectedUtensil,
      quantity: _cupQuantity,
      unitPrice: unitPrice,
    );
  }

  void reset() {
    _selectedSize = mockCupSizes[1];
    _selectedBase = null;
    _selectedToppings.clear();
    _selectedSyrup = null;
    _selectedUtensil = "Colher";
    _cupQuantity = 1;
    notifyListeners();
  }
}