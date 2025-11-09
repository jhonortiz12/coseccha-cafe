import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/finanzas_controller.dart';
import '../../domain/entities/gasto_entity.dart';
import 'gasto_form_page.dart';
import '../../core/utils/number_formatter.dart';

class GastosPage extends StatelessWidget {
  final String fincaId;

  const GastosPage({Key? key, required this.fincaId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FinanzasController>();
    controller.loadGastos(fincaId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gastos'),
        backgroundColor: Colors.red[700],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.gastos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.money_off, size: 100, color: Colors.grey[400]),
                const SizedBox(height: 20),
                const Text('No hay gastos registrados'),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => Get.to(() => GastoFormPage(fincaId: fincaId)),
                  icon: const Icon(Icons.add),
                  label: const Text('Registrar Gasto'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadGastos(fincaId),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.gastos.length,
            itemBuilder: (context, index) {
              final gasto = controller.gastos[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red[100],
                    child: const Icon(Icons.money_off, color: Colors.red),
                  ),
                  title: Text(gasto.descripcion),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${gasto.fecha.day}/${gasto.fecha.month}/${gasto.fecha.year}'),
                      if (gasto.categoriaNombre != null) Text('Categoría: ${gasto.categoriaNombre}'),
                      if (gasto.proveedor != null) Text('Proveedor: ${gasto.proveedor}'),
                    ],
                  ),
                  trailing: Text(
                    NumberFormatter.formatCurrency(gasto.monto),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () => Get.to(() => GastoFormPage(fincaId: fincaId, gasto: gasto)),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => GastoFormPage(fincaId: fincaId)),
        backgroundColor: Colors.red[700],
        child: const Icon(Icons.add),
      ),
    );
  }
}
