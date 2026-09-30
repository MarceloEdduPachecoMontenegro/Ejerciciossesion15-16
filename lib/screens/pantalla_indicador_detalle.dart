import 'package:flutter/material.dart';
import '../models/indicador_higiene.dart';

class PantallaIndicadorDetalle extends StatelessWidget {
  final int anio;
  final IndicadorHigiene? indicadorInicial;

  const PantallaIndicadorDetalle({
    super.key,
    required this.anio,
    this.indicadorInicial,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle Año $anio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Indicador OMS: $anio',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (indicadorInicial != null) ...[
              Text('País: ${indicadorInicial!.pais}'),
              Text('Ámbito: ${indicadorInicial!.ambito}'),
              Text('Valor registrado: ${indicadorInicial!.valorTexto}'),
            ] else ...[
              Text('Año consultado directamente desde ruta: $anio'),
            ],
          ],
        ),
      ),
    );
  }
}