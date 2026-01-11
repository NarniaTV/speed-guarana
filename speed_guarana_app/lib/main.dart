import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Imports do Core e Temas
import 'core/theme/app_theme.dart';
import 'core/providers/cart_provider.dart'; // Importante: Onde mora a sacola

// Imports das Telas
import 'features/home/presentation/screens/home_screen.dart';
import 'features/cup_builder/presentation/screens/cup_builder_screen.dart';

void main() {
  runApp(const SpeedGuaranaApp());
}

// Configuração de Rotas
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    // Rota Inicial (Menu)
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    // Rota de Montagem (Módulo Cliente)
    GoRoute(
      path: '/builder',
      builder: (context, state) => const CupBuilderScreen(),
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