import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import '../controllers/wizard_controller.dart';

/// Um widget que carrega e controla uma animação Rive do copo,
/// servindo como uma camada de adaptação entre o `WizardController` e a animação.
class LiveCupWidget extends StatefulWidget {
  final WizardController controller;

  const LiveCupWidget({super.key, required this.controller});

  @override
  State<LiveCupWidget> createState() => _LiveCupWidgetState();
}

class _LiveCupWidgetState extends State<LiveCupWidget> {
  Artboard? _riveArtboard;
  StateMachineController? _stateMachineController;

  // Inputs da Máquina de Estados do Rive (O CONTRATO DE ANIMAÇÃO)
  SMIInput<double>? _flavorInput;
  SMIInput<double>? _syrupInput;
  SMIInput<double>? _toppingInput;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
    widget.controller.addListener(_syncRiveWithController);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncRiveWithController);
    _stateMachineController?.dispose();
    super.dispose();
  }

  Future<void> _loadRiveFile() async {
    try {
      // Carrega o arquivo de animação da pasta de assets.
      final data = await rootBundle.load('assets/animations/realistic_cup.riv');
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      
      // Assumimos que a máquina de estados se chama 'CupStateMachine'.
      _stateMachineController = StateMachineController.fromArtboard(artboard, 'CupStateMachine');
      
      if (_stateMachineController != null) {
        artboard.addController(_stateMachineController!);
        // Mapeia os inputs do Rive para variáveis locais.
        _flavorInput = _stateMachineController!.findInput<double>('flavor');
        _syrupInput = _stateMachineController!.findInput<double>('syrup');
        _toppingInput = _stateMachineController!.findInput<double>('topping');
        
        // Sincroniza o estado inicial da UI com a animação.
        _syncRiveWithController();
      }
      
      if (mounted) {
        setState(() => _riveArtboard = artboard);
      }
    } catch (e) {
      debugPrint('Arquivo Rive (realistic_cup.riv) não encontrado. Por favor, crie-o e adicione aos assets.');
    }
  }

  /// O coração da lógica: traduz o estado do controller para comandos na animação.
  void _syncRiveWithController() {
    if (_stateMachineController == null || !mounted) return;

    final state = widget.controller.state;

    // 1. Controle do Sabor (Flavor)
    final flavorName = state.selectedFlavor?.name.toLowerCase() ?? '';
    if (flavorName.contains('açaí')) {
      _flavorInput?.value = 1;
    } else {
      _flavorInput?.value = 0; // 0 é o padrão (Guaraná Bege)
    }

    // 2. Controle da Calda (Syrup) - Mapeado a partir das Coberturas
    final toppingName = state.selectedToppings.isNotEmpty ? state.selectedToppings.first.name.toLowerCase() : '';
    if (toppingName.contains('leite cond')) {
      _syrupInput?.value = 1; // Calda de Chocolate/Escura
    } else if (toppingName.contains('morango')) {
      _syrupInput?.value = 2; // Calda de Morango
    } else {
      _syrupInput?.value = 0; // Sem calda
    }

    // 3. Controle da Cobertura Sólida - Mapeado a partir dos Complementos
    final complementName = state.selectedComplements.isNotEmpty ? state.selectedComplements.first.name.toLowerCase() : '';
    if (complementName.contains('amendoim') || complementName.contains('paçoca')) {
      _toppingInput?.value = 1;
    } else {
      _toppingInput?.value = 0; // Sem cobertura sólida
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: double.infinity,
      child: _riveArtboard == null
          // Placeholder elegante enquanto o arquivo Rive não é carregado ou não existe.
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.coffee_maker_outlined, size: 60, color: Colors.white.withAlpha(25)),
                const SizedBox(height: 10),
                Text(
                  "Carregando Animação do Copo...", 
                  style: TextStyle(color: Colors.white.withAlpha(77)),
                ),
              ],
            )
          : Rive(artboard: _riveArtboard!, fit: BoxFit.contain),
    );
  }
}
