import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import '../../controllers/wizard_controller.dart';
import '../../../cup_builder/domain/models/cup_size.dart';

class LiveCupAnimation extends StatefulWidget {
  final WizardController controller;

  const LiveCupAnimation({super.key, required this.controller});

  @override
  State<LiveCupAnimation> createState() => _LiveCupAnimationState();
}

class _LiveCupAnimationState extends State<LiveCupAnimation> {
  // Na v0.14, usamos RiveWidgetController em vez de StateMachineController
  RiveWidgetController? _riveController;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _initRive();
    widget.controller.addListener(_onStateChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onStateChange);
    _riveController?.dispose();
    super.dispose();
  }

  Future<void> _initRive() async {
    try {
      final bytes = await rootBundle.load('assets/rive/cup_v1.riv');
      
      // Nova API de decodificação de arquivo (File.decode)
      final file = await File.decode(bytes, factory: Factory.rive);
      
      // Inicializa o Controller selecionando a State Machine
      final controller = RiveWidgetController(
        file,
        stateMachineSelector: StateMachineSelector.byName('MixingState'),
      );

      setState(() {
        _riveController = controller;
        _isLoaded = true;
      });

      // Sincroniza o estado inicial
      _onStateChange();
    } catch (e) {
      debugPrint('🚨 RIVE ERROR: $e');
    }
  }

  // Helper para converter IDs (t1 -> 1.0)
  double _mapIngredientIdToRive(String id) {
    switch (id) {
      case 'b1': return 1; // Massa Tradicional
      case 'b2': return 2; // Massa Açaí
      case 't1': return 1; // Amendoim
      case 't2': return 2; // Flocos
      case 't3': return 3; // Paçoca
      default: return 0;
    }
  }

  void _onStateChange() {
    // Se o controller ou a state machine não estiverem prontos, aborta
    if (!_isLoaded || _riveController == null) return;

    final sm = _riveController!.stateMachine;
    if (sm == null) return;

    final wizard = widget.controller;

    // --- 1. Atualiza Tamanho (Number Input) ---
    // Sintaxe Nova: sm.number('Nome').value = X
    final sizeIndex = wizard.tempSize.id.index + 1.0;
    final sizeInput = sm.number('CupSize');
    if (sizeInput != null && sizeInput.value != sizeIndex) {
      sizeInput.value = sizeIndex;
    }

    // --- 2. Atualiza Base ---
    final baseId = wizard.tempBase?.id;
    final baseVal = baseId != null ? _mapIngredientIdToRive(baseId) : 0.0;
    final baseInput = sm.number('BaseType');
    if (baseInput != null && baseInput.value != baseVal) {
      baseInput.value = baseVal;
    }

    // --- 3. Toppings e Slots ---
    final toppings = wizard.tempToppings;
    double slot1Val = 0;
    double slot2Val = 0;

    if (toppings.isNotEmpty) {
      slot1Val = _mapIngredientIdToRive(toppings[0].id);
    }
    if (toppings.length >= 2) {
      slot2Val = _mapIngredientIdToRive(toppings[1].id);
    }

    bool hasChanged = false;
    
    final s1Input = sm.number('Slot1_Id');
    if (s1Input != null && s1Input.value != slot1Val) {
      s1Input.value = slot1Val;
      hasChanged = true;
    }

    final s2Input = sm.number('Slot2_Id');
    if (s2Input != null && s2Input.value != slot2Val) {
      s2Input.value = slot2Val;
      hasChanged = true;
    }

    // --- 4. Dispara Trigger (Física) ---
    if (hasChanged) {
      sm.trigger('TriggerDrop')?.fire();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: double.infinity,
      child: !_isLoaded || _riveController == null
          ? const Center(child: CircularProgressIndicator(color: Colors.purple))
          : RiveWidget(
              controller: _riveController!,
              fit: BoxFit.contain,
            ),
    );
  }
}