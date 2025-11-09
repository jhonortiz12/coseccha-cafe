import '../../domain/entities/gasto_entity.dart';
import '../../domain/entities/ingreso_entity.dart';
import '../../domain/entities/categoria_financiera_entity.dart';
import '../../domain/repositories/finanzas_repository.dart';
import '../../core/config/supabase_config.dart';
import '../models/gasto_model.dart';
import '../models/ingreso_model.dart';
import '../models/categoria_financiera_model.dart';

class FinanzasRepositoryImpl implements FinanzasRepository {
  final _supabase = SupabaseConfig.client;

  // ==================== GASTOS ====================
  
  @override
  Future<List<GastoEntity>> getGastosByFinca(String fincaId) async {
    try {
      final response = await _supabase
          .from('gastos')
          .select('''
            *,
            categorias_financieras(nombre)
          ''')
          .eq('finca_id', fincaId)
          .order('fecha', ascending: false);

      return (response as List).map((json) {
        final categoriaNombre = json['categorias_financieras']?['nombre'] as String?;
        json['categoria_nombre'] = categoriaNombre;
        return GastoModel.fromJson(json).toEntity();
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener gastos: $e');
    }
  }

  @override
  Future<List<GastoEntity>> getGastosByRangoFecha(
    String fincaId,
    DateTime fechaInicio,
    DateTime fechaFin,
  ) async {
    try {
      final fechaInicioStr = fechaInicio.toIso8601String().split('T')[0];
      final fechaFinStr = fechaFin.toIso8601String().split('T')[0];

      final response = await _supabase
          .from('gastos')
          .select('''
            *,
            categorias_financieras(nombre)
          ''')
          .eq('finca_id', fincaId)
          .gte('fecha', fechaInicioStr)
          .lte('fecha', fechaFinStr)
          .order('fecha', ascending: false);

      return (response as List).map((json) {
        final categoriaNombre = json['categorias_financieras']?['nombre'] as String?;
        json['categoria_nombre'] = categoriaNombre;
        return GastoModel.fromJson(json).toEntity();
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener gastos por rango: $e');
    }
  }

  @override
  Future<GastoEntity> createGasto(GastoEntity gasto) async {
    try {
      final model = GastoModel(
        id: gasto.id,
        fincaId: gasto.fincaId,
        categoriaId: gasto.categoriaId,
        fecha: gasto.fecha,
        descripcion: gasto.descripcion,
        monto: gasto.monto,
        proveedor: gasto.proveedor,
        comprobanteUrl: gasto.comprobanteUrl,
        observaciones: gasto.observaciones,
        createdAt: gasto.createdAt,
      );

      final response = await _supabase
          .from('gastos')
          .insert(model.toJsonForInsert())
          .select()
          .single();

      return GastoModel.fromJson(response).toEntity();
    } catch (e) {
      throw Exception('Error al crear gasto: $e');
    }
  }

  @override
  Future<GastoEntity> updateGasto(GastoEntity gasto) async {
    try {
      final model = GastoModel(
        id: gasto.id,
        fincaId: gasto.fincaId,
        categoriaId: gasto.categoriaId,
        fecha: gasto.fecha,
        descripcion: gasto.descripcion,
        monto: gasto.monto,
        proveedor: gasto.proveedor,
        comprobanteUrl: gasto.comprobanteUrl,
        observaciones: gasto.observaciones,
        createdAt: gasto.createdAt,
      );

      final response = await _supabase
          .from('gastos')
          .update(model.toJsonForInsert())
          .eq('id', gasto.id)
          .select()
          .single();

      return GastoModel.fromJson(response).toEntity();
    } catch (e) {
      throw Exception('Error al actualizar gasto: $e');
    }
  }

  @override
  Future<void> deleteGasto(String id) async {
    try {
      await _supabase.from('gastos').delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar gasto: $e');
    }
  }

  // ==================== INGRESOS ====================

  @override
  Future<List<IngresoEntity>> getIngresosByFinca(String fincaId) async {
    try {
      final response = await _supabase
          .from('ingresos')
          .select('''
            *,
            categorias_financieras(nombre)
          ''')
          .eq('finca_id', fincaId)
          .order('fecha', ascending: false);

      return (response as List).map((json) {
        final categoriaNombre = json['categorias_financieras']?['nombre'] as String?;
        json['categoria_nombre'] = categoriaNombre;
        return IngresoModel.fromJson(json).toEntity();
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener ingresos: $e');
    }
  }

  @override
  Future<List<IngresoEntity>> getIngresosByRangoFecha(
    String fincaId,
    DateTime fechaInicio,
    DateTime fechaFin,
  ) async {
    try {
      final fechaInicioStr = fechaInicio.toIso8601String().split('T')[0];
      final fechaFinStr = fechaFin.toIso8601String().split('T')[0];

      final response = await _supabase
          .from('ingresos')
          .select('''
            *,
            categorias_financieras(nombre)
          ''')
          .eq('finca_id', fincaId)
          .gte('fecha', fechaInicioStr)
          .lte('fecha', fechaFinStr)
          .order('fecha', ascending: false);

      return (response as List).map((json) {
        final categoriaNombre = json['categorias_financieras']?['nombre'] as String?;
        json['categoria_nombre'] = categoriaNombre;
        return IngresoModel.fromJson(json).toEntity();
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener ingresos por rango: $e');
    }
  }

  @override
  Future<IngresoEntity> createIngreso(IngresoEntity ingreso) async {
    try {
      final model = IngresoModel(
        id: ingreso.id,
        fincaId: ingreso.fincaId,
        categoriaId: ingreso.categoriaId,
        fecha: ingreso.fecha,
        descripcion: ingreso.descripcion,
        cantidadKg: ingreso.cantidadKg,
        precioKg: ingreso.precioKg,
        total: ingreso.total,
        metodoPago: ingreso.metodoPago,
        observaciones: ingreso.observaciones,
        createdAt: ingreso.createdAt,
      );

      final response = await _supabase
          .from('ingresos')
          .insert(model.toJsonForInsert())
          .select()
          .single();

      return IngresoModel.fromJson(response).toEntity();
    } catch (e) {
      throw Exception('Error al crear ingreso: $e');
    }
  }

  @override
  Future<IngresoEntity> updateIngreso(IngresoEntity ingreso) async {
    try {
      final model = IngresoModel(
        id: ingreso.id,
        fincaId: ingreso.fincaId,
        categoriaId: ingreso.categoriaId,
        fecha: ingreso.fecha,
        descripcion: ingreso.descripcion,
        cantidadKg: ingreso.cantidadKg,
        precioKg: ingreso.precioKg,
        total: ingreso.total,
        metodoPago: ingreso.metodoPago,
        observaciones: ingreso.observaciones,
        createdAt: ingreso.createdAt,
      );

      final response = await _supabase
          .from('ingresos')
          .update(model.toJsonForInsert())
          .eq('id', ingreso.id)
          .select()
          .single();

      return IngresoModel.fromJson(response).toEntity();
    } catch (e) {
      throw Exception('Error al actualizar ingreso: $e');
    }
  }

  @override
  Future<void> deleteIngreso(String id) async {
    try {
      await _supabase.from('ingresos').delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar ingreso: $e');
    }
  }

  // ==================== CATEGORÍAS ====================

  @override
  Future<List<CategoriaFinancieraEntity>> getCategorias() async {
    try {
      final response = await _supabase
          .from('categorias_financieras')
          .select()
          .order('nombre', ascending: true);

      return (response as List)
          .map((json) => CategoriaFinancieraModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Error al obtener categorías: $e');
    }
  }

  @override
  Future<List<CategoriaFinancieraEntity>> getCategoriasByTipo(TipoCategoria tipo) async {
    try {
      final response = await _supabase
          .from('categorias_financieras')
          .select()
          .eq('tipo', tipo.name)
          .order('nombre', ascending: true);

      return (response as List)
          .map((json) => CategoriaFinancieraModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Error al obtener categorías por tipo: $e');
    }
  }

  @override
  Future<CategoriaFinancieraEntity> createCategoria(CategoriaFinancieraEntity categoria) async {
    try {
      final model = CategoriaFinancieraModel(
        id: categoria.id,
        nombre: categoria.nombre,
        tipo: categoria.tipo,
        descripcion: categoria.descripcion,
        createdAt: categoria.createdAt,
      );

      final response = await _supabase
          .from('categorias_financieras')
          .insert(model.toJsonForInsert())
          .select()
          .single();

      return CategoriaFinancieraModel.fromJson(response).toEntity();
    } catch (e) {
      throw Exception('Error al crear categoría: $e');
    }
  }

  // ==================== ESTADÍSTICAS ====================

  @override
  Future<Map<String, dynamic>> getResumenFinanciero(
    String fincaId,
    DateTime fechaInicio,
    DateTime fechaFin,
  ) async {
    try {
      final fechaInicioStr = fechaInicio.toIso8601String().split('T')[0];
      final fechaFinStr = fechaFin.toIso8601String().split('T')[0];

      // Obtener gastos
      final gastosResponse = await _supabase
          .from('gastos')
          .select('monto')
          .eq('finca_id', fincaId)
          .gte('fecha', fechaInicioStr)
          .lte('fecha', fechaFinStr);

      final totalGastos = (gastosResponse as List).fold<double>(
        0.0,
        (sum, item) => sum + double.parse(item['monto'].toString()),
      );

      // Obtener ingresos
      final ingresosResponse = await _supabase
          .from('ingresos')
          .select('total')
          .eq('finca_id', fincaId)
          .gte('fecha', fechaInicioStr)
          .lte('fecha', fechaFinStr);

      final totalIngresos = (ingresosResponse as List).fold<double>(
        0.0,
        (sum, item) {
          final total = item['total'];
          return sum + (total != null ? double.parse(total.toString()) : 0.0);
        },
      );

      final balance = totalIngresos - totalGastos;

      return {
        'total_ingresos': totalIngresos,
        'total_gastos': totalGastos,
        'balance': balance,
        'cantidad_ingresos': (ingresosResponse as List).length,
        'cantidad_gastos': (gastosResponse as List).length,
      };
    } catch (e) {
      throw Exception('Error al obtener resumen financiero: $e');
    }
  }
}
