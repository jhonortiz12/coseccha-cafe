import 'package:get/get.dart';
import '../../domain/entities/gasto_entity.dart';
import '../../domain/entities/ingreso_entity.dart';
import '../../domain/entities/categoria_financiera_entity.dart';
import '../../domain/usecases/finanzas_usecases.dart';
import '../../data/repositories/finanzas_repository_impl.dart';

class FinanzasController extends GetxController {
  final FinanzasUseCases _useCases = FinanzasUseCases(FinanzasRepositoryImpl());

  final RxList<GastoEntity> gastos = <GastoEntity>[].obs;
  final RxList<IngresoEntity> ingresos = <IngresoEntity>[].obs;
  final RxList<CategoriaFinancieraEntity> categorias = <CategoriaFinancieraEntity>[].obs;
  final RxList<CategoriaFinancieraEntity> categoriasGasto = <CategoriaFinancieraEntity>[].obs;
  final RxList<CategoriaFinancieraEntity> categoriasIngreso = <CategoriaFinancieraEntity>[].obs;
  
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rx<Map<String, dynamic>> resumenFinanciero = Rx<Map<String, dynamic>>({});

  String? currentFincaId;

  @override
  void onInit() {
    super.onInit();
    loadCategorias();
  }

  // ==================== GASTOS ====================

  Future<void> loadGastos(String fincaId) async {
    try {
      isLoading.value = true;
      error.value = '';
      currentFincaId = fincaId;
      
      gastos.value = await _useCases.getGastosByFinca(fincaId);
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudieron cargar los gastos');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadGastosByRango(
    String fincaId,
    DateTime fechaInicio,
    DateTime fechaFin,
  ) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      gastos.value = await _useCases.getGastosByRangoFecha(
        fincaId,
        fechaInicio,
        fechaFin,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudieron cargar los gastos');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createGasto(GastoEntity gasto) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _useCases.createGasto(gasto);
      Get.snackbar('Éxito', 'Gasto registrado correctamente');
      
      if (currentFincaId != null) {
        await loadGastos(currentFincaId!);
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudo registrar el gasto');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateGasto(GastoEntity gasto) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _useCases.updateGasto(gasto);
      Get.snackbar('Éxito', 'Gasto actualizado correctamente');
      
      if (currentFincaId != null) {
        await loadGastos(currentFincaId!);
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudo actualizar el gasto');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteGasto(String id) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _useCases.deleteGasto(id);
      Get.snackbar('Éxito', 'Gasto eliminado correctamente');
      
      if (currentFincaId != null) {
        await loadGastos(currentFincaId!);
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudo eliminar el gasto');
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== INGRESOS ====================

  Future<void> loadIngresos(String fincaId) async {
    try {
      isLoading.value = true;
      error.value = '';
      currentFincaId = fincaId;
      
      ingresos.value = await _useCases.getIngresosByFinca(fincaId);
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudieron cargar los ingresos');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadIngresosByRango(
    String fincaId,
    DateTime fechaInicio,
    DateTime fechaFin,
  ) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      ingresos.value = await _useCases.getIngresosByRangoFecha(
        fincaId,
        fechaInicio,
        fechaFin,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudieron cargar los ingresos');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createIngreso(IngresoEntity ingreso) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _useCases.createIngreso(ingreso);
      Get.snackbar('Éxito', 'Ingreso registrado correctamente');
      
      if (currentFincaId != null) {
        await loadIngresos(currentFincaId!);
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudo registrar el ingreso');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateIngreso(IngresoEntity ingreso) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _useCases.updateIngreso(ingreso);
      Get.snackbar('Éxito', 'Ingreso actualizado correctamente');
      
      if (currentFincaId != null) {
        await loadIngresos(currentFincaId!);
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudo actualizar el ingreso');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteIngreso(String id) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _useCases.deleteIngreso(id);
      Get.snackbar('Éxito', 'Ingreso eliminado correctamente');
      
      if (currentFincaId != null) {
        await loadIngresos(currentFincaId!);
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudo eliminar el ingreso');
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== CATEGORÍAS ====================

  Future<void> loadCategorias() async {
    try {
      categorias.value = await _useCases.getCategorias();
      categoriasGasto.value = await _useCases.getCategoriasByTipo(TipoCategoria.gasto);
      categoriasIngreso.value = await _useCases.getCategoriasByTipo(TipoCategoria.ingreso);
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudieron cargar las categorías');
    }
  }

  Future<void> createCategoria(CategoriaFinancieraEntity categoria) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _useCases.createCategoria(categoria);
      Get.snackbar('Éxito', 'Categoría creada correctamente');
      await loadCategorias();
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudo crear la categoría');
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== ESTADÍSTICAS ====================

  Future<void> loadResumenFinanciero(
    String fincaId,
    DateTime fechaInicio,
    DateTime fechaFin,
  ) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      resumenFinanciero.value = await _useCases.getResumenFinanciero(
        fincaId,
        fechaInicio,
        fechaFin,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'No se pudo cargar el resumen financiero');
    } finally {
      isLoading.value = false;
    }
  }
}
