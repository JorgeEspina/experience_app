import '../../domain/entities/user_entity.dart';

class AuthState {
  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  final UserEntity? user;
  final bool isLoading;
  final String? error;

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    UserEntity? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
