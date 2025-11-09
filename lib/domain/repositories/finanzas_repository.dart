import '../entities/gasto_entity.dart';
import '../entities/ingreso_entity.dart';
import '../entities/categoria_financiera_entity.dart';

abstract class FinanzasRepository {
  // Gastos
  Future<List<GastoEntity>> getGastosByFinca(String fincaId);
  Future<List<GastoEntity>> getGastosByRangoFecha(
    String fincaId, 
    DateTime fechaInicio, 
    DateTime fechaFin
  );
  Future<GastoEntity> createGasto(GastoEntity gasto);
  Future<GastoEntity> updateGasto(GastoEntity gasto);
  Future<void> deleteGasto(String id);

  // Ingresos
  Future<List<IngresoEntity>> getIngresosByFinca(String fincaId);
  Future<List<IngresoEntity>> getIngresosByRangoFecha(
    String fincaId, 
    DateTime fechaInicio, 
    DateTime fechaFin
  );
  Future<IngresoEntity> createIngreso(IngresoEntity ingreso);
  Future<IngresoEntity> updateIngreso(IngresoEntity ingreso);
  Future<void> deleteIngreso(String id);

  // Categorías
  Future<List<CategoriaFinancieraEntity>> getCategorias();
  Future<List<CategoriaFinancieraEntity>> getCategoriasByTipo(TipoCategoria tipo);
  Future<CategoriaFinancieraEntity> createCategoria(CategoriaFinancieraEntity categoria);
  
  // Estadísticas
  Future<Map<String, dynamic>> getResumenFinanciero(
    String fincaId, 
    DateTime fechaInicio, 
    DateTime fechaFin
  );
}
