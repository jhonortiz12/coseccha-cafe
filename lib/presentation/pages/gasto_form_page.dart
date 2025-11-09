import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/finanzas_controller.dart';
import '../../domain/entities/gasto_entity.dart';
import '../widgets/formatted_number_field.dart';
import '../../core/utils/number_formatter.dart';
import '../../core/utils/date_picker_helper.dart';

class GastoFormPage extends StatefulWidget {
  final String fincaId;
  final GastoEntity? gasto;

  const GastoFormPage({Key? key, required this.fincaId, this.gasto}) : super(key: key);

  @override
  State<GastoFormPage> createState() => _GastoFormPageState();
}

class _GastoFormPageState extends State<GastoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  final _montoController = TextEditingController();
  final _proveedorController = TextEditingController();
  
  DateTime _fecha = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.gasto != null) {
      _descripcionController.text = widget.gasto!.descripcion;
      _montoController.text = NumberFormatter.formatWithThousands(widget.gasto!.monto);
      _proveedorController.text = widget.gasto!.proveedor ?? '';
      _fecha = widget.gasto!.fecha;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FinanzasController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gasto == null ? 'Nuevo Gasto' : 'Editar Gasto'),
        backgroundColor: Colors.red[700],
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
            CurrencyFormattedField(
              controller: _montoController,
              labelText: 'Monto *',
              hintText: 'Ej: 100.000',
              validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _proveedorController,
              decoration: const InputDecoration(
                labelText: 'Proveedor',
                border: OutlineInputBorder(),
              ),
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
                backgroundColor: Colors.red[700],
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(widget.gasto == null ? 'Crear Gasto' : 'Actualizar'),
            ),
          ],
        ),
      ),
    );
  }

  void _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = Get.find<FinanzasController>();
    
    // Parsear el monto formateado
    final montoValue = NumberFormatter.parseFormattedNumber(_montoController.text);
    if (montoValue == null) {
      Get.snackbar('Error', 'Monto inválido');
      return;
    }
    
    final gasto = GastoEntity(
      id: widget.gasto?.id ?? '',
      fincaId: widget.fincaId,
      categoriaId: null,
      fecha: _fecha,
      descripcion: _descripcionController.text,
      monto: montoValue,
      proveedor: _proveedorController.text.isEmpty ? null : _proveedorController.text,
      observaciones: null,
      createdAt: widget.gasto?.createdAt ?? DateTime.now(),
    );

    if (widget.gasto == null) {
      await controller.createGasto(gasto);
    } else {
      await controller.updateGasto(gasto);
    }

    if (controller.error.value.isEmpty) {
      // Navegar de vuelta a la lista de gastos
      Get.back();
      Get.snackbar(
        '✅ Gasto Guardado',
        widget.gasto == null 
            ? 'El gasto se ha creado exitosamente' 
            : 'El gasto se ha actualizado exitosamente',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _montoController.dispose();
    _proveedorController.dispose();
    super.dispose();
  }
}
