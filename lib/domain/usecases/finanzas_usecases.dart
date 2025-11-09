import '../entities/gasto_entity.dart';
import '../entities/ingreso_entity.dart';
import '../entities/categoria_financiera_entity.dart';
import '../repositories/finanzas_repository.dart';

class FinanzasUseCases {
  final FinanzasRepository repository;

  FinanzasUseCases(this.repository);

  // Gastos
  Future<List<GastoEntity>> getGastosByFinca(String fincaId) {
    return repository.getGastosByFinca(fincaId);
  }

  Future<List<GastoEntity>> getGastosByRangoFecha(
    String fincaId,
    DateTime fechaInicio,
    DateTime fechaFin,
  ) {
    return repository.getGastosByRangoFecha(fincaId, fechaInicio, fechaFin);
  }

  Future<GastoEntity> createGasto(GastoEntity gasto) {
    return repository.createGasto(gasto);
  }

  Future<GastoEntity> updateGasto(GastoEntity gasto) {
    return repository.updateGasto(gasto);
  }

  Future<void> deleteGasto(String id) {
    return repository.deleteGasto(id);
  }

  // Ingresos
  Future<List<IngresoEntity>> getIngresosByFinca(String fincaId) {
    return repository.getIngresosByFinca(fincaId);
  }

  Future<List<IngresoEntity>> getIngresosByRangoFecha(
    String fincaId,
    DateTime fechaInicio,
    DateTime fechaFin,
  ) {
    return repository.getIngresosByRangoFecha(fincaId, fechaInicio, fechaFin);
  }

  Future<IngresoEntity> createIngreso(IngresoEntity ingreso) {
    return repository.createIngreso(ingreso);
  }

  Future<IngresoEntity> updateIngreso(IngresoEntity ingreso) {
    return repository.updateIngreso(ingreso);
  }

  Future<void> deleteIngreso(String id) {
    return repository.deleteIngreso(id);
  }

  // Categorías
  Future<List<CategoriaFinancieraEntity>> getCategorias() {
    return repository.getCategorias();
  }

  Future<List<CategoriaFinancieraEntity>> getCategoriasByTipo(TipoCategoria tipo) {
    return repository.getCategoriasByTipo(tipo);
  }

  Future<CategoriaFinancieraEntity> createCategoria(CategoriaFinancieraEntity categoria) {
    return repository.createCategoria(categoria);
  }

  // Estadísticas
  Future<Map<String, dynamic>> getResumenFinanciero(
    String fincaId,
    DateTime fechaInicio,
    DateTime fechaFin,
  ) {
    return repository.getResumenFinanciero(fincaId, fechaInicio, fechaFin);
  }
}
