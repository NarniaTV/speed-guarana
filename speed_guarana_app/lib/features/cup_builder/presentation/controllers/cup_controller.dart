import 'package:flutter/material.dart';
import '../../domain/models/ingredient.dart';

class CupController extends ChangeNotifier {
  // Lista de camadas do copo (do fundo para o topo)
  final List<Ingredient> _layers = [];
  
  double _totalPrice = 15.00; // Preço base do copo vazio (ex: 500ml)

  List<Ingredient> get layers => List.unmodifiable(_layers);
  double get totalPrice => _totalPrice;
  
  // Limite de camadas para não transbordar o copo
  static const int maxLayers = 8; 

  void addLayer(Ingredient ingredient) {
    if (_layers.length >= maxLayers) {
      // Aqui poderíamos emitir um erro/aviso, mas por hora só ignoramos
      return;
    }
    
    _layers.add(ingredient);
    _totalPrice += ingredient.price;
    notifyListeners(); // Avisa a UI para redesenhar
  }

  void removeLastLayer() {
    if (_layers.isNotEmpty) {
      final removed = _layers.removeLast();
      _totalPrice -= removed.price;
      notifyListeners();
    }
  }

  void resetCup() {
    _layers.clear();
    _totalPrice = 15.00; // Reseta para o preço base
    notifyListeners();
  }
}