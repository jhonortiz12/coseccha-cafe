import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class AuthUseCases {
  final AuthRepository repository;

  AuthUseCases(this.repository);

  Future<UserEntity> signIn(String email, String password) {
    return repository.signIn(email, password);
  }

  Future<UserEntity> signUp(String email, String password, String name) {
    return repository.signUp(email, password, name);
  }

  Future<void> signOut() {
    return repository.signOut();
  }

  Future<UserEntity?> getCurrentUser() {
    return repository.getCurrentUser();
  }
}