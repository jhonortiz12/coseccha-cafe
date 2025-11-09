import '../entities/recoleccion_entity.dart';
import '../repositories/recoleccion_repository.dart';

class RecoleccionUseCases {
  final RecoleccionRepository repository;

  RecoleccionUseCases(this.repository);

  Future<List<RecoleccionEntity>> getRecoleccionesByFinca(String fincaId) {
    return repository.getRecoleccionesByFinca(fincaId);
  }

  Future<List<RecoleccionEntity>> getRecoleccionesByEmpleado(String empleadoId) {
    return repository.getRecoleccionesByEmpleado(empleadoId);
  }

  Future<List<RecoleccionEntity>> getRecoleccionesByFecha(String fincaId, DateTime fecha) {
    return repository.getRecoleccionesByFecha(fincaId, fecha);
  }

  Future<List<RecoleccionEntity>> getRecoleccionesByRangoFecha(
    String fincaId,
    DateTime fechaInicio,
    DateTime fechaFin,
  ) {
    return repository.getRecoleccionesByRangoFecha(fincaId, fechaInicio, fechaFin);
  }

  Future<RecoleccionEntity> createRecoleccion(RecoleccionEntity recoleccion) {
    return repository.createRecoleccion(recoleccion);
  }

  Future<RecoleccionEntity> updateRecoleccion(RecoleccionEntity recoleccion) {
    return repository.updateRecoleccion(recoleccion);
  }

  Future<void> deleteRecoleccion(String id) {
    return repository.deleteRecoleccion(id);
  }

  Future<Map<String, dynamic>> getEstadisticasRecoleccion(
    String fincaId,
    DateTime fechaInicio,
    DateTime fechaFin,
  ) {
    return repository.getEstadisticasRecoleccion(fincaId, fechaInicio, fechaFin);
  }
}
