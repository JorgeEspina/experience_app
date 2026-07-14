import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_providers.dart';
import 'auth_state.dart';

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final loginUseCase = ref.read(loginUseCaseProvider);
      final user = await loginUseCase(email: email, password: password);
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _parseError(e.toString()),
      );
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final registerUseCase = ref.read(registerUseCaseProvider);
      final user = await registerUseCase(
        name: name,
        email: email,
        password: password,
      );
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _parseError(e.toString()),
      );
      return false;
    }
  }

  Future<void> logout() async {
    final logoutUseCase = ref.read(logoutUseCaseProvider);
    await logoutUseCase();
    state = const AuthState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  String _parseError(String error) {
    if (error.contains('user-not-found')) return 'User not found';
    if (error.contains('wrong-password')) return 'Wrong password';
    if (error.contains('email-already-in-use')) return 'Email already in use';
    if (error.contains('weak-password')) return 'Password is too weak';
    if (error.contains('invalid-email')) return 'Invalid email address';
    return 'An error occurred. Please try again.';
  }
}
