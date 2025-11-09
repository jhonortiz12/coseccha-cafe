import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/finanzas_controller.dart';

class DashboardFinancieroPage extends StatefulWidget {
  final String fincaId;

  const DashboardFinancieroPage({Key? key, required this.fincaId}) : super(key: key);

  @override
  State<DashboardFinancieroPage> createState() => _DashboardFinancieroPageState();
}

class _DashboardFinancieroPageState extends State<DashboardFinancieroPage> {
  DateTime _fechaInicio = DateTime.now().subtract(const Duration(days: 30));
  DateTime _fechaFin = DateTime.now();

  @override
  void initState() {
    super.initState();
    final controller = Get.put(FinanzasController());
    _cargarDatos(controller);
  }

  void _cargarDatos(FinanzasController controller) {
    controller.loadResumenFinanciero(widget.fincaId, _fechaInicio, _fechaFin);
    controller.loadGastosByRango(widget.fincaId, _fechaInicio, _fechaFin);
    controller.loadIngresosByRango(widget.fincaId, _fechaInicio, _fechaFin);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FinanzasController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Financiero'),
        backgroundColor: const Color(0xFF27AE60),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _cargarDatos(controller),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildDateRangeSelector(controller),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final resumen = controller.resumenFinanciero.value;
              if (resumen.isEmpty) {
                return const Center(child: Text('No hay datos'));
              }

              return Column(
                children: [
                  _buildResumenCards(resumen),
                  const SizedBox(height: 20),
                  _buildListaGastos(controller),
                  const SizedBox(height: 20),
                  _buildListaIngresos(controller),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeSelector(FinanzasController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Período', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Desde'),
                    subtitle: Text('${_fechaInicio.day}/${_fechaInicio.month}/${_fechaInicio.year}'),
                    onTap: () async {
                      final f = await showDatePicker(
                        context: context,
                        initialDate: _fechaInicio,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (f != null) {
                        setState(() => _fechaInicio = f);
                        _cargarDatos(controller);
                      }
                    },
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Hasta'),
                    subtitle: Text('${_fechaFin.day}/${_fechaFin.month}/${_fechaFin.year}'),
                    onTap: () async {
                      final f = await showDatePicker(
                        context: context,
                        initialDate: _fechaFin,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (f != null) {
                        setState(() => _fechaFin = f);
                        _cargarDatos(controller);
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

  Widget _buildResumenCards(Map<String, dynamic> resumen) {
    final ingresos = resumen['total_ingresos'] ?? 0.0;
    final gastos = resumen['total_gastos'] ?? 0.0;
    final balance = resumen['balance'] ?? 0.0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatCard('Ingresos', ingresos, Colors.green)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Gastos', gastos, Colors.red)),
          ],
        ),
        const SizedBox(height: 12),
        _buildStatCard('Balance', balance, balance >= 0 ? Colors.green : Colors.red),
      ],
    );
  }

  Widget _buildStatCard(String label, double value, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Text(
              '\$${value.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListaGastos(FinanzasController controller) {
    if (controller.gastos.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gastos recientes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...controller.gastos.take(5).map((g) => Card(
          child: ListTile(
            leading: const Icon(Icons.money_off, color: Colors.red),
            title: Text(g.descripcion),
            subtitle: Text('${g.fecha.day}/${g.fecha.month}/${g.fecha.year}'),
            trailing: Text('\$${g.monto.toStringAsFixed(2)}', 
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        )),
      ],
    );
  }

  Widget _buildListaIngresos(FinanzasController controller) {
    if (controller.ingresos.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ingresos recientes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...controller.ingresos.take(5).map((i) => Card(
          child: ListTile(
            leading: const Icon(Icons.attach_money, color: Colors.green),
            title: Text(i.descripcion),
            subtitle: Text('${i.fecha.day}/${i.fecha.month}/${i.fecha.year}'),
            trailing: Text('\$${(i.total ?? 0).toStringAsFixed(2)}', 
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ),
        )),
      ],
    );
  }
}
