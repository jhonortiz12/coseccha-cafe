import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/recoleccion_controller.dart';
import '../../domain/entities/recoleccion_entity.dart';
import 'recoleccion_form_page.dart';
import 'estadisticas_recoleccion_page.dart';

class RecoleccionesPage extends StatelessWidget {
  final String fincaId;

  const RecoleccionesPage({Key? key, required this.fincaId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecoleccionController());
    controller.loadRecolecciones(fincaId);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recolección',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF27AE60),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Get.to(() => EstadisticasRecoleccionPage(fincaId: fincaId)),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context, controller),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.recolecciones.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.agriculture, size: 100, color: Colors.grey[400]),
                const SizedBox(height: 20),
                Text(
                  'No hay recolecciones registradas',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _navigateToForm(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Registrar Recolección'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF27AE60),
                  ),
                ),
              ],
            ),
          );
        }

        // Agrupar recolecciones por fecha
        final recoleccionesPorFecha = <String, List<RecoleccionEntity>>{};
        for (var recoleccion in controller.recolecciones) {
          final fechaKey = '${recoleccion.fecha.day}/${recoleccion.fecha.month}/${recoleccion.fecha.year}';
          if (!recoleccionesPorFecha.containsKey(fechaKey)) {
            recoleccionesPorFecha[fechaKey] = [];
          }
          recoleccionesPorFecha[fechaKey]!.add(recoleccion);
        }

        final fechasOrdenadas = recoleccionesPorFecha.keys.toList();

        return RefreshIndicator(
          onRefresh: () => controller.loadRecolecciones(fincaId),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: fechasOrdenadas.length,
            itemBuilder: (context, index) {
              final fecha = fechasOrdenadas[index];
              final recoleccionesDia = recoleccionesPorFecha[fecha]!;
              return _buildFechaGroup(context, fecha, recoleccionesDia, controller);
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(context),
        backgroundColor: const Color(0xFF27AE60),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFechaGroup(
    BuildContext context,
    String fecha,
    List<RecoleccionEntity> recolecciones,
    RecoleccionController controller,
  ) {
    // Calcular totales del día
    double totalKilos = 0;
    double totalPago = 0;
    for (var r in recolecciones) {
      totalKilos += r.kilosRecolectados;
      totalPago += r.pagoDia ?? 0;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con fecha y totales
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    fecha,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${totalKilos.toStringAsFixed(1)} kg',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${totalPago.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Lista de trabajadores
          ...recolecciones.map((recoleccion) => 
            _buildTrabajadorItem(context, recoleccion, controller)
          ).toList(),
        ],
      ),
    );
  }

  Widget _buildTrabajadorItem(
    BuildContext context,
    RecoleccionEntity recoleccion,
    RecoleccionController controller,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: const Color(0xFF27AE60).withOpacity(0.2),
        child: const Icon(Icons.person, color: Color(0xFF27AE60)),
      ),
      title: Text(
        recoleccion.empleadoNombre ?? 'Empleado desconocido',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${recoleccion.kilosRecolectados} kg'),
          if (recoleccion.pagoDia != null)
            Text(
              'Pago: \$${recoleccion.pagoDia!.toStringAsFixed(2)}',
              style: const TextStyle(color: Color(0xFF27AE60)),
            ),
          if (recoleccion.observaciones != null)
            Text(
              recoleccion.observaciones!,
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'edit') {
            _navigateToForm(context, recoleccion: recoleccion);
          } else if (value == 'delete') {
            _showDeleteDialog(context, recoleccion, controller);
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit, color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Text('Editar'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, color: Colors.red, size: 20),
                SizedBox(width: 8),
                Text('Eliminar'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecoleccionCard(
    BuildContext context,
    RecoleccionEntity recoleccion,
    RecoleccionController controller,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF27AE60),
          child: const Icon(Icons.coffee, color: Colors.white),
        ),
        title: Text(
          recoleccion.empleadoNombre ?? 'Empleado desconocido',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${recoleccion.fecha.day}/${recoleccion.fecha.month}/${recoleccion.fecha.year}',
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              '${recoleccion.kilosRecolectados} kg',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF27AE60),
              ),
            ),
            if (recoleccion.lote != null) Text('Lote: ${recoleccion.lote}'),
            if (recoleccion.observaciones != null) 
              Text(
                recoleccion.observaciones!,
                style: const TextStyle(fontStyle: FontStyle.italic),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _navigateToForm(context, recoleccion: recoleccion);
            } else if (value == 'delete') {
              _showDeleteDialog(context, recoleccion, controller);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Editar'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Eliminar'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToForm(BuildContext context, {RecoleccionEntity? recoleccion}) {
    Get.to(() => RecoleccionFormPage(
      fincaId: fincaId,
      recoleccion: recoleccion,
    ));
  }

  void _showDeleteDialog(
    BuildContext context,
    RecoleccionEntity recoleccion,
    RecoleccionController controller,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Está seguro de eliminar este registro?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteRecoleccion(recoleccion.id);
              Get.back();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context, RecoleccionController controller) {
    DateTime? fechaInicio;
    DateTime? fechaFin;

    Get.dialog(
      AlertDialog(
        title: const Text('Filtrar por fecha'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Fecha inicio'),
              subtitle: Text(fechaInicio?.toString().split(' ')[0] ?? 'Seleccionar'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final fecha = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (fecha != null) fechaInicio = fecha;
              },
            ),
            ListTile(
              title: const Text('Fecha fin'),
              subtitle: Text(fechaFin?.toString().split(' ')[0] ?? 'Seleccionar'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final fecha = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (fecha != null) fechaFin = fecha;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.loadRecolecciones(fincaId);
              Get.back();
            },
            child: const Text('Limpiar'),
          ),
          TextButton(
            onPressed: () {
              if (fechaInicio != null && fechaFin != null) {
                controller.loadRecoleccionesByRango(fincaId, fechaInicio!, fechaFin!);
                Get.back();
              }
            },
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }
}
