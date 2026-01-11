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
      state.fullMenu = await _dataSource.getIngredients();
    } finally {
      state.isLoading = false;
      notifyListeners();
    }
  }

  // Navegação
  void nextStep() {
    if (state.currentStep == OrderStep.flavor && state.selectedFlavor == null) return;
    
    if (state.currentStep == OrderStep.flavor) {
      state.currentStep = OrderStep.complements;
    } else if (state.currentStep == OrderStep.complements) {
      state.currentStep = OrderStep.toppings;
    } else if (state.currentStep == OrderStep.toppings) {
      state.currentStep = OrderStep.review;
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

  // Seleção
  void selectItem(Ingredient item) {
    switch (item.type) {
      case IngredientType.flavor:
        state.selectedFlavor = item;
        break;
      case IngredientType.complement:
        if (state.selectedComplements.contains(item)) {
          state.selectedComplements.remove(item);
        } else if (state.selectedComplements.length < 2) { // NOVO LIMITE: MAX 2
          state.selectedComplements.add(item);
        }
        break;
      case IngredientType.topping:
        if (state.selectedToppings.contains(item)) {
          state.selectedToppings.remove(item);
        } else if (state.selectedToppings.length < 2) { // MAX 2
          state.selectedToppings.add(item);
        }
        break;
    }
    _calculateTotal();
    notifyListeners();
  }

  void _calculateTotal() {
    double total = 0.0;
    if (state.selectedFlavor != null) total += state.selectedFlavor!.price;
    for (var i in state.selectedComplements) total += i.price;
    for (var i in state.selectedToppings) total += i.price;
    state.totalPrice = total;
  }

  // Ação Final
  void finishOrder(BuildContext context) {
    // Simula envio para API/Impressora Térmica
    debugPrint("=== NOVO PEDIDO SPEED GUARANÁ ===");
    debugPrint("BASE: ${state.selectedFlavor?.name}");
    debugPrint("COMPLEMENTOS: ${state.selectedComplements.map((e) => e.name).join(', ')}");
    debugPrint("COBERTURAS: ${state.selectedToppings.map((e) => e.name).join(', ')}");
    debugPrint("TOTAL: R\$ ${state.totalPrice.toStringAsFixed(2)}");
    debugPrint("=================================");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Pedido Enviado para a Cozinha! 👨‍🍳🚀"),
        backgroundColor: Colors.greenAccent[700],
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Reinicia após 2 segundos
    Future.delayed(const Duration(seconds: 2), () {
      state.selectedFlavor = null;
      state.selectedComplements.clear();
      state.selectedToppings.clear();
      state.currentStep = OrderStep.flavor;
      state.totalPrice = 0.0;
      notifyListeners();
    });
  }

  // Getters de UI
  List<Ingredient> get currentStepItems {
    switch (state.currentStep) {
      case OrderStep.flavor: return state.fullMenu.where((i) => i.type == IngredientType.flavor).toList();
      case OrderStep.complements: return state.fullMenu.where((i) => i.type == IngredientType.complement).toList();
      case OrderStep.toppings: return state.fullMenu.where((i) => i.type == IngredientType.topping).toList();
      default: return [];
    }
  }

  String get stepTitle {
    switch (state.currentStep) {
      case OrderStep.flavor: return "Escolha o Tamanho";
      case OrderStep.complements: return "Complementos (Máx 2)";
      case OrderStep.toppings: return "Cobertura Final (Máx 2)";
      case OrderStep.review: return "Revisão do Pedido";
    }
  }
}

class WizardState {
  bool isLoading = false;
  OrderStep currentStep = OrderStep.flavor;
  double totalPrice = 0.0;
  List<Ingredient> fullMenu = [];
  Ingredient? selectedFlavor;
  List<Ingredient> selectedComplements = [];
  List<Ingredient> selectedToppings = [];
}
