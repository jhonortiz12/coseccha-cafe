import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/finanzas_controller.dart';
import 'gastos_page.dart';
import 'ingresos_page.dart';
import 'dashboard_financiero_page.dart';
import '../../core/utils/number_formatter.dart';

class FinanzasPage extends StatelessWidget {
  final String fincaId;

  const FinanzasPage({Key? key, required this.fincaId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FinanzasController());
    
    // Cargar resumen del mes actual
    final now = DateTime.now();
    final primerDiaMes = DateTime(now.year, now.month, 1);
    final ultimoDiaMes = DateTime(now.year, now.month + 1, 0);
    
    controller.loadResumenFinanciero(fincaId, primerDiaMes, ultimoDiaMes);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Gestión Financiera',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF27AE60),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard, color: Colors.white),
            onPressed: () => Get.to(() => DashboardFinancieroPage(fincaId: fincaId)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header de Finanzas (separado y elegante)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2ECC71),
                  Color(0xFF27AE60),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF27AE60).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.account_balance_wallet,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Finanzas',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Administra ingresos y gastos',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.95),
                  ),
                ),
              ],
            ),
          ),
          // Contenido
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildResumenCard(controller),
                const SizedBox(height: 20),
                _buildMenuCard(
                  context,
                  'Gastos',
                  'Registra y gestiona los gastos de la finca',
                  Icons.money_off,
                  const Color(0xFFE53935),
                  () => Get.to(() => GastosPage(fincaId: fincaId)),
                ),
                const SizedBox(height: 16),
                _buildMenuCard(
                  context,
                  'Ingresos',
                  'Registra ventas y otros ingresos',
                  Icons.attach_money,
                  const Color(0xFF43A047),
                  () => Get.to(() => IngresosPage(fincaId: fincaId)),
                ),
                const SizedBox(height: 16),
                _buildMenuCard(
                  context,
                  'Dashboard Financiero',
                  'Visualiza gráficas y reportes detallados',
                  Icons.bar_chart,
                  const Color(0xFF1E88E5),
                  () => Get.to(() => DashboardFinancieroPage(fincaId: fincaId)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumenCard(FinanzasController controller) {
    return Obx(() {
      final resumen = controller.resumenFinanciero.value;
      
      if (resumen.isEmpty) {
        return const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      }

      final totalIngresos = resumen['total_ingresos'] ?? 0.0;
      final totalGastos = resumen['total_gastos'] ?? 0.0;
      final balance = resumen['balance'] ?? 0.0;

      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.grey[50]!,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF27AE60).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.calendar_month,
                        color: Color(0xFF27AE60),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Resumen del mes actual',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32),
                _buildResumenRow('Ingresos', totalIngresos, const Color(0xFF43A047)),
                const SizedBox(height: 16),
                _buildResumenRow('Gastos', totalGastos, const Color(0xFFE53935)),
                const Divider(height: 32),
                _buildResumenRow(
                  'Balance',
                  balance,
                  balance >= 0 ? const Color(0xFF43A047) : const Color(0xFFE53935),
                  isBalance: true,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildResumenRow(String label, double value, Color color, {bool isBalance = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBalance ? 18 : 16,
            fontWeight: isBalance ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          NumberFormatter.formatCurrency(value),
          style: TextStyle(
            fontSize: isBalance ? 20 : 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
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
