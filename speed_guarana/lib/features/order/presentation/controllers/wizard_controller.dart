import 'package:flutter/material.dart';
import '../../data/datasources/menu_mock_datasource.dart';
import '../../domain/entities/ingredient.dart';

enum OrderStep { flavor, complements, toppings, review }

class WizardController extends ChangeNotifier {
  final WizardState state = WizardState();
  final MenuMockDataSource _dataSource = MenuMockDataSource();

  WizardController() {
    _loadMenu();
  }

  Future<void> _loadMenu() async {
    state.isLoading = true;
    notifyListeners();
    try {
      final items = await _dataSource.getIngredients();
      state.fullMenu = items;
    } finally {
      state.isLoading = false;
      notifyListeners();
    }
  }

  // --- Lógica de Navegação ---
  void nextStep() {
    if (state.currentStep == OrderStep.flavor && state.selectedFlavor == null) return;
    
    if (state.currentStep == OrderStep.flavor) {
      state.currentStep = OrderStep.complements;
    } else if (state.currentStep == OrderStep.complements) {
      state.currentStep = OrderStep.toppings;
    } else if (state.currentStep == OrderStep.toppings) {
      state.currentStep = OrderStep.review; // Poderia ir para checkout
    }
    notifyListeners();
  }

  void previousStep() {
    if (state.currentStep == OrderStep.complements) {
      state.currentStep = OrderStep.flavor;
    } else if (state.currentStep == OrderStep.toppings) {
      state.currentStep = OrderStep.complements;
    } else if (state.currentStep == OrderStep.review) {
      state.currentStep = OrderStep.toppings;
    }
    notifyListeners();
  }

  // --- Lógica de Seleção ---
  void selectItem(Ingredient item) {
    switch (item.type) {
      case IngredientType.flavor:
        state.selectedFlavor = item;
        // Se trocar o sabor, pode animar o copo mudando de cor
        break;
      case IngredientType.complement:
        if (state.selectedComplements.contains(item)) {
          state.selectedComplements.remove(item);
        } else if (state.selectedComplements.length < 3) { // Max 3 complementos
          state.selectedComplements.add(item);
        }
        break;
      case IngredientType.topping:
        if (state.selectedToppings.contains(item)) {
          state.selectedToppings.remove(item);
        } else if (state.selectedToppings.length < 2) { // Max 2 coberturas
          state.selectedToppings.add(item);
        }
        break;
    }
    _calculateTotal();
    notifyListeners();
  }

  void _calculateTotal() {
    double total = 10.0; // Preço base do copo vazio
    if (state.selectedFlavor != null) total += state.selectedFlavor!.price;
    for (var i in state.selectedComplements) total += i.price;
    for (var i in state.selectedToppings) total += i.price;
    state.totalPrice = total;
  }
  
  // Filtra o menu para mostrar apenas o que é relevante para o passo atual
  List<Ingredient> get currentStepItems {
    switch (state.currentStep) {
      case OrderStep.flavor:
        return state.fullMenu.where((i) => i.type == IngredientType.flavor).toList();
      case OrderStep.complements:
        return state.fullMenu.where((i) => i.type == IngredientType.complement).toList();
      case OrderStep.toppings:
        return state.fullMenu.where((i) => i.type == IngredientType.topping).toList();
      default:
        return [];
    }
  }

  String get stepTitle {
    switch (state.currentStep) {
      case OrderStep.flavor: return "Escolha a Base";
      case OrderStep.complements: return "Complementos (Máx 3)";
      case OrderStep.toppings: return "Cobertura Final (Máx 2)";
      case OrderStep.review: return "Revisão";
    }
  }
}

class WizardState {
  bool isLoading = false;
  OrderStep currentStep = OrderStep.flavor;
  double totalPrice = 10.0;
  
  List<Ingredient> fullMenu = [];
  
  Ingredient? selectedFlavor;
  List<Ingredient> selectedComplements = [];
  List<Ingredient> selectedToppings = [];
}
