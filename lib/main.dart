import 'package:flutter/material.dart';
import 'screens/pantalla_bienvenida.dart';
import 'theme/app_theme.dart';
import 'theme/tema_app.dart';

/// ManosSeguras — proyecto base integrado de las Guías de Práctica
/// N.° 2, 3 y 4 del curso SIS048 - Desarrollo de Software II (UAC).
///
/// Flujo de navegación:
///   PantallaBienvenida -> PantallaEstablecimiento -> PantallaPersonal
///   -> PantallaOportunidades
///
/// Este archivo es el punto de partida común que todos los equipos
/// reciben ya funcionando antes de la Evaluación de la Unidad I.
///
/// [temaApp] (definido en lib/theme/tema_app.dart) expone el
/// ThemeMode actual (light/dark/system) como un ValueNotifier
/// accesible desde cualquier pantalla, junto con su correspondiente
/// darkTheme (ver lib/theme/app_theme.dart). Esto evita que algún
/// equipo —sin importar qué variante del Anexo 1 le toque por
/// sorteo— necesite convertir la raíz de la app de Stateless a
/// Stateful ni pasar callbacks a través de toda la cadena de
/// navegación durante los 60 minutos de desarrollo.
///
/// Por defecto el modo es ThemeMode.system. Solo el equipo que
/// reciba la Variante D (Configuración y Apariencia) necesita leer
/// y modificar `temaApp.value` desde su pantalla nueva (importando
/// `theme/tema_app.dart`); el resto de equipos puede ignorar por
/// completo esta variable.
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
        return MaterialApp(
          title: 'ManosSeguras',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          darkTheme: AppTheme.darkTheme,
          themeMode: modoActual,
          home: const PantallaBienvenida(),
        );
      },
    );
  }
}
