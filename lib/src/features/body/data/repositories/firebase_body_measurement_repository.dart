import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../features.dart';

class FirebaseBodyMeasurementRepository implements BodyMeasurementRepository {
  final FirebaseFirestore _firestore;

  FirebaseBodyMeasurementRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addMeasurement(BodyMeasurement measurement) async {
    await _firestore
        .collection('body_measurements')
        .doc(measurement.id)
        .set(measurement.toJson());
  }

  @override
  Future<void> updateMeasurement(BodyMeasurement measurement) async {
    await _firestore
        .collection('body_measurements')
        .doc(measurement.id)
        .update(measurement.toJson());
  }

  @override
  Future<void> deleteMeasurement(String id) async {
    await _firestore.collection('body_measurements').doc(id).delete();
  }

  @override
  Future<List<BodyMeasurement>> getUserMeasurements(String userId) async {
    final snapshot = await _firestore
        .collection('body_measurements')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => BodyMeasurement.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<List<BodyMeasurement>> getMeasurementsByDateRange(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    final snapshot = await _firestore
        .collection('body_measurements')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('date', isLessThan: end.toIso8601String())
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => BodyMeasurement.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<BodyMeasurement?> getLatestMeasurement(String userId) async {
    final snapshot = await _firestore
        .collection('body_measurements')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return BodyMeasurement.fromJson(snapshot.docs.first.data());
  }
}