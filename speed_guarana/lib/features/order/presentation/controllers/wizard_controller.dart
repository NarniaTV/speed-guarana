import 'package:flutter/material.dart';
import '../../data/datasources/menu_mock_datasource.dart';
import '../../domain/entities/ingredient.dart';

class WizardController extends ChangeNotifier {
  final WizardState value = WizardState();
  final MenuMockDataSource _dataSource = MenuMockDataSource();

  WizardController() {
    _loadMenu();
  }

  Future<void> _loadMenu() async {
    value.isLoading = true;
    notifyListeners();

    try {
      final items = await _dataSource.getIngredients();
      value.menu = items;
    } catch (e) {
      debugPrint("Erro ao carregar menu: $e");
    } finally {
      value.isLoading = false;
      notifyListeners();
    }
  }

  void addTopping(Ingredient ingredient) {
    // Regra: Máximo 2 adicionais
    if (value.selectedToppings.length < 2) {
      value.selectedToppings.add(ingredient);
      _calculateTotal();
      notifyListeners();
    }
  }

  void removeTopping(Ingredient ingredient) {
    value.selectedToppings.removeWhere((item) => item.id == ingredient.id);
    _calculateTotal();
    notifyListeners();
  }

  void setSize(int sizeIndex) {
    value.sizeIndex = sizeIndex;
    _calculateTotal();
    notifyListeners();
  }
  
  void reset() {
    value.selectedToppings.clear();
    value.sizeIndex = 0;
    value.totalPrice = 10.0;
    notifyListeners();
  }

  void _calculateTotal() {
    double basePrice = 10.0 + (value.sizeIndex * 5.0); // 10, 15, 20
    double toppingsPrice = value.selectedToppings.fold(0, (sum, item) => sum + item.price);
    value.totalPrice = basePrice + toppingsPrice;
  }
}

class WizardState {
  bool isLoading = false;
  int sizeIndex = 0;
  double totalPrice = 10.0;
  List<Ingredient> menu = [];
  List<Ingredient> selectedToppings = [];
}
