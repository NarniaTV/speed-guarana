import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart'; //

// Imports do seu projeto
import '../../cup_builder/presentation/controllers/wizard_controller.dart';
import '../../cup_builder/';

class LiveCupAnimation extends StatefulWidget {
  final WizardController controller; 

  const LiveCupAnimation({super.key, required this.controller});

  @override
  State<LiveCupAnimation> createState() => _LiveCupAnimationState();
}

class _LiveCupAnimationState extends State<LiveCupAnimation> {
  Artboard? _riveArtboard;
  StateMachineController? _controller;
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
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initRive() async {
    try {
      // Carrega o arquivo
      final bytes = await rootBundle.load('assets/rive/cup_v1.riv');
      final file = RiveFile.import(bytes);
      final artboard = file.mainArtboard;
      
      // Conecta a State Machine (Verifique se o nome no Rive é 'MixingState')
      final controller = StateMachineController.fromArtboard(artboard, 'MixingState');

      if (controller != null) {
        artboard.addController(controller);
        _controller = controller;
      }

      setState(() {
        _riveArtboard = artboard;
        _isLoaded = true;
      });
      
      // Sincroniza estado inicial
      _onStateChange();
    } catch (e) {
      debugPrint('🚨 RIVE ERROR: $e');
    }
  }

  // Helper: Converte ID do ingrediente (String) para Número do Rive
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
    if (!_isLoaded || _controller == null) return;

    final wizard = widget.controller;

    // 1. Atualiza Tamanho (Input: CupSize)
    final sizeIndex = wizard.tempSize.id.index + 1.0;
    final sizeInput = _controller!.findInput<SMINumber>('CupSize');
    if (sizeInput != null && sizeInput.value != sizeIndex) {
      sizeInput.value = sizeIndex;
    }

    // 2. Atualiza Base (Input: BaseType)
    final baseId = wizard.tempBase?.id;
    final baseVal = baseId != null ? _mapIngredientIdToRive(baseId) : 0.0;
    final baseInput = _controller!.findInput<SMINumber>('BaseType');
    if (baseInput != null && baseInput.value != baseVal) {
      baseInput.value = baseVal;
    }

    // 3. Toppings e Slots
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
    
    final s1Input = _controller!.findInput<SMINumber>('Slot1_Id');
    if (s1Input != null && s1Input.value != slot1Val) {
      s1Input.value = slot1Val;
      hasChanged = true;
    }

    final s2Input = _controller!.findInput<SMINumber>('Slot2_Id');
    if (s2Input != null && s2Input.value != slot2Val) {
      s2Input.value = slot2Val;
      hasChanged = true;
    }

    // 4. Dispara Trigger de Física
    if (hasChanged) {
      _controller!.findInput<SMITrigger>('TriggerDrop')?.fire();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: double.infinity,
      child: !_isLoaded || _riveArtboard == null
          ? const Center(child: CircularProgressIndicator(color: Colors.purple))
          : Rive(
              artboard: _riveArtboard!,
              fit: BoxFit.contain,
            ),
    );
  }
}