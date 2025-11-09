import 'package:shared_preferences/shared_preferences.dart';

/// Servicio para gestionar la persistencia de la finca seleccionada
class FincaPreferencesService {
  static const String _fincaIdKey = 'selected_finca_id';
  static const String _fincaNombreKey = 'selected_finca_nombre';

  /// Guardar la finca seleccionada
  static Future<void> saveFincaSeleccionada({
    required String fincaId,
    required String fincaNombre,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fincaIdKey, fincaId);
    await prefs.setString(_fincaNombreKey, fincaNombre);
  }

  /// Obtener el ID de la finca seleccionada
  static Future<String?> getFincaId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fincaIdKey);
  }

  /// Obtener el nombre de la finca seleccionada
  static Future<String?> getFincaNombre() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fincaNombreKey);
  }

  /// Obtener ambos valores de la finca seleccionada
  static Future<Map<String, String>?> getFincaSeleccionada() async {
    final prefs = await SharedPreferences.getInstance();
    final fincaId = prefs.getString(_fincaIdKey);
    final fincaNombre = prefs.getString(_fincaNombreKey);

    if (fincaId != null && fincaNombre != null) {
      return {
        'id': fincaId,
        'nombre': fincaNombre,
      };
    }
    return null;
  }

  /// Limpiar la finca seleccionada (al cerrar sesión)
  static Future<void> clearFincaSeleccionada() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_fincaIdKey);
    await prefs.remove(_fincaNombreKey);
  }

  /// Verificar si hay una finca seleccionada
  static Future<bool> hasFincaSeleccionada() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_fincaIdKey);
  }
}
