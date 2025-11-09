import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/config/supabase_config.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _client = SupabaseConfig.client;

  @override
  Future<UserEntity> signIn(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      final user = response.user;
      if (user == null) throw Exception('Usuario no encontrado');
      
      return UserEntity(
        id: user.id,
        email: user.email ?? '',
        name: user.userMetadata?['nombre']?.toString(),
        createdAt: user.createdAt,
      );
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  @override
  Future<UserEntity> signUp(String email, String password, String name) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'nombre': name,
        },
      );
      
      final user = response.user;
      if (user == null) throw Exception('No se pudo crear el usuario');
      
      return UserEntity(
        id: user.id,
        email: user.email ?? '',
        name: name,
        createdAt: user.createdAt,
      );
    } catch (e) {
      throw Exception('Error al registrar usuario: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    
    return UserEntity(
      id: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['nombre']?.toString(),
      createdAt: user.createdAt,
    );
  }
}