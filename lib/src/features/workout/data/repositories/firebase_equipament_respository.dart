import 'package:cloud_firestore/cloud_firestore.dart';

import '../../workout.dart';


class FirebaseEquipmentRepository implements EquipmentRepository {
  final FirebaseFirestore _firestore;

  FirebaseEquipmentRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addEquipment(Equipment equipment) async {
    await _firestore
        .collection('equipment')
        .doc(equipment.id)
        .set(equipment.toFirestore());
  }

  @override
  Future<void> updateEquipment(Equipment equipment) async {
    await _firestore
        .collection('equipment')
        .doc(equipment.id)
        .update(equipment.toFirestore());
  }

  @override
  Future<void> deleteEquipment(String id) async {
    await _firestore.collection('equipment').doc(id).delete();
  }

  @override
  Future<List<Equipment>> getUserEquipment(String userId) async {
    final snapshot = await _firestore
        .collection('equipment')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => Equipment.fromFirestore(doc))
        .toList();
  }

  @override
  Future<List<Equipment>> getEquipmentByCategory(EquipmentCategory category) async {
    final snapshot = await _firestore
        .collection('equipment')
        .where('category', isEqualTo: category.toString())
        .get();

    return snapshot.docs
        .map((doc) => Equipment.fromFirestore(doc))
        .toList();
  }

  @override
  Future<Equipment?> getEquipmentById(String id) async {
    final doc = await _firestore.collection('equipment').doc(id).get();
    if (!doc.exists) return null;
    return Equipment.fromFirestore(doc);
  }

  @override
  Future<List<Equipment>> searchEquipment(String query) async {
    final snapshot = await _firestore
        .collection('equipment')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: query + 'z')
        .get();

    return snapshot.docs
        .map((doc) => Equipment.fromFirestore(doc))
        .toList();
  }
}