import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../domain/models/cup_size.dart';
import '../../domain/models/ingredient.dart';

enum WizardStep { quantity, size, base, toppings, syrup, utensil, review }

class WizardController extends ChangeNotifier {
  // --- ESTADO GERAL ---
  WizardStep _currentStep = WizardStep.quantity;
  int _totalCupsWanted = 1;
  int _currentCupIndex = 1; // "Pedido 1", "Pedido 2"...
  
  // Lista de copos já finalizados nesta sessão
  final List<CartItem> _completedCups = [];

  // --- ESTADO DO COPO ATUAL (Sendo montado) ---
  CupSize _tempSize = mockCupSizes[1];
  Ingredient? _tempBase;
  final List<Ingredient> _tempToppings = [];
  Ingredient? _tempSyrup;
  String _tempUtensil = "Colher";

  // --- GETTERS ---
  WizardStep get currentStep => _currentStep;
  int get totalCupsWanted => _totalCupsWanted;
  int get currentCupIndex => _currentCupIndex;
  List<CartItem> get completedCups => List.unmodifiable(_completedCups);

  // Getters do Copo Atual
  CupSize get tempSize => _tempSize;
  Ingredient? get tempBase => _tempBase;
  List<Ingredient> get tempToppings => List.unmodifiable(_tempToppings);
  Ingredient? get tempSyrup => _tempSyrup;
  String get tempUtensil => _tempUtensil;

  // --- LÓGICA DE FLUXO ---

  void setQuantity(int qty) {
    _totalCupsWanted = qty;
    _currentStep = WizardStep.size; // Avança automático
    notifyListeners();
  }

  void selectSize(CupSize size) {
    _tempSize = size;
    _currentStep = WizardStep.base; // Avança
    notifyListeners();
  }

  void selectBase(Ingredient base) {
    _tempBase = base;
    _currentStep = WizardStep.toppings; // Avança
    notifyListeners();
  }

  void toggleTopping(Ingredient topping) {
    if (_tempToppings.contains(topping)) {
      _tempToppings.remove(topping);
    } else {
      if (_tempToppings.length < 2) {
        _tempToppings.add(topping);
      }
    }
    notifyListeners();
  }

  void nextFromToppings() {
    _currentStep = WizardStep.syrup;
    notifyListeners();
  }

  void toggleSyrup(Ingredient syrup) {
    // Regra: Clicou, selecionou e avança (Speed)
    // Se quiser permitir "sem cobertura", teria que ter um botão "Pular" na UI
    if (_tempSyrup == syrup) {
        _tempSyrup = null; 
    } else {
        _tempSyrup = syrup;
        // Opcional: _currentStep = WizardStep.utensil; (Se quiser ultra speed)
    }
    notifyListeners();
  }

  void nextFromSyrup() {
    _currentStep = WizardStep.utensil;
    notifyListeners();
  }

  void selectUtensil(String type) {
    _tempUtensil = type;
    _finishCurrentCup(); // Finaliza este copo
  }

  // --- FINALIZA O COPO ATUAL E DECIDE O PRÓXIMO PASSO ---
  void _finishCurrentCup() {
    // 1. Cria o item do carrinho (mas guarda na memória local por enquanto)
    final cartItem = CartItem(
      id: const Uuid().v4(),
      size: _tempSize,
      base: _tempBase, // Pode ser null se não escolheu (mas vamos validar na UI)
      toppings: List.from(_tempToppings),
      syrup: _tempSyrup,
      utensil: _tempUtensil,
      quantity: 1, // Unitário, pois estamos montando um por um
      unitPrice: _calculateCurrentPrice(),
    );

    _completedCups.add(cartItem);

    // 2. Decide para onde ir
    if (_currentCupIndex < _totalCupsWanted) {
      // Ainda faltam copos
      _currentCupIndex++;
      _resetTempCup(); // Limpa as escolhas para o próximo
      _currentStep = WizardStep.size; // Volta para o início da montagem
    } else {
      // Acabaram os copos
      _currentStep = WizardStep.review;
    }
    notifyListeners();
  }

  void _resetTempCup() {
    _tempSize = mockCupSizes[1];
    _tempBase = null;
    _tempToppings.clear();
    _tempSyrup = null;
    _tempUtensil = "Colher";
  }

  double _calculateCurrentPrice() {
    double total = _tempSize.basePrice;
    if (_tempBase != null) total += _tempBase!.price;
    if (_tempSyrup != null) total += _tempSyrup!.price;
    for (var t in _tempToppings) total += t.price;
    return total;
  }

  // --- RESET TOTAL ---
  void restartFlow() {
    _currentStep = WizardStep.quantity;
    _totalCupsWanted = 1;
    _currentCupIndex = 1;
    _completedCups.clear();
    _resetTempCup();
    notifyListeners();
  }
}