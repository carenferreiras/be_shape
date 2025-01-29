import 'package:health/health.dart';

class HealthDatasource {
  final Health _health = Health();

  Future<List<HealthDataPoint>> fetchHealthData() async {
    final types = [
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.BODY_FAT_PERCENTAGE,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.HEIGHT,
      HealthDataType.WEIGHT,
      HealthDataType.SLEEP_IN_BED,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_AWAKE,
    ];

    final now = DateTime.now();
    final startTime = now.subtract(const Duration(days: 30)); // Últimos 30 dias

    try {
      // Solicitar permissão para todos os tipos
      bool isAuthorized = await _health.requestAuthorization(types);
      if (!isAuthorized) {
        throw Exception("Permissões não concedidas pelo usuário.");
      }

      // Obter os dados
      return await _health.getHealthDataFromTypes(
        types: types,
        startTime: startTime,
        endTime: now,
      );
    } catch (e) {
      throw Exception("Erro ao buscar dados de saúde: $e");
    }
  }
}