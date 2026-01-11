import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/order/presentation/controllers/wizard_controller.dart';
import 'features/order/presentation/pages/order_wizard_screen.dart';

void main() {
  runApp(const SpeedGuaranaApp());
}

class SpeedGuaranaApp extends StatelessWidget {
  const SpeedGuaranaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WizardController()),
      ],
      child: MaterialApp(
        title: 'Speed Guaraná',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: const OrderWizardScreen(),
      ),
    );
  }
}
