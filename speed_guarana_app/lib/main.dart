import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Imports do Core e Temas
import 'core/theme/app_theme.dart';
import 'core/providers/cart_provider.dart'; // Importante: Onde mora a sacola

// Imports das Telas
import 'features/home/presentation/screens/home_screen.dart';
import 'features/cup_builder/presentation/screens/cup_builder_screen.dart';

import 'features/home/presentation/screens/intro_screen.dart'; // Importe a Intro
import 'features/cup_builder/presentation/screens/order_wizard_screen.dart'; // Importe o Wizard

void main() {
  runApp(const SpeedGuaranaApp());
}

// Configuração de Rotas
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    // Nova Rota para o fluxo rápido (Chamaremos da Home se o cliente clicar em algo específico ou pode substituir o /builder)
    GoRoute(
      path: '/intro',
      builder: (context, state) => const IntroScreen(),
    ),
    GoRoute(
      path: '/wizard',
      builder: (context, state) => const OrderWizardScreen(),
    ),
  ],
);

class SpeedGuaranaApp extends StatelessWidget {
  const SpeedGuaranaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider: Injeta a Sacola (CartProvider) no app inteiro
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp.router(
        title: 'Speed Guaraná',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme, // Nosso tema Dark/Glass
        routerConfig: _router,
      ),
    );
  }
}