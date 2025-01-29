
import '../../health.dart';

class HealthRepositoryImpl implements HealthRepository {
  final HealthDatasource datasource;

  HealthRepositoryImpl(this.datasource);

  @override
  Future<List<HealthData>> fetchHealthData() async {
    final dataPoints = await datasource.fetchHealthData();
    return dataPoints.map((point) {
      return HealthData(type: point.type.name, value: point.value);
    }).toList();
  }
}