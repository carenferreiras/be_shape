// lib/data/repositories/firebase_daily_report_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';


import '../../../features.dart';

class FirebaseDailyReportRepository implements DailyReportRepository {
  final FirebaseFirestore _firestore;

  FirebaseDailyReportRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> saveDailyReport(DailyReport report) async {
    await _firestore.collection('daily_reports').doc(report.id).set(report.toJson());
  }

  @override
  Future<List<DailyReport>> getUserReports(String userId) async {
    final snapshot = await _firestore
        .collection('daily_reports')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) => DailyReport.fromJson(doc.data())).toList();
  }

  @override
  Future<DailyReport?> getReportByDate(String userId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot = await _firestore
        .collection('daily_reports')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThan: endOfDay)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return DailyReport.fromJson(snapshot.docs.first.data());
  }

  @override
  Future<void> updateDailyReport(DailyReport report) async {
    await _firestore
        .collection('daily_reports')
        .doc(report.id)
        .update(report.toJson());
  }

  @override
  Future<void> deleteDailyReport(String id) async {
    await _firestore.collection('daily_reports').doc(id).delete();
  }
}
