import 'package:flutter/material.dart';
import '../../features/cup_builder/domain/models/cup_size.dart';
import '../../features/cup_builder/domain/models/ingredient.dart';

class CartItem {
  final String id;
  final CupSize size;
  final Ingredient? base;
  final List<Ingredient> toppings;
  final Ingredient? syrup;
  final String utensil; // "Colher" ou "Canudo"
  final int quantity; // Quantos desse copo o cliente quer
  final double unitPrice;

  CartItem({
    required this.id,
    required this.size,
    required this.base,
    required this.toppings,
    required this.syrup,
    required this.utensil,
    required this.quantity,
    required this.unitPrice,
  });

  double get totalPrice => unitPrice * quantity;
  
  String get description {
    final parts = [
      base?.name ?? 'Sem base',
      if (toppings.isNotEmpty) 'Com: ${toppings.map((e) => e.name).join(', ')}',
      if (syrup != null) 'Cob: ${syrup!.name}',
      '($utensil)'
    ];
    return parts.join(' | ');
  }
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  double get totalCartPrice => _items.fold(0, (sum, item) => sum + item.totalPrice);
  int get totalItemsCount => _items.fold(0, (sum, item) => sum + item.quantity);

  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
  
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}