import '../repositories/auth_repository.dart';

class LogoutUseCase {
  const LogoutUseCase({required this.repository});

  final AuthRepository repository;

  Future<void> call() async {
    return repository.logout();
  }
}
