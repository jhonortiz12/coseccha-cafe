import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

/// Servicio para monitorear el estado de conectividad
class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  final RxBool isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      print('Error al verificar conectividad: $e');
      isOnline.value = false;
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // Si hay al menos una conexión activa (WiFi, móvil, etc.)
    isOnline.value = results.any((result) => 
      result == ConnectivityResult.wifi || 
      result == ConnectivityResult.mobile ||
      result == ConnectivityResult.ethernet
    );
    
    print('📡 Estado de conectividad: ${isOnline.value ? "ONLINE" : "OFFLINE"}');
  }

  Future<bool> checkConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result.any((r) => 
        r == ConnectivityResult.wifi || 
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.ethernet
      );
    } catch (e) {
      return false;
    }
  }
}
