import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/recoleccion_controller.dart';
import '../controllers/empleado_controller.dart';
import '../../domain/entities/recoleccion_entity.dart';
import '../../domain/entities/empleado_entity.dart';
import '../../core/config/supabase_config.dart';
import '../../core/utils/date_picker_helper.dart';

class RecoleccionFormPage extends StatefulWidget {
  final String fincaId;
  final RecoleccionEntity? recoleccion;

  const RecoleccionFormPage({
    Key? key,
    required this.fincaId,
    this.recoleccion,
  }) : super(key: key);

  @override
  State<RecoleccionFormPage> createState() => _RecoleccionFormPageState();
}

class _RecoleccionFormPageState extends State<RecoleccionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _kilosController = TextEditingController();
  final _pagoController = TextEditingController();
  final _observacionesController = TextEditingController();
  
  String? _empleadoId;
  DateTime _fecha = DateTime.now();
  bool _mostrarCamposTrabajador = false;

  @override
  void initState() {
    super.initState();
    final empleadoController = Get.put(EmpleadoController());
    
    // Load empleados after the first frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🔍 DEBUG: Cargando empleados activos para fincaId: ${widget.fincaId}');
      empleadoController.loadEmpleadosActivos(widget.fincaId).then((_) {
        print('✅ DEBUG: Empleados activos cargados: ${empleadoController.empleadosActivos.length}');
        if (empleadoController.empleadosActivos.isEmpty) {
          print('⚠️ DEBUG: No hay empleados activos. Verifica en la base de datos.');
        } else {
          for (var emp in empleadoController.empleadosActivos) {
            print('   - ${emp.nombre} (activo: ${emp.activo})');
          }
        }
      });
    });

    if (widget.recoleccion != null) {
      _empleadoId = widget.recoleccion!.empleadoId;
      _fecha = widget.recoleccion!.fecha;
      _kilosController.text = widget.recoleccion!.kilosRecolectados.toString();
      _pagoController.text = widget.recoleccion!.pagoDia?.toString() ?? '';
      _observacionesController.text = widget.recoleccion!.observaciones ?? '';
      _mostrarCamposTrabajador = true;
    }
  }

  @override
  void dispose() {
    _kilosController.dispose();
    _pagoController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recoleccionController = Get.find<RecoleccionController>();
    final empleadoController = Get.find<EmpleadoController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recoleccion == null 
            ? 'Nueva Recolección' 
            : 'Editar Recolección'),
        backgroundColor: const Color(0xFF27AE60),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Fecha de recolección
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: Color(0xFF27AE60)),
                title: const Text(
                  'Fecha de recolección',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${_fecha.day}/${_fecha.month}/${_fecha.year}',
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final fecha = await DatePickerHelper.showSpanishDatePicker(
                    context: context,
                    initialDate: _fecha,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (fecha != null) {
                    setState(() => _fecha = fecha);
                  }
                },
              ),
            ),
            const SizedBox(height: 24),

            // Botón para añadir trabajador
            if (!_mostrarCamposTrabajador)
              ElevatedButton.icon(
                onPressed: () {
                  setState(() => _mostrarCamposTrabajador = true);
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Añadir Trabajador'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF27AE60),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

            // Campos del trabajador
            if (_mostrarCamposTrabajador) ...[
              Obx(() {
                if (empleadoController.isLoading.value) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }
                
                if (empleadoController.empleadosActivos.isEmpty) {
                  return Card(
                    color: Colors.orange[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.warning, color: Colors.orange),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'No hay empleados activos',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Para registrar una recolección, primero debes:',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '1. Ir a la sección "Empleados"\n2. Registrar un empleado\n3. Asegurarte de que esté marcado como "Activo"',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Volver'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return DropdownButtonFormField<String>(
                  value: _empleadoId,
                  decoration: const InputDecoration(
                    labelText: '👤 Trabajador *',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: empleadoController.empleadosActivos.map((empleado) {
                    return DropdownMenuItem(
                      value: empleado.id,
                      child: Text(empleado.nombre),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _empleadoId = value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Seleccione un trabajador';
                    }
                    return null;
                  },
                );
              }),
              const SizedBox(height: 16),

              // Kilos recolectados
              TextFormField(
                controller: _kilosController,
                decoration: const InputDecoration(
                  labelText: '⚖️ Kilos recolectados *',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  suffixText: 'kg',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Los kilos son requeridos';
                  }
                  final kilos = double.tryParse(value);
                  if (kilos == null || kilos <= 0) {
                    return 'Ingrese un valor válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Pago del día
              TextFormField(
                controller: _pagoController,
                decoration: const InputDecoration(
                  labelText: '💰 Pago del día *',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  prefixText: '\$ ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El pago es requerido';
                  }
                  final pago = double.tryParse(value);
                  if (pago == null || pago < 0) {
                    return 'Ingrese un valor válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Observaciones
              TextFormField(
                controller: _observacionesController,
                decoration: const InputDecoration(
                  labelText: '📝 Observaciones',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Notas adicionales (opcional)',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Botones de acción
              if (widget.recoleccion == null) ...[
                // Botón Añadir Trabajador
                Obx(() => ElevatedButton.icon(
                  onPressed: recoleccionController.isLoading.value 
                      ? null 
                      : _guardarYAnadirOtro,
                  icon: const Icon(Icons.person_add),
                  label: const Text(
                    'Añadir Trabajador',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )),
                const SizedBox(height: 12),
                // Botón Guardar Cosecha
                Obx(() => ElevatedButton.icon(
                  onPressed: recoleccionController.isLoading.value 
                      ? null 
                      : _guardarYCerrar,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    'Guardar Cosecha',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF27AE60),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )),
              ] else
                // Botón Actualizar (solo cuando se edita)
                Obx(() => ElevatedButton.icon(
                  onPressed: recoleccionController.isLoading.value 
                      ? null 
                      : _guardarYCerrar,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    'Actualizar Cosecha',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF27AE60),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )),
            ],
          ],
        ),
      ),
    );
  }

  // Guardar y añadir otro trabajador
  void _guardarYAnadirOtro() async {
    if (!_formKey.currentState!.validate()) return;

    await _guardarRecoleccion();
    
    final controller = Get.find<RecoleccionController>();
    if (controller.error.value.isEmpty) {
      Get.snackbar(
        '✅ Trabajador Guardado',
        'Puedes añadir otro trabajador',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      _limpiarFormulario();
    }
  }

  // Guardar y cerrar
  void _guardarYCerrar() async {
    if (!_formKey.currentState!.validate()) return;

    await _guardarRecoleccion();
    
    final controller = Get.find<RecoleccionController>();
    if (controller.error.value.isEmpty) {
      // Navegar de vuelta a la lista de recolecciones
      Get.back();
      Get.snackbar(
        '✅ Cosecha Guardada',
        'La cosecha se ha guardado exitosamente',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Método común de guardado
  Future<void> _guardarRecoleccion() async {
    final controller = Get.find<RecoleccionController>();
    final pagoDia = double.parse(_pagoController.text.trim());
    
    final recoleccion = RecoleccionEntity(
      id: widget.recoleccion?.id ?? '',
      empleadoId: _empleadoId!,
      fincaId: widget.fincaId,
      fecha: _fecha,
      lote: null,
      kilosRecolectados: double.parse(_kilosController.text.trim()),
      pagoDia: pagoDia,
      observaciones: _observacionesController.text.trim().isEmpty 
          ? null 
          : _observacionesController.text.trim(),
      createdAt: widget.recoleccion?.createdAt ?? DateTime.now(),
    );

    if (widget.recoleccion == null) {
      await controller.createRecoleccion(recoleccion);
      
      // Crear gasto automático por nómina
      if (controller.error.value.isEmpty && pagoDia > 0) {
        await _crearGastoNomina(pagoDia);
      }
    } else {
      await controller.updateRecoleccion(recoleccion);
    }
  }

  void _limpiarFormulario() {
    setState(() {
      _empleadoId = null;
      _kilosController.clear();
      _pagoController.clear();
      _observacionesController.clear();
      // Mantener _mostrarCamposTrabajador = true para seguir añadiendo trabajadores
    });
  }

  Future<void> _crearGastoNomina(double monto) async {
    try {
      final empleadoController = Get.find<EmpleadoController>();
      final empleado = empleadoController.empleadosActivos
          .firstWhere((e) => e.id == _empleadoId);
      
      await SupabaseConfig.client.from('gastos').insert({
        'finca_id': widget.fincaId,
        'fecha': _fecha.toIso8601String().split('T')[0],
        'descripcion': 'Pago recolección - ${empleado.nombre}',
        'monto': monto,
        'proveedor': empleado.nombre,
      });
    } catch (e) {
      print('Error al crear gasto de nómina: $e');
      Get.snackbar(
        'Advertencia',
        'No se pudo crear el gasto automáticamente',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }
}
