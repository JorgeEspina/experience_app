/// Roles supported by the app.
enum UserRole { admin, client }

class UserEntity {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.role = UserRole.client,
  });

  final String id;
  final String name;
  final String email;
  final UserRole role;

  bool get isAdmin => role == UserRole.admin;
  bool get isClient => role == UserRole.client;
}
