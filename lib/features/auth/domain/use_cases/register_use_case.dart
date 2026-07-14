import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  const RegisterUseCase({required this.repository});

  final AuthRepository repository;

  Future<UserEntity> call({
    required String name,
    required String email,
    required String password,
  }) async {
    return repository.register(name: name, email: email, password: password);
  }
}
