import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/tema_app.dart';

void main() {
  runApp(const ManosSegurasApp());
}

class ManosSegurasApp extends StatelessWidget {
  const ManosSegurasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: temaApp,
      builder: (context, modoActual, _) {
        return MaterialApp.router(
          title: 'ManosSeguras',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          darkTheme: AppTheme.darkTheme,
          themeMode: modoActual,
          routerConfig: appRouter, // Centraliza la navegación declarativa con go_router
        );
      },
    );
  }
}