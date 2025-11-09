import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/recoleccion_controller.dart';

class EstadisticasRecoleccionPage extends StatefulWidget {
  final String fincaId;

  const EstadisticasRecoleccionPage({Key? key, required this.fincaId}) : super(key: key);

  @override
  State<EstadisticasRecoleccionPage> createState() => _EstadisticasRecoleccionPageState();
}

class _EstadisticasRecoleccionPageState extends State<EstadisticasRecoleccionPage> {
  DateTime _fechaInicio = DateTime.now().subtract(const Duration(days: 30));
  DateTime _fechaFin = DateTime.now();

  @override
  void initState() {
    super.initState();
    final controller = Get.put(RecoleccionController());
    controller.loadEstadisticas(widget.fincaId, _fechaInicio, _fechaFin);
    controller.loadRecoleccionesByRango(widget.fincaId, _fechaInicio, _fechaFin);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecoleccionController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas de Recolección'),
        backgroundColor: const Color(0xFF27AE60),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.loadEstadisticas(widget.fincaId, _fechaInicio, _fechaFin);
          await controller.loadRecoleccionesByRango(widget.fincaId, _fechaInicio, _fechaFin);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildDateRangeSelector(controller),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final stats = controller.estadisticas.value;
              if (stats.isEmpty) {
                return const Center(
                  child: Text('No hay datos para mostrar'),
                );
              }

              return Column(
                children: [
                  _buildStatCard(
                    'Total Recolectado',
                    '${stats['total_kilos']?.toStringAsFixed(2) ?? '0'} kg',
                    Icons.scale,
                    Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    'Promedio Diario',
                    '${stats['promedio_diario']?.toStringAsFixed(2) ?? '0'} kg',
                    Icons.trending_up,
                    Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    'Total Registros',
                    '${stats['total_registros'] ?? 0}',
                    Icons.list_alt,
                    Colors.orange,
                  ),
                  const SizedBox(height: 24),
                  _buildRecoleccionesList(controller),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeSelector(RecoleccionController controller) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rango de fechas',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Desde'),
                    subtitle: Text(
                      '${_fechaInicio.day}/${_fechaInicio.month}/${_fechaInicio.year}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final fecha = await showDatePicker(
                        context: context,
                        initialDate: _fechaInicio,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (fecha != null) {
                        setState(() => _fechaInicio = fecha);
                        controller.loadEstadisticas(widget.fincaId, _fechaInicio, _fechaFin);
                        controller.loadRecoleccionesByRango(widget.fincaId, _fechaInicio, _fechaFin);
                      }
                    },
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Hasta'),
                    subtitle: Text(
                      '${_fechaFin.day}/${_fechaFin.month}/${_fechaFin.year}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final fecha = await showDatePicker(
                        context: context,
                        initialDate: _fechaFin,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (fecha != null) {
                        setState(() => _fechaFin = fecha);
                        controller.loadEstadisticas(widget.fincaId, _fechaInicio, _fechaFin);
                        controller.loadRecoleccionesByRango(widget.fincaId, _fechaInicio, _fechaFin);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        trailing: Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildRecoleccionesList(RecoleccionController controller) {
    return Obx(() {
      if (controller.recolecciones.isEmpty) {
        return const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('No hay recolecciones en este período'),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detalle de recolecciones',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...controller.recolecciones.map((recoleccion) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.coffee, color: Color(0xFF27AE60)),
                title: Text(recoleccion.empleadoNombre ?? 'Empleado'),
                subtitle: Text(
                  '${recoleccion.fecha.day}/${recoleccion.fecha.month}/${recoleccion.fecha.year}',
                ),
                trailing: Text(
                  '${recoleccion.kilosRecolectados} kg',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      );
    });
  }
}
