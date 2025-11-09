import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/empleado_controller.dart';
import '../../domain/entities/empleado_entity.dart';

class EmpleadoFormPage extends StatefulWidget {
  final String fincaId;
  final EmpleadoEntity? empleado;

  const EmpleadoFormPage({
    Key? key,
    required this.fincaId,
    this.empleado,
  }) : super(key: key);

  @override
  State<EmpleadoFormPage> createState() => _EmpleadoFormPageState();
}

class _EmpleadoFormPageState extends State<EmpleadoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _cargoController = TextEditingController();
  final _salarioController = TextEditingController();
  
  TipoEmpleado _tipoEmpleado = TipoEmpleado.temporal;
  bool _activo = true;
  DateTime _fechaContratacion = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.empleado != null) {
      _nombreController.text = widget.empleado!.nombre;
      _cedulaController.text = widget.empleado!.cedula;
      _cargoController.text = widget.empleado!.cargo ?? '';
      _salarioController.text = widget.empleado!.salario?.toString() ?? '';
      _tipoEmpleado = widget.empleado!.tipoEmpleado;
      _activo = widget.empleado!.activo;
      _fechaContratacion = widget.empleado!.fechaContratacion;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _cedulaController.dispose();
    _cargoController.dispose();
    _salarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmpleadoController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.empleado == null ? 'Nuevo Empleado' : 'Editar Empleado'),
        backgroundColor: const Color(0xFF27AE60),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre completo *',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El nombre es requerido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cedulaController,
              decoration: const InputDecoration(
                labelText: 'Cédula *',
                prefixIcon: Icon(Icons.badge),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La cédula es requerida';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TipoEmpleado>(
              value: _tipoEmpleado,
              decoration: const InputDecoration(
                labelText: 'Tipo de empleado *',
                prefixIcon: Icon(Icons.work),
                border: OutlineInputBorder(),
              ),
              items: TipoEmpleado.values.map((tipo) {
                return DropdownMenuItem(
                  value: tipo,
                  child: Text(tipo.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _tipoEmpleado = value);
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cargoController,
              decoration: const InputDecoration(
                labelText: 'Cargo',
                prefixIcon: Icon(Icons.assignment),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _salarioController,
              decoration: const InputDecoration(
                labelText: 'Salario',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Fecha de contratación'),
              subtitle: Text(
                '${_fechaContratacion.day}/${_fechaContratacion.month}/${_fechaContratacion.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final fecha = await showDatePicker(
                  context: context,
                  initialDate: _fechaContratacion,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (fecha != null) {
                  setState(() => _fechaContratacion = fecha);
                }
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Empleado activo'),
              value: _activo,
              onChanged: (value) {
                setState(() => _activo = value);
              },
              activeColor: const Color(0xFF27AE60),
            ),
            const SizedBox(height: 24),
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value ? null : _guardarEmpleado,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF27AE60),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: controller.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      widget.empleado == null ? 'Crear Empleado' : 'Actualizar Empleado',
                      style: const TextStyle(fontSize: 16),
                    ),
            )),
          ],
        ),
      ),
    );
  }

  void _guardarEmpleado() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = Get.find<EmpleadoController>();
    
    final empleado = EmpleadoEntity(
      id: widget.empleado?.id ?? '',
      fincaId: widget.fincaId,
      nombre: _nombreController.text.trim(),
      cedula: _cedulaController.text.trim(),
      tipoEmpleado: _tipoEmpleado,
      cargo: _cargoController.text.trim().isEmpty ? null : _cargoController.text.trim(),
      salario: _salarioController.text.trim().isEmpty 
          ? null 
          : double.tryParse(_salarioController.text.trim()),
      fechaContratacion: _fechaContratacion,
      activo: _activo,
      createdAt: widget.empleado?.createdAt ?? DateTime.now(),
    );

    if (widget.empleado == null) {
      await controller.createEmpleado(empleado);
    } else {
      await controller.updateEmpleado(empleado);
    }

    if (controller.error.value.isEmpty) {
      Get.back();
    }
  }
}
