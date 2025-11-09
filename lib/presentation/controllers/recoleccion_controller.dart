import 'package:get/get.dart';
import '../../domain/entities/recoleccion_entity.dart';
import '../../domain/usecases/recoleccion_usecases.dart';
import '../../data/repositories/recoleccion_repository_impl.dart';

class RecoleccionController extends GetxController {
  final RecoleccionUseCases _useCases = RecoleccionUseCases(RecoleccionRepositoryImpl());

  final RxList<RecoleccionEntity> recolecciones = <RecoleccionEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rx<Map<String, dynamic>> estadisticas = Rx<Map<String, dynamic>>({});

  String? currentFincaId;

  Future<void> loadRecolecciones(String fincaId) async {
    try {
      isLoading.value = true;
      error.value = '';
      currentFincaId = fincaId;
      
      recolecciones.value = await _useCases.getRecoleccionesByFinca(fincaId);
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudieron cargar las recolecciones');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadRecoleccionesByFecha(String fincaId, DateTime fecha) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      recolecciones.value = await _useCases.getRecoleccionesByFecha(fincaId, fecha);
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudieron cargar las recolecciones');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadRecoleccionesByRango(
    String fincaId,
    DateTime fechaInicio,
    DateTime fechaFin,
  ) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      recolecciones.value = await _useCases.getRecoleccionesByRangoFecha(
        fincaId,
        fechaInicio,
        fechaFin,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudieron cargar las recolecciones');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadRecoleccionesByEmpleado(String empleadoId) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      recolecciones.value = await _useCases.getRecoleccionesByEmpleado(empleadoId);
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudieron cargar las recolecciones del empleado');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createRecoleccion(RecoleccionEntity recoleccion) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _useCases.createRecoleccion(recoleccion);
      Get.snackbar('Éxito', 'Recolección registrada correctamente');
      
      if (currentFincaId != null) {
        await loadRecolecciones(currentFincaId!);
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudo registrar la recolección');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateRecoleccion(RecoleccionEntity recoleccion) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _useCases.updateRecoleccion(recoleccion);
      Get.snackbar('Éxito', 'Recolección actualizada correctamente');
      
      if (currentFincaId != null) {
        await loadRecolecciones(currentFincaId!);
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudo actualizar la recolección');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteRecoleccion(String id) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _useCases.deleteRecoleccion(id);
      Get.snackbar('Éxito', 'Recolección eliminada correctamente');
      
      if (currentFincaId != null) {
        await loadRecolecciones(currentFincaId!);
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudo eliminar la recolección');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadEstadisticas(
    String fincaId,
    DateTime fechaInicio,
    DateTime fechaFin,
  ) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      estadisticas.value = await _useCases.getEstadisticasRecoleccion(
        fincaId,
        fechaInicio,
        fechaFin,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudieron cargar las estadísticas');
    } finally {
      isLoading.value = false;
    }
  }
}
