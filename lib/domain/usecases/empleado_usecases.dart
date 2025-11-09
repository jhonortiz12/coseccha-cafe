import '../entities/empleado_entity.dart';
import '../repositories/empleado_repository.dart';

class EmpleadoUseCases {
  final EmpleadoRepository repository;

  EmpleadoUseCases(this.repository);

  Future<List<EmpleadoEntity>> getEmpleadosByFinca(String fincaId) {
    return repository.getEmpleadosByFinca(fincaId);
  }

  Future<EmpleadoEntity> getEmpleadoById(String id) {
    return repository.getEmpleadoById(id);
  }

  Future<EmpleadoEntity> createEmpleado(EmpleadoEntity empleado) {
    return repository.createEmpleado(empleado);
  }

  Future<EmpleadoEntity> updateEmpleado(EmpleadoEntity empleado) {
    return repository.updateEmpleado(empleado);
  }

  Future<void> deleteEmpleado(String id) {
    return repository.deleteEmpleado(id);
  }

  Future<List<EmpleadoEntity>> getEmpleadosActivos(String fincaId) {
    return repository.getEmpleadosActivos(fincaId);
  }

  Future<List<EmpleadoEntity>> searchEmpleados(String fincaId, String query) {
    return repository.searchEmpleados(fincaId, query);
  }
}
