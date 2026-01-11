import '../../domain/entities/ingredient.dart';

class MenuMockDataSource {
  // Simula uma API ou Banco de Dados com delay
  Future<List<Ingredient>> getIngredients() async {
    await Future.delayed(const Duration(milliseconds: 800)); 
    return [
      Ingredient(id: 1, name: "Paçoca", price: 2.00, assetPath: "assets/icons/peanut.png"),
      Ingredient(id: 2, name: "Leite Cond.", price: 3.50, assetPath: "assets/icons/milk.png"),
      Ingredient(id: 3, name: "Banana", price: 1.50, assetPath: "assets/icons/banana.png"),
      Ingredient(id: 4, name: "Granola", price: 2.50, assetPath: "assets/icons/granola.png"),
      Ingredient(id: 5, name: "Morango", price: 4.00, assetPath: "assets/icons/strawberry.png"),
      Ingredient(id: 6, name: "Leite em Pó", price: 3.00, assetPath: "assets/icons/powder_milk.png"),
    ];
  }
}
