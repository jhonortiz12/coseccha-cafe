import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/finanzas_controller.dart';
import 'ingreso_form_page.dart';
import '../../core/utils/number_formatter.dart';

class IngresosPage extends StatelessWidget {
  final String fincaId;

  const IngresosPage({Key? key, required this.fincaId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FinanzasController>();
    controller.loadIngresos(fincaId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingresos'),
        backgroundColor: Colors.green[700],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.ingresos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.attach_money, size: 100, color: Colors.grey[400]),
                const SizedBox(height: 20),
                const Text('No hay ingresos registrados'),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => Get.to(() => IngresoFormPage(fincaId: fincaId)),
                  icon: const Icon(Icons.add),
                  label: const Text('Registrar Ingreso'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadIngresos(fincaId),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.ingresos.length,
            itemBuilder: (context, index) {
              final ingreso = controller.ingresos[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green[100],
                    child: const Icon(Icons.attach_money, color: Colors.green),
                  ),
                  title: Text(ingreso.descripcion),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${ingreso.fecha.day}/${ingreso.fecha.month}/${ingreso.fecha.year}'),
                      if (ingreso.cantidadKg != null) 
                        Text('${NumberFormatter.formatWithThousands(ingreso.cantidadKg!)} kg @ ${NumberFormatter.formatCurrency(ingreso.precioKg ?? 0)}/kg'),
                      if (ingreso.metodoPago != null) 
                        Text('Pago: ${ingreso.metodoPago!.displayName}'),
                    ],
                  ),
                  trailing: Text(
                    NumberFormatter.formatCurrency(ingreso.total ?? 0),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                  onTap: () => Get.to(() => IngresoFormPage(fincaId: fincaId, ingreso: ingreso)),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => IngresoFormPage(fincaId: fincaId)),
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.add),
      ),
    );
  }
}
