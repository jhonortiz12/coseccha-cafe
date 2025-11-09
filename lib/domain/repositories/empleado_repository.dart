import '../entities/empleado_entity.dart';

abstract class EmpleadoRepository {
  Future<List<EmpleadoEntity>> getEmpleadosByFinca(String fincaId);
  Future<EmpleadoEntity> getEmpleadoById(String id);
  Future<EmpleadoEntity> createEmpleado(EmpleadoEntity empleado);
  Future<EmpleadoEntity> updateEmpleado(EmpleadoEntity empleado);
  Future<void> deleteEmpleado(String id);
  Future<List<EmpleadoEntity>> getEmpleadosActivos(String fincaId);
  Future<List<EmpleadoEntity>> searchEmpleados(String fincaId, String query);
}
