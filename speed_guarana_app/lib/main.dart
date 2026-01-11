import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/screens/home_screen.dart';

void main() {
  runApp(const SpeedGuaranaApp());
}

// Configuração de Rotas Simples (Por enquanto)
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    // Futuras rotas:
    // /client/builder
    // /waiter/pos
    // /admin/dashboard
  ],
);

class SpeedGuaranaApp extends StatelessWidget {
  const SpeedGuaranaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos MultiProvider aqui já prevendo a expansão do App
    return MultiProvider(
      providers: [
        // Futuro: CartProvider(), AuthProvider(), etc.
        Provider(create: (_) => "Estado Inicial"), 
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