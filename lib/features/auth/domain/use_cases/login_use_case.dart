import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase({required this.repository});

  final AuthRepository repository;

  Future<UserEntity> call({
    required String email,
    required String password,
  }) async {
    return repository.login(email: email, password: password);
  }
}
