import 'package:flutter/material.dart';
import '../models/oportunidad.dart';
import '../theme/app_theme.dart';
import '../widgets/app_layout.dart';
import '../widgets/tarjeta_base.dart';
import '../widgets/formulario_tarea.dart';
import 'pantalla_cumplimiento.dart';
import 'pantalla_establecimiento.dart';

/// Pantalla de bienvenida de ManosSeguras, actualizada para la Sesión 14
/// con captura y validación de tareas de auditoría mediante Form y TextFormField.
class PantallaBienvenida extends StatefulWidget {
  const PantallaBienvenida({super.key});

  @override
  State<PantallaBienvenida> createState() => _PantallaBienvenidaState();
}

class _PantallaBienvenidaState extends State<PantallaBienvenida> {
  // Lista de tareas registradas (estado local)
  final List<String> _tareasRegistradas = [];

  // Método para abrir el formulario validado dentro de un diálogo modal
  void _abrirFormularioTarea() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva tarea de auditoría'),
        content: FormularioTarea(
          onGuardar: (nuevoTitulo) {
            // El widget padre recibe el dato validado y actualiza su estado
            setState(() {
              _tareasRegistradas.add(nuevoTitulo);
            });

            // Retroalimentación visual al usuario
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tarea "$nuevoTitulo" agregada correctamente'),
                backgroundColor: const Color(0xFF2E7D32),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ManosSeguras')),
      body: SingleChildScrollView(
        child: AppLayout(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Encabezado(),
              const SizedBox(height: 24),
              _TarjetaCincoMomentos(),
              
              // Muestra la lista de tareas creadas solo si existen elementos
              if (_tareasRegistradas.isNotEmpty) ...[
                const SizedBox(height: 24),
                _TarjetaTareasRegistradas(tareas: _tareasRegistradas),
              ],

              const SizedBox(height: 24),
              _BotonComenzar(),
              const SizedBox(height: 12),
              _BotonCumplimiento(),
              const SizedBox(height: 12),
              _BotonAgregarTarea(onPressed: _abrirFormularioTarea),
            ],
          ),
        ),
      ),
      // Botón flotante rápido para abrir el formulario
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirFormularioTarea,
        tooltip: 'Agregar tarea',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _Encabezado extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.clean_hands, color: Colors.white, size: 40),
          const SizedBox(height: 12),
          const Text(
            'ManosSeguras',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Auditoría digital de higiene de manos, alineada a la '
            'RM N.° 255-2016/MINSA y al ODS 3 (Salud y bienestar).',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaCincoMomentos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TarjetaBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.checklist_rtl, color: AppColors.navy),
              SizedBox(width: 8),
              Text(
                'Los 5 Momentos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Instrumento oficial de la OMS para la higiene de manos '
            'en establecimientos de salud.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ...Momento.values.map(
            (m) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 22,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.cyan,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${m.index + 1}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navyDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      m.etiqueta,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta dinámica que muestra las tareas validadas y agregadas por el usuario
class _TarjetaTareasRegistradas extends StatelessWidget {
  final List<String> tareas;

  const _TarjetaTareasRegistradas({required this.tareas});

  @override
  Widget build(BuildContext context) {
    return TarjetaBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.task, color: AppColors.navy),
              SizedBox(width: 8),
              Text(
                'Tareas de Auditoría Creadas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...tareas.map(
            (tarea) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, size: 18, color: Color(0xFF2E7D32)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tarea,
                      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BotonComenzar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const PantallaEstablecimiento(),
            ),
          );
        },
        icon: const Icon(Icons.arrow_forward),
        label: const Text('Comenzar auditoría'),
      ),
    );
  }
}

class _BotonCumplimiento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const PantallaCumplimiento(),
            ),
          );
        },
        icon: const Icon(Icons.bar_chart),
        label: const Text('Ver Panel de Cumplimiento'),
      ),
    );
  }
}

class _BotonAgregarTarea extends StatelessWidget {
  final VoidCallback onPressed;

  const _BotonAgregarTarea({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF194D84),
          foregroundColor: Colors.white,
        ),
        onPressed: onPressed,
        icon: const Icon(Icons.add_task),
        label: const Text('Registrar Nueva Tarea (Sesión 14)'),
      ),
    );
  }
}