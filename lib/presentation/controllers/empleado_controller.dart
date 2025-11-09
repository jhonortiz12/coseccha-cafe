import 'package:get/get.dart';
import '../../domain/entities/empleado_entity.dart';
import '../../domain/usecases/empleado_usecases.dart';
import '../../data/repositories/empleado_repository_impl.dart';

class EmpleadoController extends GetxController {
  final EmpleadoUseCases _useCases = EmpleadoUseCases(EmpleadoRepositoryImpl());

  final RxList<EmpleadoEntity> empleados = <EmpleadoEntity>[].obs;
  final RxList<EmpleadoEntity> empleadosActivos = <EmpleadoEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  String? currentFincaId;

  Future<void> loadEmpleados(String fincaId) async {
    try {
      isLoading.value = true;
      error.value = '';
      currentFincaId = fincaId;
      
      empleados.value = await _useCases.getEmpleadosByFinca(fincaId);
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudieron cargar los empleados');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadEmpleadosActivos(String fincaId) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      empleadosActivos.value = await _useCases.getEmpleadosActivos(fincaId);
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudieron cargar los empleados activos');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createEmpleado(EmpleadoEntity empleado) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _useCases.createEmpleado(empleado);
      Get.snackbar('Éxito', 'Empleado creado correctamente');
      
      if (currentFincaId != null) {
        await loadEmpleados(currentFincaId!);
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudo crear el empleado');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateEmpleado(EmpleadoEntity empleado) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _useCases.updateEmpleado(empleado);
      Get.snackbar('Éxito', 'Empleado actualizado correctamente');
      
      if (currentFincaId != null) {
        await loadEmpleados(currentFincaId!);
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudo actualizar el empleado');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteEmpleado(String id) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _useCases.deleteEmpleado(id);
      Get.snackbar('Éxito', 'Empleado eliminado correctamente');
      
      if (currentFincaId != null) {
        await loadEmpleados(currentFincaId!);
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudo eliminar el empleado');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchEmpleados(String fincaId, String query) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      if (query.isEmpty) {
        await loadEmpleados(fincaId);
      } else {
        empleados.value = await _useCases.searchEmpleados(fincaId, query);
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Error en la búsqueda');
    } finally {
      isLoading.value = false;
    }
  }
}
