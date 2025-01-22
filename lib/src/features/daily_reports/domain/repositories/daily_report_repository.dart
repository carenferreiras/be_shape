// lib/domain/repositories/daily_report_repository.dart


import '../../../features.dart';

abstract class DailyReportRepository {
  Future<void> saveDailyReport(DailyReport report);
  Future<List<DailyReport>> getUserReports(String userId);
  Future<DailyReport?> getReportByDate(String userId, DateTime date);
  Future<void> updateDailyReport(DailyReport report);
  Future<void> deleteDailyReport(String id);
}
