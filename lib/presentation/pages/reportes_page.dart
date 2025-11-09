import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'estadisticas_recoleccion_page.dart';
import 'dashboard_financiero_page.dart';
import 'rendimiento_empleados_page.dart';

/// Página de reportes y estadísticas de la finca
class ReportesPage extends StatelessWidget {
  final String fincaId;
  final String fincaNombre;

  const ReportesPage({
    Key? key,
    required this.fincaId,
    required this.fincaNombre,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Reportes y Estadísticas',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF27AE60),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2ECC71),
                  Color(0xFF27AE60),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Análisis de Datos',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  fincaNombre,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),

          // Lista de reportes
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildReportCard(
                  context,
                  'Estadísticas de Recolección',
                  'Análisis de producción y rendimiento',
                  Icons.agriculture,
                  const Color(0xFF27AE60),
                  () => Get.to(() => EstadisticasRecoleccionPage(fincaId: fincaId)),
                ),
                const SizedBox(height: 16),
                _buildReportCard(
                  context,
                  'Dashboard Financiero',
                  'Ingresos, gastos y rentabilidad',
                  Icons.attach_money,
                  const Color(0xFFFF9800),
                  () => Get.to(() => DashboardFinancieroPage(fincaId: fincaId)),
                ),
                const SizedBox(height: 16),
                _buildReportCard(
                  context,
                  'Rendimiento de Empleados',
                  'Productividad del equipo de trabajo',
                  Icons.people,
                  const Color(0xFF2196F3),
                  () => Get.to(() => RendimientoEmpleadosPage(
                    fincaId: fincaId,
                    fincaNombre: fincaNombre,
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
