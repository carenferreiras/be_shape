import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../features.dart';


class FirebaseUserRepository implements UserRepository {
  final FirebaseFirestore _firestore;

  FirebaseUserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    await _firestore
        .collection('users')
        .doc(profile.id)
        .set(profile.toJson());
  }

  @override
  Future<UserProfile?> getUserProfile(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserProfile.fromJson(doc.data()!);
    }
    return null;
  }

  @override
  Future<void> updateUserProfile(UserProfile profile) async {
    await _firestore
        .collection('users')
        .doc(profile.id)
        .update(profile.toJson());
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }
}