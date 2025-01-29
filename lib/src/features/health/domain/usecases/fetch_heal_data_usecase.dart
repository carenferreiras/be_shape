

import '../../health.dart';

class FetchHealthData {
  final HealthRepository repository;

  FetchHealthData(this.repository);

  Future<List<HealthData>> call() {
    return repository.fetchHealthData();
  }
}