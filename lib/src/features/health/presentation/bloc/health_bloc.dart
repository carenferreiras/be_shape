import 'package:flutter_bloc/flutter_bloc.dart';

import '../../health.dart';

class HealthBloc extends Bloc<HealthEvent, HealthState> {
  final FetchHealthData fetchHealthData;

  HealthBloc(this.fetchHealthData) : super(HealthInitial()) {
    on<FetchHealthEvent>((event, emit) async {
      emit(HealthLoading());
      try {
        final data = await fetchHealthData();
        emit(HealthLoaded(data));
      } catch (e) {
        emit(HealthError(e.toString()));
      }
    });
  }
}