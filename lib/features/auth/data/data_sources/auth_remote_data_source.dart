import '../models/user_model.dart';

/// Data source for authentication.
/// Currently uses mock data. Replace with Firebase when configured:
/// - Import 'package:firebase_auth/firebase_auth.dart'
/// - Use FirebaseAuth.instance methods
class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // TODO: Replace with Firebase Auth when configured
    // final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    //   email: email, password: password,
    // );
    await Future.delayed(const Duration(milliseconds: 800));

    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    if (password.length < 6) {
      throw Exception('weak-password');
    }

    return UserModel(
      id: 'user_${email.hashCode}',
      name: email.split('@').first,
      email: email,
    );
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // TODO: Replace with Firebase Auth when configured
    await Future.delayed(const Duration(milliseconds: 800));

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      throw Exception('All fields are required');
    }

    if (password.length < 6) {
      throw Exception('weak-password');
    }

    if (!email.contains('@')) {
      throw Exception('invalid-email');
    }

    return UserModel(
      id: 'user_${email.hashCode}',
      name: name,
      email: email,
    );
  }

  Future<void> logout() async {
    // TODO: await FirebaseAuth.instance.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    // TODO: Check FirebaseAuth.instance.currentUser
    return null;
  }
}
