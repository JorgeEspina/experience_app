import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

/// Data source for authentication backed by Firebase Auth.
///
/// [FirebaseAuth] is injected so it can be replaced with a mock in tests.
class AuthRemoteDataSource {
  AuthRemoteDataSource({FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _mapUser(credential.user);
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Persist the display name on the Firebase user profile.
    await credential.user?.updateDisplayName(name);
    await credential.user?.reload();

    final user = _auth.currentUser ?? credential.user;
    return _mapUser(user, fallbackName: name);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _mapUser(user);
  }

  /// Maps a Firebase [User] into the app's [UserModel].
  UserModel _mapUser(User? user, {String? fallbackName}) {
    if (user == null) {
      // Signals to AuthController._parseError as an invalid credential.
      throw FirebaseAuthException(
        code: 'invalid-credential',
        message: 'No user returned from Firebase Auth',
      );
    }

    final email = user.email ?? '';
    final name = (user.displayName?.isNotEmpty ?? false)
        ? user.displayName!
        : (fallbackName?.isNotEmpty ?? false)
            ? fallbackName!
            : (email.isNotEmpty ? email.split('@').first : 'User');

    return UserModel(
      id: user.uid,
      name: name,
      email: email,
    );
  }
}
