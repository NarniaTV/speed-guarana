import '../../domain/entities/ingredient.dart';

class MenuMockDataSource {
  Future<List<Ingredient>> getIngredients() async {
    await Future.delayed(const Duration(milliseconds: 500)); 
    return [
      // 1. Sabores (Base)
      Ingredient(id: 1, name: "Tradicional", price: 0.0, type: IngredientType.flavor, assetPath: "assets/icons/guarana.png"),
      Ingredient(id: 2, name: "Açaí Puro", price: 2.0, type: IngredientType.flavor, assetPath: "assets/icons/acai.png"),
      Ingredient(id: 3, name: "Misto (50/50)", price: 1.0, type: IngredientType.flavor, assetPath: "assets/icons/mixed.png"),

      // 2. Complementos (Secos)
      Ingredient(id: 10, name: "Amendoim", price: 1.0, type: IngredientType.complement, assetPath: "assets/icons/peanut.png"),
      Ingredient(id: 11, name: "Paçoca", price: 1.5, type: IngredientType.complement, assetPath: "assets/icons/pacoca.png"),
      Ingredient(id: 12, name: "Leite Ninho", price: 2.5, type: IngredientType.complement, assetPath: "assets/icons/powder_milk.png"),
      Ingredient(id: 13, name: "Granola", price: 1.5, type: IngredientType.complement, assetPath: "assets/icons/granola.png"),
      Ingredient(id: 14, name: "Castanha", price: 3.0, type: IngredientType.complement, assetPath: "assets/icons/nut.png"),

      // 3. Coberturas (Molhados/Frutas)
      Ingredient(id: 20, name: "Leite Cond.", price: 2.0, type: IngredientType.topping, assetPath: "assets/icons/condensed_milk.png"),
      Ingredient(id: 21, name: "Morango", price: 3.5, type: IngredientType.topping, assetPath: "assets/icons/strawberry.png"),
      Ingredient(id: 22, name: "Banana", price: 1.5, type: IngredientType.topping, assetPath: "assets/icons/banana.png"),
      Ingredient(id: 23, name: "Mel", price: 2.0, type: IngredientType.topping, assetPath: "assets/icons/honey.png"),
    ];
  }
}
