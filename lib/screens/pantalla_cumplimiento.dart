import 'package:flutter/material.dart';
import '../models/indicador_momento.dart';

class PantallaCumplimiento extends StatelessWidget {
  const PantallaCumplimiento({super.key});

  final List<IndicadorMomento> indicadores = const [
    IndicadorMomento(nombreMomento: 'Antes de tocar al paciente', porcentajeCumplimiento: 80),
    IndicadorMomento(nombreMomento: 'Antes de tarea aséptica', porcentajeCumplimiento: 65),
    IndicadorMomento(nombreMomento: 'Después de riesgo de fluidos', porcentajeCumplimiento: 90),
    IndicadorMomento(nombreMomento: 'Después de tocar al paciente', porcentajeCumplimiento: 40),
    IndicadorMomento(nombreMomento: 'Después del entorno del paciente', porcentajeCumplimiento: 55),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text(
          'Panel de cumplimiento',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildEncabezadoResponsivo(context),
            const SizedBox(height: 16),
            ...indicadores.map((item) => _buildTarjetaMomento(item)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEncabezadoResponsivo(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 600;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8EEF5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.local_hospital,
                      color: Color(0xFF194D84),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Medicina General',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'UPSS evaluado actualmente',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (isTablet) ...[
                const Divider(height: 24, thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Total Observaciones: 120', style: TextStyle(color: Color(0xFF475569))),
                    Text('Periodo: Septiembre 2026', style: TextStyle(color: Color(0xFF475569))),
                    Text('Estado: Activo', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildTarjetaMomento(IndicadorMomento item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.nombreMomento,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${item.porcentajeCumplimiento}%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildBarraProgresoProporcional(item.porcentajeCumplimiento),
        ],
      ),
    );
  }

  Widget _buildBarraProgresoProporcional(int porcentaje) {
    final int flexLleno = porcentaje.clamp(0, 100);
    final int flexVacio = 100 - flexLleno;

    return Container(
      height: 10,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            if (flexLleno > 0)
              Expanded(
                flex: flexLleno,
                child: Container(color: const Color(0xFF2E7D32)),
              ),
            if (flexVacio > 0)
              Expanded(
                flex: flexVacio,
                child: Container(color: const Color(0xFFF1F5F9)),
              ),
          ],
        ),
      ),
    );
  }
}