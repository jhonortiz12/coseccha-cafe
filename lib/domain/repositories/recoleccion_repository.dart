import '../entities/recoleccion_entity.dart';

abstract class RecoleccionRepository {
  Future<List<RecoleccionEntity>> getRecoleccionesByFinca(String fincaId);
  Future<List<RecoleccionEntity>> getRecoleccionesByEmpleado(String empleadoId);
  Future<List<RecoleccionEntity>> getRecoleccionesByFecha(String fincaId, DateTime fecha);
  Future<List<RecoleccionEntity>> getRecoleccionesByRangoFecha(
    String fincaId, 
    DateTime fechaInicio, 
    DateTime fechaFin
  );
  Future<RecoleccionEntity> createRecoleccion(RecoleccionEntity recoleccion);
  Future<RecoleccionEntity> updateRecoleccion(RecoleccionEntity recoleccion);
  Future<void> deleteRecoleccion(String id);
  Future<Map<String, dynamic>> getEstadisticasRecoleccion(
    String fincaId, 
    DateTime fechaInicio, 
    DateTime fechaFin
  );
}
