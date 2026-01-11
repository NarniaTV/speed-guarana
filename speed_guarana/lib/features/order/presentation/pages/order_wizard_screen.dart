import 'package:flutter/material.dart';
import '../../domain/entities/ingredient.dart';
import '../controllers/wizard_controller.dart';
import '../widgets/live_cup_widget.dart';

class OrderWizardScreen extends StatefulWidget {
  const OrderWizardScreen({super.key});

  @override
  State<OrderWizardScreen> createState() => _OrderWizardScreenState();
}

class _OrderWizardScreenState extends State<OrderWizardScreen> {
  final _controller = WizardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Monte seu Speed")),
      body: Column(
        children: [
          // Área do Copo (40% da tela)
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.black, // Fundo para destacar
              child: LiveCupWidget(controller: _controller),
            ),
          ),
          
          // Área de Controles (60% da tela)
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const Text("Escolha seus Adicionais", style: TextStyle(fontSize: 20, color: Colors.white)),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildBtn("Paçoca", 1),
                      _buildBtn("Leite Cond.", 2),
                      _buildBtn("Banana", 3),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _controller.reset,
                    child: const Text("Limpar Copo"),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBtn(String name, int id) {
    return ActionChip(
      label: Text(name),
      onPressed: () {
        _controller.addTopping(
          Ingredient(id: id, name: name, price: 2.0, assetPath: ''),
        );
      },
    );
  }
}