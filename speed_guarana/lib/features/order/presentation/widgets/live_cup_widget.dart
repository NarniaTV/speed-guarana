import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import '../controllers/wizard_controller.dart';

class LiveCupWidget extends StatefulWidget {
  final WizardController controller;

  const LiveCupWidget({super.key, required this.controller});

  @override
  State<LiveCupWidget> createState() => _LiveCupWidgetState();
}

class _LiveCupWidgetState extends State<LiveCupWidget> {
  Artboard? _riveArtboard;
  StateMachineController? _controller;
  
  // Inputs do Rive
  SMIInput<double>? _cupSizeInput;
  SMIInput<double>? _slot1IdInput;
  SMITrigger? _slot1AddTrigger;
  SMIInput<double>? _slot2IdInput;
  SMITrigger? _slot2AddTrigger;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
    widget.controller.addListener(_syncRiveWithController);
  }

  Future<void> _loadRiveFile() async {
    // ATENÇÃO: Certifique-se de ter o arquivo em assets/animations/speed_cup_v1.riv
    // Se não tiver ainda, o código vai tratar o erro suavemente.
    try {
      final data = await rootBundle.load('assets/animations/speed_cup_v1.riv');
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      var controller = StateMachineController.fromArtboard(artboard, 'InteractiveCup');
      
      if (controller != null) {
        artboard.addController(controller);
        _bindInputs(controller);
      }
      setState(() => _riveArtboard = artboard);
    } catch (e) {
      debugPrint('Rive File Not Found: $e');
    }
  }

  void _bindInputs(StateMachineController controller) {
    _controller = controller;
    _cupSizeInput = controller.findInput<double>('CupSize');
    _slot1IdInput = controller.findInput<double>('Slot1_ID');
    _slot1AddTrigger = controller.findInput<bool>('Slot1_Add') as SMITrigger?;
    _slot2IdInput = controller.findInput<double>('Slot2_ID');
    _slot2AddTrigger = controller.findInput<bool>('Slot2_Add') as SMITrigger?;
  }

  void _syncRiveWithController() {
    if (_controller == null) return;
    final state = widget.controller.value;

    // Sincroniza Tamanho
    if (_cupSizeInput?.value != state.sizeIndex.toDouble()) {
       _cupSizeInput?.value = state.sizeIndex.toDouble();
    }

    // Sincroniza Slot 1 (Base)
    if (state.toppings.isNotEmpty) {
      double t1 = state.toppings[0].id.toDouble();
      if (_slot1IdInput?.value != t1) {
        _slot1IdInput?.value = t1;
        _slot1AddTrigger?.fire();
      }
    }

    // Sincroniza Slot 2 (Topo)
    if (state.toppings.length > 1) {
      double t2 = state.toppings[1].id.toDouble();
      if (_slot2IdInput?.value != t2) {
        _slot2IdInput?.value = t2;
        _slot2AddTrigger?.fire();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: double.infinity,
      child: _riveArtboard == null
          ? const Center(
              child: Text(
                "Aguardando Rive Asset...", 
                style: TextStyle(color: Colors.white24),
              ),
            )
          : Rive(artboard: _riveArtboard!, fit: BoxFit.contain),
    );
  }
}