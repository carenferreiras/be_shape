import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../features.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseFirestore _firestore;

  FirebaseUserRepository(
      {FirebaseFirestore? firestore, FirebaseAuth? firebaseAuth})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    await _firestore.collection('users').doc(profile.id).set(profile.toJson());
  }

 @override
Future<UserProfile?> getUserProfile(String userId) async {
  try {
    final doc = await _firestore.collection('users').doc(userId).get();

    if (doc.exists && doc.data() != null) {
      return UserProfile.fromJson(doc.data()!);
    }
  } catch (e) {
    print("Erro ao buscar perfil do usuário: $e");
    rethrow; 
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

  @override
  Future<void> updateUserTargetWeight(
      String userId, double newTargetWeight) async {
    await _firestore.collection('users').doc(userId).update({
      'targetWeight': newTargetWeight,
    });
  }
   @override
  Future<List<WeightHistory>> getWeightHistory(String userId) async {
    final snapshot = await _firestore
        .collection('weight_history')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return WeightHistory.fromJson(data);
    }).toList();
  }
 @override
  Future<void> addWeightEntry(WeightHistory entry) async {
    await _firestore
        .collection('weight_history')
        .add(entry.toJson());
  }

}


