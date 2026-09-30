import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/indicador_higiene.dart';
import '../screens/pantalla_bienvenida.dart';
import '../screens/pantalla_cumplimiento.dart';
import '../screens/pantalla_establecimiento.dart';
import '../screens/pantalla_indicadores.dart';
import '../screens/pantalla_indicador_detalle.dart';
import '../screens/pantalla_oportunidades.dart';
import '../screens/pantalla_personal.dart';

/// Configuración central de la navegación del proyecto ManosSeguras
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'bienvenida',
      builder: (context, state) => const PantallaBienvenida(),
    ),
    GoRoute(
      path: '/establecimiento',
      name: 'establecimiento',
      builder: (context, state) => const PantallaEstablecimiento(),
    ),
    GoRoute(
      path: '/personal',
      name: 'personal',
      builder: (context, state) => const PantallaPersonal(),
    ),
    GoRoute(
      path: '/oportunidades',
      name: 'oportunidades',
      builder: (context, state) => const PantallaOportunidades(),
    ),
    GoRoute(
      path: '/cumplimiento',
      name: 'cumplimiento',
      builder: (context, state) => const PantallaCumplimiento(),
    ),
    
    // --- RUTA AGREGADA EN EL EJERCICIO 2 ---
    GoRoute(
      path: '/indicadores', // Ruta de la lista de indicadores
      name: 'indicadores', // Nombre de la ruta
      builder: (context, state) => const PantallaIndicadores(),
      routes: <RouteBase>[
        GoRoute(
          path: ':anio', // Parámetro de ruta relativo (sin / inicial)[cite: 6, 9]
          name: 'indicadorDetalle',
          builder: (context, state) {
            // Extracción y validación del parámetro del path[cite: 6, 9]
            final int? anio = int.tryParse(state.pathParameters['anio'] ?? '');[cite: 6, 9]

            // Extracción opcional del objeto enviado por extra
            final IndicadorHigiene? indicador =
                state.extra is IndicadorHigiene
                    ? state.extra as IndicadorHigiene
                    : null;[cite: 6]

            return PantallaIndicadorDetalle(
              anio: anio ?? 0,[cite: 9]
              indicadorInicial: indicador,[cite: 6]
            );
          },
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Ruta no disponible')),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('No existe la ruta: ${state.uri}'),[cite: 6]
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/'),[cite: 6]
            child: const Text('Volver al inicio'),
          ),
        ],
      ),
    ),
  ),
);