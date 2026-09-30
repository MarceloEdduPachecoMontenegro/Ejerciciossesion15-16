import 'package:flutter/material.dart';

/// Widget de formulario con estado efímero y validación
class FormularioTarea extends StatefulWidget {
  final void Function(String titulo) onGuardar;

  const FormularioTarea({super.key, required this.onGuardar});

  @override
  State<FormularioTarea> createState() => _FormularioTareaState();
}

class _FormularioTareaState extends State<FormularioTarea> {
  // REQUISITO 1: Form identificado con GlobalKey<FormState>
  final _formKey = GlobalKey<FormState>();

  // REQUISITO 4: Controlador de texto
  final _controladorTitulo = TextEditingController();

  // REQUISITO 4: Liberación obligatoria de memoria en dispose()
  @override
  void dispose() {
    _controladorTitulo.dispose();
    super.dispose();
  }

  // REQUISITO 3: Validar antes de guardar y notificar al padre
  void _guardar() {
    if (_formKey.currentState!.validate()) {
      widget.onGuardar(_controladorTitulo.text.trim());
      Navigator.of(context).pop(); // Cierra el diálogo modal
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // REQUISITO 1: Campo de texto TextFormField
          TextFormField(
            controller: _controladorTitulo,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Título de la tarea',
              hintText: 'Ej. Revisar Guía N.° 4 de ManosSeguras',
              prefixIcon: const Icon(Icons.task_alt),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            // REQUISITO 2: Validator con mensajes específicos
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'El título es obligatorio';
              }
              if (value.trim().length < 3) {
                return 'Debe tener al menos 3 caracteres';
              }
              return null; // El valor es válido
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _guardar,
              icon: const Icon(Icons.save),
              label: const Text('Guardar tarea'),
            ),
          ),
        ],
      ),
    );
  }
}