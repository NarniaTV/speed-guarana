import 'package:flutter/material.dart';
import '../../domain/entities/ingredient.dart';

class WizardController extends ChangeNotifier {
  final WizardState value = WizardState();

  // Adiciona ingrediente e notifica a UI (e o Rive)
  void addTopping(Ingredient ingredient) {
    if (value.toppings.length < 2) {
      value.toppings.add(ingredient);
      notifyListeners();
    }
  }

  void setSize(int sizeIndex) {
    value.sizeIndex = sizeIndex;
    notifyListeners();
  }
  
  void reset() {
    value.toppings.clear();
    value.sizeIndex = 0;
    notifyListeners();
  }
}

class WizardState {
  int sizeIndex = 0; // 0: 300ml, 1: 500ml, 2: 700ml
  List<Ingredient> toppings = [];
}