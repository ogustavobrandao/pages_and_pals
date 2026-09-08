import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';

class UserRepository {
  UserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users => _firestore.collection('users');

  Future<void> createUser(AppUser user) {
    return _users.doc(user.uid).set(user.toCreateMap());
  }

  Stream<AppUser?> watchUser(String uid) {
    return _users.doc(uid).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) return null;
      return AppUser.fromMap(uid, data);
    });
  }

  Future<void> updateProfile({
    required String uid,
    required String name,
    required String bio,
    String? photoUrl,
  }) {
    final data = <String, dynamic>{'name': name, 'bio': bio};
    if (photoUrl != null) data['photoUrl'] = photoUrl;
    return _users.doc(uid).update(data);
  }

  Future<void> deleteUser(String uid) {
    return _users.doc(uid).delete();
  }
}
