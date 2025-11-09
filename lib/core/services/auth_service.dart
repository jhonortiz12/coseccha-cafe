import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

/// Servicio para gestionar la autenticación y persistencia de sesión
class AuthService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';

  /// Guardar estado de sesión
  static Future<void> saveSession({
    required String userId,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_userEmailKey, email);
  }

  /// Verificar si hay una sesión activa
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  /// Obtener el ID del usuario actual
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  /// Obtener el email del usuario actual
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  /// Cerrar sesión
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userEmailKey);
    await SupabaseConfig.client.auth.signOut();
  }

  /// Validar email con dominio @gmail.com
  static bool isValidGmailEmail(String email) {
    if (email.isEmpty) return false;
    
    // Verificar que termine con @gmail.com
    if (!email.toLowerCase().endsWith('@gmail.com')) {
      return false;
    }
    
    // Verificar formato básico de email
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    return emailRegex.hasMatch(email.toLowerCase());
  }

  /// Validar campos de login
  static String? validateLoginFields({
    required String email,
    required String password,
  }) {
    if (email.isEmpty || password.isEmpty) {
      return 'Por favor completa todos los campos';
    }
    
    if (!email.contains('@')) {
      return 'Por favor ingresa un correo electrónico válido';
    }
    
    if (password.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    
    return null;
  }

  /// Validar campos de registro
  static String? validateRegisterFields({
    required String name,
    required String email,
    required String password,
  }) {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return 'Por favor completa todos los campos';
    }
    
    if (name.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    
    if (!isValidGmailEmail(email)) {
      return 'El correo debe ser una cuenta de Gmail (@gmail.com)';
    }
    
    if (password.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    
    return null;
  }

  /// Obtener mensaje de error personalizado para excepciones de Supabase
  static String getErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('invalid login credentials') || 
        errorString.contains('invalid email or password')) {
      return 'Correo o contraseña incorrectos';
    }
    
    if (errorString.contains('email not confirmed')) {
      return 'Por favor confirma tu correo electrónico';
    }
    
    if (errorString.contains('user already registered') || 
        errorString.contains('email already exists')) {
      return 'Este correo ya está registrado';
    }
    
    if (errorString.contains('weak password')) {
      return 'La contraseña es muy débil. Usa al menos 6 caracteres';
    }
    
    if (errorString.contains('network')) {
      return 'Error de conexión. Verifica tu internet';
    }
    
    if (errorString.contains('timeout')) {
      return 'La solicitud tardó demasiado. Intenta nuevamente';
    }
    
    if (errorString.contains('rate limit')) {
      return 'Demasiados intentos. Espera un momento';
    }
    
    // Error genérico
    return 'Ocurrió un error. Por favor intenta nuevamente';
  }

  /// Verificar si el usuario actual de Supabase está autenticado
  static Future<User?> getCurrentUser() async {
    try {
      final user = SupabaseConfig.client.auth.currentUser;
      return user;
    } catch (e) {
      return null;
    }
  }
}
