import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import 'user_profile_remote_data_source.dart';

/// Data source for authentication backed by Firebase Auth.
///
/// The user role is stored in Firestore (`users/{uid}`) via
/// [UserProfileRemoteDataSource]. [FirebaseAuth] is injected so it can be
/// replaced with a mock in tests.
class AuthRemoteDataSource {
  AuthRemoteDataSource({
    FirebaseAuth? firebaseAuth,
    required this.userProfile,
  }) : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;
  final UserProfileRemoteDataSource userProfile;

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Ensure a Firestore profile exists (for users created before profiles
    // were introduced). Never overwrites an existing doc, so an admin role
    // set in the console is preserved.
    final user = credential.user;
    if (user != null) {
      await userProfile.ensureProfile(
        uid: user.uid,
        name: user.displayName ?? (user.email?.split('@').first ?? 'User'),
        email: user.email ?? email,
      );
    }

    return await _mapUser(user);
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

    // Create the Firestore profile with the default "client" role.
    if (user != null) {
      await userProfile.ensureProfile(
        uid: user.uid,
        name: name,
        email: user.email ?? email,
      );
    }

    return await _mapUser(user, fallbackName: name, role: 'client');
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return await _mapUser(user);
  }

  /// Maps a Firebase [User] into the app's [UserModel], reading the role from
  /// Firestore when it isn't already known.
  Future<UserModel> _mapUser(
    User? user, {
    String? fallbackName,
    String? role,
  }) async {
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

    final resolvedRole = role ?? await userProfile.getRole(user.uid);

    return UserModel(
      id: user.uid,
      name: name,
      email: email,
      role: resolvedRole,
    );
  }
}
