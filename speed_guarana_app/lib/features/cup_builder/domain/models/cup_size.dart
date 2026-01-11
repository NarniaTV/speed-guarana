enum CupSizeOption { small, medium, large }

class CupSize {
  final CupSizeOption id;
  final String label;
  final String description;
  final double basePrice;

  const CupSize({
    required this.id,
    required this.label,
    required this.description,
    required this.basePrice,
  });
}

final List<CupSize> mockCupSizes = [
  const CupSize(id: CupSizeOption.small, label: '300ml', description: 'Pequeno', basePrice: 12.00),
  const CupSize(id: CupSizeOption.medium, label: '500ml', description: 'O preferido', basePrice: 16.00),
  const CupSize(id: CupSizeOption.large, label: '700ml', description: 'Para dividir (ou não)', basePrice: 22.00),
];