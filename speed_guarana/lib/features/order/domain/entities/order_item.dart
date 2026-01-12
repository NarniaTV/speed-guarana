import 'ingredient.dart';

class OrderItem {
  final String id;
  final Ingredient flavor;
  final List<Ingredient> complements;
  final List<Ingredient> toppings;
  final String utensil; // "colher" ou "canudo"
  final double totalPrice;

  OrderItem({
    required this.id,
    required this.flavor,
    required this.complements,
    required this.toppings,
    required this.utensil,
    required this.totalPrice,
  });

  double get price {
    double price = flavor.price;
    for (var complement in complements) {
      price += complement.price;
    }
    for (var topping in toppings) {
      price += topping.price;
    }
    return price;
  }

  OrderItem copyWith({
    String? id,
    Ingredient? flavor,
    List<Ingredient>? complements,
    List<Ingredient>? toppings,
    String? utensil,
    double? totalPrice,
  }) {
    return OrderItem(
      id: id ?? this.id,
      flavor: flavor ?? this.flavor,
      complements: complements ?? this.complements,
      toppings: toppings ?? this.toppings,
      utensil: utensil ?? this.utensil,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
