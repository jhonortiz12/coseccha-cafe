import '../../domain/entities/recoleccion_entity.dart';
import '../../domain/repositories/recoleccion_repository.dart';
import '../../core/config/supabase_config.dart';
import '../models/recoleccion_model.dart';

class RecoleccionRepositoryImpl implements RecoleccionRepository {
  final _supabase = SupabaseConfig.client;

  @override
  Future<List<RecoleccionEntity>> getRecoleccionesByFinca(String fincaId) async {
    try {
      final response = await _supabase
          .from('recolecciones')
          .select('''
            *,
            empleados!inner(nombre)
          ''')
          .eq('finca_id', fincaId)
          .order('fecha', ascending: false);

      return (response as List).map((json) {
        final empleadoNombre = json['empleados']?['nombre'] as String?;
        json['empleado_nombre'] = empleadoNombre;
        return RecoleccionModel.fromJson(json).toEntity();
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener recolecciones: $e');
    }
  }

  @override
  Future<List<RecoleccionEntity>> getRecoleccionesByEmpleado(String empleadoId) async {
    try {
      final response = await _supabase
          .from('recolecciones')
          .select()
          .eq('empleado_id', empleadoId)
          .order('fecha', ascending: false);

      return (response as List)
          .map((json) => RecoleccionModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Error al obtener recolecciones del empleado: $e');
    }
  }

  @override
  Future<List<RecoleccionEntity>> getRecoleccionesByFecha(String fincaId, DateTime fecha) async {
    try {
      final fechaStr = fecha.toIso8601String().split('T')[0];
      final response = await _supabase
          .from('recolecciones')
          .select('''
            *,
            empleados!inner(nombre)
          ''')
          .eq('finca_id', fincaId)
          .eq('fecha', fechaStr);

      return (response as List).map((json) {
        final empleadoNombre = json['empleados']?['nombre'] as String?;
        json['empleado_nombre'] = empleadoNombre;
        return RecoleccionModel.fromJson(json).toEntity();
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener recolecciones por fecha: $e');
    }
  }

  @override
  Future<List<RecoleccionEntity>> getRecoleccionesByRangoFecha(
    String fincaId,
    DateTime fechaInicio,
    DateTime fechaFin,
  ) async {
    try {
      final fechaInicioStr = fechaInicio.toIso8601String().split('T')[0];
      final fechaFinStr = fechaFin.toIso8601String().split('T')[0];
      
      final response = await _supabase
          .from('recolecciones')
          .select('''
            *,
            empleados!inner(nombre)
          ''')
          .eq('finca_id', fincaId)
          .gte('fecha', fechaInicioStr)
          .lte('fecha', fechaFinStr)
          .order('fecha', ascending: false);

      return (response as List).map((json) {
        final empleadoNombre = json['empleados']?['nombre'] as String?;
        json['empleado_nombre'] = empleadoNombre;
        return RecoleccionModel.fromJson(json).toEntity();
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener recolecciones por rango de fecha: $e');
    }
  }

  @override
  Future<RecoleccionEntity> createRecoleccion(RecoleccionEntity recoleccion) async {
    try {
      final model = RecoleccionModel(
        id: recoleccion.id,
        empleadoId: recoleccion.empleadoId,
        fincaId: recoleccion.fincaId,
        fecha: recoleccion.fecha,
        lote: recoleccion.lote,
        kilosRecolectados: recoleccion.kilosRecolectados,
        pagoDia: recoleccion.pagoDia,
        observaciones: recoleccion.observaciones,
        createdAt: recoleccion.createdAt,
      );

      final response = await _supabase
          .from('recolecciones')
          .insert(model.toJsonForInsert())
          .select()
          .single();

      return RecoleccionModel.fromJson(response).toEntity();
    } catch (e) {
      throw Exception('Error al crear recolección: $e');
    }
  }

  @override
  Future<RecoleccionEntity> updateRecoleccion(RecoleccionEntity recoleccion) async {
    try {
      final model = RecoleccionModel(
        id: recoleccion.id,
        empleadoId: recoleccion.empleadoId,
        fincaId: recoleccion.fincaId,
        fecha: recoleccion.fecha,
        lote: recoleccion.lote,
        kilosRecolectados: recoleccion.kilosRecolectados,
        pagoDia: recoleccion.pagoDia,
        observaciones: recoleccion.observaciones,
        createdAt: recoleccion.createdAt,
      );

      final response = await _supabase
          .from('recolecciones')
          .update(model.toJsonForInsert())
          .eq('id', recoleccion.id)
          .select()
          .single();

      return RecoleccionModel.fromJson(response).toEntity();
    } catch (e) {
      throw Exception('Error al actualizar recolección: $e');
    }
  }

  @override
  Future<void> deleteRecoleccion(String id) async {
    try {
      await _supabase.from('recolecciones').delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar recolección: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getEstadisticasRecoleccion(
    String fincaId,
    DateTime fechaInicio,
    DateTime fechaFin,
  ) async {
    try {
      final fechaInicioStr = fechaInicio.toIso8601String().split('T')[0];
      final fechaFinStr = fechaFin.toIso8601String().split('T')[0];

      final response = await _supabase
          .from('recolecciones')
          .select('kilos_recolectados')
          .eq('finca_id', fincaId)
          .gte('fecha', fechaInicioStr)
          .lte('fecha', fechaFinStr);

      final recolecciones = response as List;
      
      if (recolecciones.isEmpty) {
        return {
          'total_kilos': 0.0,
          'promedio_diario': 0.0,
          'total_registros': 0,
        };
      }

      final totalKilos = recolecciones.fold<double>(
        0.0,
        (sum, item) => sum + double.parse(item['kilos_recolectados'].toString()),
      );

      final dias = fechaFin.difference(fechaInicio).inDays + 1;
      final promedioDiario = totalKilos / dias;

      return {
        'total_kilos': totalKilos,
        'promedio_diario': promedioDiario,
        'total_registros': recolecciones.length,
      };
    } catch (e) {
      throw Exception('Error al obtener estadísticas: $e');
    }
  }
}
