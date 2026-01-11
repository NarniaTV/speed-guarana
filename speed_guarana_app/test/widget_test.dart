import 'package:flutter_test/flutter_test.dart';
import 'package:speed_guarana_app/main.dart'; // Importa nosso main atualizado

void main() {
  testWidgets('Smoke test - App inicia na tela correta', (WidgetTester tester) async {
    // 1. Carrega o nosso app (Note que agora chamamos SpeedGuaranaApp e não MyApp)
    await tester.pumpWidget(const SpeedGuaranaApp());

    // 2. Aguarda as animações iniciais (já que usamos flutter_animate)
    await tester.pumpAndSettle();

    // 3. Verifica se o texto "SPEED" ou parte do título está na tela
    // O find.textContaining ajuda quando há quebras de linha (\n)
    expect(find.textContaining('SPEED'), findsOneWidget);
    
    // Verifica se NÃO tem nenhum contador "0" na tela (garante que limpamos o código antigo)
    expect(find.text('0'), findsNothing);
  });
}