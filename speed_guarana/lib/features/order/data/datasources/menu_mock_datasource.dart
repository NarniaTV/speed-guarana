import '../../domain/entities/ingredient.dart';

class MenuMockDataSource {
  Future<List<Ingredient>> getIngredients() async {
    await Future.delayed(const Duration(milliseconds: 400)); 
    return [
      // 1. Bases (Tradicional)
      Ingredient(id: 1, name: "Tradicional 300ml", price: 8.00, type: IngredientType.flavor, assetPath: "assets/icons/guarana.png"),
      Ingredient(id: 2, name: "Tradicional 500ml", price: 10.00, type: IngredientType.flavor, assetPath: "assets/icons/guarana.png"),
      Ingredient(id: 3, name: "Tradicional 700ml", price: 12.00, type: IngredientType.flavor, assetPath: "assets/icons/guarana.png"),

      // 1. Bases (Açaí - Mais Caro)
      Ingredient(id: 4, name: "Açaí 300ml", price: 10.00, type: IngredientType.flavor, assetPath: "assets/icons/acai.png"),
      Ingredient(id: 5, name: "Açaí 500ml", price: 14.00, type: IngredientType.flavor, assetPath: "assets/icons/acai.png"),
      Ingredient(id: 6, name: "Açaí 700ml", price: 17.00, type: IngredientType.flavor, assetPath: "assets/icons/acai.png"),

      // 2. Complementos (Limite: 2)
      Ingredient(id: 10, name: "Amendoim", price: 1.0, type: IngredientType.complement, assetPath: "assets/icons/peanut.png"),
      Ingredient(id: 11, name: "Paçoca", price: 1.5, type: IngredientType.complement, assetPath: "assets/icons/pacoca.png"),
      Ingredient(id: 12, name: "Leite Ninho", price: 2.5, type: IngredientType.complement, assetPath: "assets/icons/powder_milk.png"),
      Ingredient(id: 13, name: "Granola", price: 1.5, type: IngredientType.complement, assetPath: "assets/icons/granola.png"),
      
      // 3. Coberturas (Limite: 2)
      Ingredient(id: 20, name: "Leite Cond.", price: 2.0, type: IngredientType.topping, assetPath: "assets/icons/condensed_milk.png"),
      Ingredient(id: 21, name: "Morango", price: 3.5, type: IngredientType.topping, assetPath: "assets/icons/strawberry.png"),
      Ingredient(id: 22, name: "Banana", price: 1.5, type: IngredientType.topping, assetPath: "assets/icons/banana.png"),
    ];
  }
}
