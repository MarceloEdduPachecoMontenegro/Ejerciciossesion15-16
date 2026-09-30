import 'package:flutter/material.dart';

class EstadoCarga extends StatelessWidget {
  final String mensaje;
  const EstadoCarga({
    super.key,
    this.mensaje = 'Consultando el servicio de la OMS...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(mensaje, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class EstadoError extends StatelessWidget {
  final String mensaje;
  final VoidCallback alReintentar;

  const EstadoError({
    super.key,
    required this.mensaje,
    required this.alReintentar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off, size: 56, color: Colors.redAccent),
          const SizedBox(height: 16),
          const Text('Error de conexión',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(mensaje, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: alReintentar,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

class EstadoVacio extends StatelessWidget {
  const EstadoVacio({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No hay datos disponibles para mostrar.'),
    );
  }
}