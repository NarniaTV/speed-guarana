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
    // Ouve as mudanças do Controller
    widget.controller.addListener(_syncRiveWithController);
  }

  Future<void> _loadRiveFile() async {
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
      debugPrint('Rive Asset ainda não encontrado (Ignorar se for o primeiro run).');
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
    
    // CORREÇÃO AQUI: Usando .state em vez de .value
    final state = widget.controller.state; 

    // Sincroniza Tamanho (se tivermos essa lógica no futuro)
    // if (_cupSizeInput?.value != state.sizeIndex.toDouble()) { ... }

    // Agrupa todos os itens visuais (Complementos + Coberturas) para jogar nos Slots
    // O Sabor (Flavor) muda a cor base (implementaremos depois), aqui focamos nos "sólidos"
    final visualItems = [...state.selectedComplements, ...state.selectedToppings];

    // Lógica do Slot 1 (Primeiro item adicionado)
    if (visualItems.isNotEmpty) {
      double t1 = visualItems[0].id.toDouble();
      if (_slot1IdInput?.value != t1) {
        _slot1IdInput?.value = t1;
        _slot1AddTrigger?.fire();
      }
    }

    // Lógica do Slot 2 (Segundo item adicionado - cai por cima)
    if (visualItems.length > 1) {
      double t2 = visualItems[1].id.toDouble();
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
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_drink, size: 60, color: Colors.white.withOpacity(0.1)),
                  const SizedBox(height: 10),
                  Text(
                    "Copo Vivo Carregando...", 
                    style: TextStyle(color: Colors.white.withOpacity(0.3)),
                  ),
                ],
              ),
            )
          : Rive(artboard: _riveArtboard!, fit: BoxFit.contain),
    );
  }
}
