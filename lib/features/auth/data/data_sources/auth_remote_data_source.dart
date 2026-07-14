import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFromCredential(credential);
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.updateDisplayName(name);
    return _userFromCredential(credential);
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
    );
  }

  UserModel _userFromCredential(UserCredential credential) {
    final user = credential.user!;
    return UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
    );
  }
}
