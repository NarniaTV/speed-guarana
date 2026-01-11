enum IngredientType { flavor, complement, topping }

class Ingredient {
  final int id;
  final String name;
  final String assetPath;
  final double price;
  final IngredientType type;

  Ingredient({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.price,
    required this.type,
  });
}