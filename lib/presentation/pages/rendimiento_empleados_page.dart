import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/config/supabase_config.dart';

class RendimientoEmpleadosPage extends StatefulWidget {
  final String fincaId;
  final String fincaNombre;

  const RendimientoEmpleadosPage({
    Key? key,
    required this.fincaId,
    required this.fincaNombre,
  }) : super(key: key);

  @override
  State<RendimientoEmpleadosPage> createState() => _RendimientoEmpleadosPageState();
}

class _RendimientoEmpleadosPageState extends State<RendimientoEmpleadosPage> {
  List<Map<String, dynamic>> _rendimientos = [];
  bool _isLoading = true;
  DateTime _fechaInicio = DateTime.now().subtract(const Duration(days: 30));
  DateTime _fechaFin = DateTime.now();
  final _formatoFecha = DateFormat('dd/MM/yyyy');
  final _formatoMoneda = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _cargarRendimientos();
  }

  Future<void> _cargarRendimientos() async {
    setState(() => _isLoading = true);

    try {
      final fechaInicioStr = _fechaInicio.toIso8601String().split('T')[0];
      final fechaFinStr = _fechaFin.toIso8601String().split('T')[0];

      // Obtener recolecciones con información del empleado
      final response = await SupabaseConfig.client
          .from('recolecciones')
          .select('''
            empleado_id,
            kilos_recolectados,
            pago_dia,
            fecha,
            empleados!inner(nombre)
          ''')
          .eq('finca_id', widget.fincaId)
          .gte('fecha', fechaInicioStr)
          .lte('fecha', fechaFinStr)
          .order('fecha', ascending: false);

      // Agrupar por empleado
      final Map<String, Map<String, dynamic>> empleadosMap = {};

      for (var recoleccion in response) {
        final empleadoId = recoleccion['empleado_id'] as String;
        final empleadoNombre = recoleccion['empleados']['nombre'] as String;
        final kilos = double.parse(recoleccion['kilos_recolectados'].toString());
        final pago = double.parse(recoleccion['pago_dia'].toString());

        if (!empleadosMap.containsKey(empleadoId)) {
          empleadosMap[empleadoId] = {
            'empleado_id': empleadoId,
            'nombre': empleadoNombre,
            'total_kilos': 0.0,
            'total_pago': 0.0,
            'dias_trabajados': 0,
            'promedio_kilos_dia': 0.0,
          };
        }

        empleadosMap[empleadoId]!['total_kilos'] += kilos;
        empleadosMap[empleadoId]!['total_pago'] += pago;
        empleadosMap[empleadoId]!['dias_trabajados'] += 1;
      }

      // Calcular promedios
      for (var empleado in empleadosMap.values) {
        if (empleado['dias_trabajados'] > 0) {
          empleado['promedio_kilos_dia'] = 
              empleado['total_kilos'] / empleado['dias_trabajados'];
        }
      }

      // Convertir a lista y ordenar por total de kilos
      final rendimientos = empleadosMap.values.toList();
      rendimientos.sort((a, b) => 
          (b['total_kilos'] as double).compareTo(a['total_kilos'] as double));

      setState(() {
        _rendimientos = rendimientos;
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando rendimientos: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _seleccionarRangoFechas() async {
    final DateTimeRange? rango = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _fechaInicio, end: _fechaFin),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF27AE60),
            ),
          ),
          child: child!,
        );
      },
    );

    if (rango != null) {
      setState(() {
        _fechaInicio = rango.start;
        _fechaFin = rango.end;
      });
      _cargarRendimientos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Rendimiento de Empleados',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF27AE60),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header con información del rango
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
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
                Text(
                  widget.fincaNombre,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Período: ${_formatoFecha.format(_fechaInicio)} - ${_formatoFecha.format(_fechaFin)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _seleccionarRangoFechas,
                      icon: const Icon(Icons.date_range, size: 18),
                      label: const Text('Cambiar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF27AE60),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Lista de empleados
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _rendimientos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline,
                                size: 80, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'No hay datos de recolección\nen este período',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _rendimientos.length,
                        itemBuilder: (context, index) {
                          final empleado = _rendimientos[index];
                          final posicion = index + 1;
                          
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      // Posición
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: _getColorPosicion(posicion),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '#$posicion',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Nombre
                                      Expanded(
                                        child: Text(
                                          empleado['nombre'],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // Estadísticas
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildStatChip(
                                          Icons.scale,
                                          '${empleado['total_kilos'].toStringAsFixed(1)} kg',
                                          'Total recolectado',
                                          const Color(0xFF27AE60),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: _buildStatChip(
                                          Icons.calendar_today,
                                          '${empleado['dias_trabajados']} días',
                                          'Días trabajados',
                                          const Color(0xFF2196F3),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildStatChip(
                                          Icons.trending_up,
                                          '${empleado['promedio_kilos_dia'].toStringAsFixed(1)} kg/día',
                                          'Promedio diario',
                                          const Color(0xFFFF9800),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: _buildStatChip(
                                          Icons.attach_money,
                                          _formatoMoneda.format(empleado['total_pago']),
                                          'Total pagado',
                                          const Color(0xFF4CAF50),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorPosicion(int posicion) {
    switch (posicion) {
      case 1:
        return const Color(0xFFFFD700); // Oro
      case 2:
        return const Color(0xFFC0C0C0); // Plata
      case 3:
        return const Color(0xFFCD7F32); // Bronce
      default:
        return const Color(0xFF27AE60); // Verde
    }
  }
}
