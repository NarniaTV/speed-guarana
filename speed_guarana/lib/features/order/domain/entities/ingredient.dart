class Ingredient {
  final int id;
  final String name;
  final String assetPath; // Para mostrar ícones na lista depois
  final double price;

  Ingredient({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.price,
  });
}