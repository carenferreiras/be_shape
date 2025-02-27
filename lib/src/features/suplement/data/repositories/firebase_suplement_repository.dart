import 'package:cloud_firestore/cloud_firestore.dart';

import '../../suplement.dart';


class FirebaseSupplementRepository implements SupplementRepository {
  final FirebaseFirestore _firestore;

  FirebaseSupplementRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addSupplement(Supplement supplement) async {
    await _firestore
        .collection('supplements')
        .doc(supplement.id)
        .set(supplement.toJson());
  }

  @override
  Future<void> updateSupplement(Supplement supplement) async {
    await _firestore
        .collection('supplements')
        .doc(supplement.id)
        .update(supplement.toJson());
  }

  @override
  Future<void> deleteSupplement(String id) async {
    await _firestore.collection('supplements').doc(id).delete();
  }

  @override
  Future<List<Supplement>> getUserSupplements(String userId) async {
    final snapshot = await _firestore
        .collection('supplements')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => Supplement.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<Supplement?> getSupplementById(String id) async {
    final doc = await _firestore.collection('supplements').doc(id).get();
    if (!doc.exists) return null;
    return Supplement.fromJson(doc.data()!);
  }

  @override
  Future<List<Supplement>> getActiveSupplements(String userId) async {
    final snapshot = await _firestore
        .collection('supplements')
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => Supplement.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<List<Supplement>> getLowSupplements(String userId) async {
    final supplements = await getUserSupplements(userId);
    return supplements.where((s) => s.isRunningLow).toList();
  }

  @override
  Future<void> logSupplementTaken(SupplementLog log) async {
    // Adiciona o log
    await _firestore
        .collection('supplement_logs')
        .doc(log.id)
        .set(log.toJson());

    // Atualiza o lastTakenAt do suplemento
    await _firestore
        .collection('supplements')
        .doc(log.supplementId)
        .update({'lastTakenAt': log.takenAt.toIso8601String()});
  }

  @override
  Future<void> updateSupplementLog(SupplementLog log) async {
    await _firestore
        .collection('supplement_logs')
        .doc(log.id)
        .update(log.toJson());
  }

  @override
  Future<void> deleteSupplementLog(String id) async {
    await _firestore.collection('supplement_logs').doc(id).delete();
  }

  @override
  Future<List<SupplementLog>> getSupplementLogs(String supplementId) async {
    final snapshot = await _firestore
        .collection('supplement_logs')
        .where('supplementId', isEqualTo: supplementId)
        .orderBy('takenAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => SupplementLog.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<List<SupplementLog>> getUserSupplementLogs(String userId) async {
    final snapshot = await _firestore
        .collection('supplement_logs')
        .where('userId', isEqualTo: userId)
        .orderBy('takenAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => SupplementLog.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<List<SupplementLog>> getSupplementLogsByDate(
    String userId,
    DateTime date,
  ) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot = await _firestore
        .collection('supplement_logs')
        .where('userId', isEqualTo: userId)
        .where('takenAt', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('takenAt', isLessThan: endOfDay.toIso8601String())
        .get();

    return snapshot.docs
        .map((doc) => SupplementLog.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<bool> hasLoggedToday(String supplementId) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot = await _firestore
        .collection('supplement_logs')
        .where('supplementId', isEqualTo: supplementId)
        .where('takenAt', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('takenAt', isLessThan: endOfDay.toIso8601String())
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }
}