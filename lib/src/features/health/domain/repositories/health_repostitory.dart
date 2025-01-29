
import '../../health.dart';


abstract class HealthRepository {
  Future<List<HealthData>> fetchHealthData();
}