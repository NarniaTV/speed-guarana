import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Imports do Core e Temas
import 'core/theme/app_theme.dart';
import 'core/providers/cart_provider.dart'; 

// Imports das Telas NOVAS (Intro e Wizard)
import 'features/home/presentation/screens/home_screen.dart';
import 'features/home/presentation/screens/intro_screen.dart'; 
import 'features/cup_builder/presentation/screens/order_wizard_screen.dart'; 

import 'package:flutter/material.dart';
// import 'package:rive/rive.dart'; // Adicione este import

// ATENÇÃO: Removi o import do cup_builder_screen.dart pois ele não é mais usado!

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // RiveNative.init(); // Geralmente necessário apenas em versões específicas ou setups desktop
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speed Guaraná',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Tema base escuro como pedido no projeto
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      // Substitua pela sua tela inicial real, ex: IntroScreen() ou HomeScreen()
      home: const Scaffold(
        body: Center(child: Text('Speed Guaraná Iniciado')),
      ),
    );
  }
}



// Configuração de Rotas
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    // 1. Menu Principal
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    
    // 2. Abertura Cinematográfica
    GoRoute(
      path: '/intro',
      builder: (context, state) => const IntroScreen(),
    ),

    // 3. O Mágico de Pedidos (Wizard)
    GoRoute(
      path: '/wizard',
      builder: (context, state) => const OrderWizardScreen(),
    ),

    // --- CORREÇÃO DO ERRO ---
    // Mantemos a rota '/builder' para não quebrar o botão antigo da Home,
    // mas redirecionamos ela para a Intro (experiência nova).
    GoRoute(
      path: '/builder',
      builder: (context, state) => const IntroScreen(), 
    ),
  ],
);

class SpeedGuaranaApp extends StatelessWidget {
  const SpeedGuaranaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Injeta a Sacola no app inteiro
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp.router(
        title: 'Speed Guaraná',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme, 
        routerConfig: _router,
      ),
    );
  }
}