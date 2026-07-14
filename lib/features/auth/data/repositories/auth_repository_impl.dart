import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required this.remoteDataSource});

  final AuthRemoteDataSource remoteDataSource;

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final model = await remoteDataSource.login(
      email: email,
      password: password,
    );
    return model.toEntity();
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final model = await remoteDataSource.register(
      name: name,
      email: email,
      password: password,
    );
    return model.toEntity();
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final model = await remoteDataSource.getCurrentUser();
    return model?.toEntity();
  }
}
