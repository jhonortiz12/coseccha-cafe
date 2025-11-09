import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/finanzas_controller.dart';
import '../../domain/entities/ingreso_entity.dart';
import '../widgets/formatted_number_field.dart';
import '../../core/utils/number_formatter.dart';
import '../../core/utils/date_picker_helper.dart';

class IngresoFormPage extends StatefulWidget {
  final String fincaId;
  final IngresoEntity? ingreso;

  const IngresoFormPage({Key? key, required this.fincaId, this.ingreso}) : super(key: key);

  @override
  State<IngresoFormPage> createState() => _IngresoFormPageState();
}

class _IngresoFormPageState extends State<IngresoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  final _cantidadKgController = TextEditingController();
  final _precioKgController = TextEditingController();
  
  MetodoPago? _metodoPago;
  DateTime _fecha = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.ingreso != null) {
      _descripcionController.text = widget.ingreso!.descripcion;
      _cantidadKgController.text = widget.ingreso!.cantidadKg != null 
          ? NumberFormatter.formatWithThousands(widget.ingreso!.cantidadKg!) 
          : '';
      _precioKgController.text = widget.ingreso!.precioKg != null 
          ? NumberFormatter.formatWithThousands(widget.ingreso!.precioKg!) 
          : '';
      _metodoPago = widget.ingreso!.metodoPago;
      _fecha = widget.ingreso!.fecha;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FinanzasController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ingreso == null ? 'Nuevo Ingreso' : 'Editar Ingreso'),
        backgroundColor: Colors.green[700],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción *',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
            ),
            const SizedBox(height: 16),
            FormattedNumberField(
              controller: _cantidadKgController,
              labelText: 'Cantidad (kg)',
              hintText: 'Ej: 1.000',
              prefixIcon: Icons.scale,
            ),
            const SizedBox(height: 16),
            CurrencyFormattedField(
              controller: _precioKgController,
              labelText: 'Precio por kg',
              hintText: 'Ej: 10.000',
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<MetodoPago>(
              value: _metodoPago,
              decoration: const InputDecoration(
                labelText: 'Método de pago',
                border: OutlineInputBorder(),
              ),
              items: MetodoPago.values.map((metodo) {
                return DropdownMenuItem(
                  value: metodo,
                  child: Text(metodo.displayName),
                );
              }).toList(),
              onChanged: (v) => setState(() => _metodoPago = v),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Fecha'),
              subtitle: Text('${_fecha.day}/${_fecha.month}/${_fecha.year}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final f = await DatePickerHelper.showSpanishDatePicker(
                  context: context,
                  initialDate: _fecha,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (f != null) setState(() => _fecha = f);
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _guardar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(widget.ingreso == null ? 'Crear Ingreso' : 'Actualizar'),
            ),
          ],
        ),
      ),
    );
  }

  void _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = Get.find<FinanzasController>();
    
    final cantidadKg = _cantidadKgController.text.isEmpty 
        ? null 
        : NumberFormatter.parseFormattedNumber(_cantidadKgController.text);
    final precioKg = _precioKgController.text.isEmpty 
        ? null 
        : NumberFormatter.parseFormattedNumber(_precioKgController.text);

    final ingreso = IngresoEntity(
      id: widget.ingreso?.id ?? '',
      fincaId: widget.fincaId,
      categoriaId: null,
      fecha: _fecha,
      descripcion: _descripcionController.text,
      cantidadKg: cantidadKg,
      precioKg: precioKg,
      metodoPago: _metodoPago,
      observaciones: null,
      createdAt: widget.ingreso?.createdAt ?? DateTime.now(),
    );

    if (widget.ingreso == null) {
      await controller.createIngreso(ingreso);
    } else {
      await controller.updateIngreso(ingreso);
    }

    if (controller.error.value.isEmpty) {
      // Navegar de vuelta a la lista de ingresos
      Get.back();
      Get.snackbar(
        '✅ Ingreso Guardado',
        widget.ingreso == null 
            ? 'El ingreso se ha creado exitosamente' 
            : 'El ingreso se ha actualizado exitosamente',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _cantidadKgController.dispose();
    _precioKgController.dispose();
    super.dispose();
  }
}
