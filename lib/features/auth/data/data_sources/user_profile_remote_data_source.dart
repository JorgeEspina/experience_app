import 'package:cloud_firestore/cloud_firestore.dart';

/// Stores the per-user profile (including the role) in Firestore.
///
/// Each user has a document at `users/{uid}` shaped like:
/// `{ email, name, role: "admin" | "client" }`.
///
/// To promote someone to admin, edit their document in the Firebase console
/// and change `role` to `"admin"`.
class UserProfileRemoteDataSource {
  UserProfileRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _collection = 'users';

  DocumentReference<Map<String, dynamic>> _docFor(String uid) =>
      _firestore.collection(_collection).doc(uid);

  /// Creates the profile document if it doesn't exist yet. New users default
  /// to the `client` role. Existing docs are left untouched (so an admin flag
  /// set in the console is never overwritten on the next login).
  Future<void> ensureProfile({
    required String uid,
    required String name,
    required String email,
  }) async {
    final doc = await _docFor(uid).get();
    if (doc.exists) return;
    await _docFor(uid).set({
      'name': name,
      'email': email,
      'role': 'client',
    });
  }

  /// Reads the role for a user. Defaults to `client` if the doc or field is
  /// missing.
  Future<String> getRole(String uid) async {
    final doc = await _docFor(uid).get();
    final data = doc.data();
    if (!doc.exists || data == null) return 'client';
    return (data['role'] as String?) ?? 'client';
  }
}
