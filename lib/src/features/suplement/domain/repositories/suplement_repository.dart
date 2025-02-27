
import '../../suplement.dart';

abstract class SupplementRepository {
  // Suplementos
  Future<void> addSupplement(Supplement supplement);
  Future<void> updateSupplement(Supplement supplement);
  Future<void> deleteSupplement(String id);
  Future<List<Supplement>> getUserSupplements(String userId);
  Future<Supplement?> getSupplementById(String id);
  Future<List<Supplement>> getActiveSupplements(String userId);
  Future<List<Supplement>> getLowSupplements(String userId);

  // Logs
  Future<void> logSupplementTaken(SupplementLog log);
  Future<void> updateSupplementLog(SupplementLog log);
  Future<void> deleteSupplementLog(String id);
  Future<List<SupplementLog>> getSupplementLogs(String supplementId);
  Future<List<SupplementLog>> getUserSupplementLogs(String userId);
  Future<List<SupplementLog>> getSupplementLogsByDate(String userId, DateTime date);
  Future<bool> hasLoggedToday(String supplementId);
}