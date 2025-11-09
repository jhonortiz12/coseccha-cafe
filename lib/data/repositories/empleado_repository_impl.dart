import '../../domain/entities/empleado_entity.dart';
import '../../domain/repositories/empleado_repository.dart';
import '../../core/config/supabase_config.dart';
import '../models/empleado_model.dart';

class EmpleadoRepositoryImpl implements EmpleadoRepository {
  final _supabase = SupabaseConfig.client;

  @override
  Future<List<EmpleadoEntity>> getEmpleadosByFinca(String fincaId) async {
    try {
      final response = await _supabase
          .from('empleados')
          .select()
          .eq('finca_id', fincaId)
          .order('nombre', ascending: true);

      return (response as List)
          .map((json) => EmpleadoModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Error al obtener empleados: $e');
    }
  }

  @override
  Future<EmpleadoEntity> getEmpleadoById(String id) async {
    try {
      final response = await _supabase
          .from('empleados')
          .select()
          .eq('id', id)
          .single();

      return EmpleadoModel.fromJson(response).toEntity();
    } catch (e) {
      throw Exception('Error al obtener empleado: $e');
    }
  }

  @override
  Future<EmpleadoEntity> createEmpleado(EmpleadoEntity empleado) async {
    try {
      final model = EmpleadoModel(
        id: empleado.id,
        fincaId: empleado.fincaId,
        nombre: empleado.nombre,
        cedula: empleado.cedula,
        tipoEmpleado: empleado.tipoEmpleado,
        cargo: empleado.cargo,
        salario: empleado.salario,
        fechaContratacion: empleado.fechaContratacion,
        activo: empleado.activo,
        createdAt: empleado.createdAt,
      );

      final response = await _supabase
          .from('empleados')
          .insert(model.toJsonForInsert())
          .select()
          .single();

      return EmpleadoModel.fromJson(response).toEntity();
    } catch (e) {
      throw Exception('Error al crear empleado: $e');
    }
  }

  @override
  Future<EmpleadoEntity> updateEmpleado(EmpleadoEntity empleado) async {
    try {
      final model = EmpleadoModel(
        id: empleado.id,
        fincaId: empleado.fincaId,
        nombre: empleado.nombre,
        cedula: empleado.cedula,
        tipoEmpleado: empleado.tipoEmpleado,
        cargo: empleado.cargo,
        salario: empleado.salario,
        fechaContratacion: empleado.fechaContratacion,
        activo: empleado.activo,
        createdAt: empleado.createdAt,
      );

      final response = await _supabase
          .from('empleados')
          .update(model.toJsonForInsert())
          .eq('id', empleado.id)
          .select()
          .single();

      return EmpleadoModel.fromJson(response).toEntity();
    } catch (e) {
      throw Exception('Error al actualizar empleado: $e');
    }
  }

  @override
  Future<void> deleteEmpleado(String id) async {
    try {
      await _supabase.from('empleados').delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar empleado: $e');
    }
  }

  @override
  Future<List<EmpleadoEntity>> getEmpleadosActivos(String fincaId) async {
    try {
      print('🔍 REPO: Consultando empleados activos para finca: $fincaId');
      
      final response = await _supabase
          .from('empleados')
          .select()
          .eq('finca_id', fincaId)
          .eq('activo', true)
          .order('nombre', ascending: true);

      print('📊 REPO: Respuesta de Supabase: ${response.length} empleados');
      print('📋 REPO: Datos completos: $response');

      final empleados = (response as List)
          .map((json) => EmpleadoModel.fromJson(json).toEntity())
          .toList();
      
      print('✅ REPO: Empleados procesados: ${empleados.length}');
      
      return empleados;
    } catch (e) {
      print('❌ REPO: Error al obtener empleados activos: $e');
      throw Exception('Error al obtener empleados activos: $e');
    }
  }

  @override
  Future<List<EmpleadoEntity>> searchEmpleados(String fincaId, String query) async {
    try {
      final response = await _supabase
          .from('empleados')
          .select()
          .eq('finca_id', fincaId)
          .or('nombre.ilike.%$query%,cedula.ilike.%$query%')
          .order('nombre', ascending: true);

      return (response as List)
          .map((json) => EmpleadoModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Error al buscar empleados: $e');
    }
  }
}
