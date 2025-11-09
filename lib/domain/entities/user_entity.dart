class UserEntity {
  final String id;
  final String email;
  final String? name;
  final DateTime? createdAt;

  UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.createdAt,
  });
}