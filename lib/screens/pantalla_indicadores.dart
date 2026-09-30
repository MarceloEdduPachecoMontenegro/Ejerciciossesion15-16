import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/indicador_higiene.dart';
import '../services/higiene_api_service.dart';
import '../widgets/estados_vista.dart';
import '../widgets/app_layout.dart';

class PantallaIndicadores extends StatefulWidget {
  const PantallaIndicadores({super.key});

  @override
  State<PantallaIndicadores> createState() => _PantallaIndicadoresState();
}

class _PantallaIndicadoresState extends State<PantallaIndicadores> {
  late final HigieneApiService _servicio;
  late Future<List<IndicadorHigiene>> _futuroIndicadores;

  // Estado local para controlar el filtro en memoria (Ejercicio 3)
  bool _soloDesde2015 = false;

  @override
  void initState() {
    super.initState();
    _servicio = HigieneApiService();
    _futuroIndicadores = _servicio.obtenerIndicadoresPeru(); // Una sola petición HTTP
  }

  @override
  void dispose() {
    _servicio.cerrar();
    super.dispose();
  }

  void _recargar() {
    setState(() {
      _futuroIndicadores = _servicio.obtenerIndicadoresPeru();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contexto OMS - Perú'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _recargar,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: AppLayout(
        child: Column(
          children: [
            // Control visual del filtro (Switch)[cite: 6, 9]
            SwitchListTile(
              title: const Text(
                'Mostrar solo desde 2015',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              subtitle: const Text('Filtrado en memoria sobre la lista descargada'),
              value: _soloDesde2015,
              onChanged: (bool valor) {
                setState(() {
                  _soloDesde2015 = valor; // Solo redibuja la lista, NO vuelve a consultar la red[cite: 6, 9]
                });
              },
            ),
            const Divider(),

            // FutureBuilder con el filtrado en el punto 3 (Datos)[cite: 6, 9]
            Expanded(
              child: FutureBuilder<List<IndicadorHigiene>>(
                future: _futuroIndicadores,
                builder: (context, snapshot) {
                  // 1. Estado de carga
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const EstadoCarga();
                  }

                  // 2. Estado de error[cite: 6]
                  if (snapshot.hasError) {
                    return EstadoError(
                      mensaje: '${snapshot.error}',
                      alReintentar: _recargar,
                    );
                  }

                  // 3. Estado de Datos[cite: 6, 9]
                  final indicadores = snapshot.data ?? const <IndicadorHigiene>[];
                  if (indicadores.isEmpty) return const EstadoVacio();

                  // --- FILTRADO EN MEMORIA (Pista del Ejercicio 3) ---[cite: 6, 9]
                  final List<IndicadorHigiene> visibles = _soloDesde2015
                      ? indicadores.where((i) => i.anio >= 2015).toList()[cite: 9]
                      : indicadores;

                  if (visibles.isEmpty) {
                    return const Center(
                      child: Text('No hay registros a partir del año 2015.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: visibles.length,
                    itemBuilder: (context, index) {
                      final ind = visibles[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text('${ind.anio}'),
                          ),
                          title: Text('Ámbito: ${ind.ambito}'),
                          subtitle: Text('Cumplimiento: ${ind.valorTexto}'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            context.push(
                              '/indicadores/${ind.anio}',
                              extra: ind,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}