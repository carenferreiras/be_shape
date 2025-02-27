
import '../../workout.dart';

abstract class EquipmentRepository {
  Future<void> addEquipment(Equipment equipment);
  Future<void> updateEquipment(Equipment equipment);
  Future<void> deleteEquipment(String id);
  Future<List<Equipment>> getUserEquipment(String userId);
  Future<List<Equipment>> getEquipmentByCategory(EquipmentCategory category);
  Future<Equipment?> getEquipmentById(String id);
  Future<List<Equipment>> searchEquipment(String query);
}