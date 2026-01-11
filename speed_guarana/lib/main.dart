import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const SpeedGuaranaApp());
}

class SpeedGuaranaApp extends StatelessWidget {
  const SpeedGuaranaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speed Guaraná',
      debugShowCheckedModeBanner: false,
      
      // AQUI ESTÁ A MÁGICA
      theme: AppTheme.darkTheme, 
      themeMode: ThemeMode.dark, // Força o modo escuro
      
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Mise en place pronta!", 
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 20),
              // Botão de teste para ver o Neon
              ElevatedButton(
                onPressed: null, 
                child: Text("Testar Neon"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}