import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../water.dart';

class WaterBloc extends Bloc<WaterEvent, WaterState> {
  final GetCurrentWaterIntake getCurrentWaterIntake;
  final UpdateWaterIntake updateWaterIntake;

  WaterBloc({
    required this.getCurrentWaterIntake,
    required this.updateWaterIntake,
  }) : super(WaterInitial()) {
    on<LoadWaterIntake>(_onLoadWaterIntake);
    on<AddWaterIntake>(_onAddWaterIntake);
  }

  Future<void> _onLoadWaterIntake(
    LoadWaterIntake event, Emitter<WaterState> emit) async {
  emit(WaterLoading());
  try {
    final waterIntake = await getCurrentWaterIntake.call();

    // Garante que a lista de entradas não seja nula
    final validEntries = waterIntake.entries;

    emit(WaterLoaded(
      WaterIntake(
        date: waterIntake.date,
        totalIntake: waterIntake.totalIntake,
        entries: validEntries,
      ),
    ));
  } catch (e) {
    emit(WaterError("Erro ao carregar os dados de água."));
  }
}

  Future<void> _onAddWaterIntake(
    AddWaterIntake event, Emitter<WaterState> emit) async {
  if (state is WaterLoaded) {
    final currentState = state as WaterLoaded;

    try {
      // Adiciona a quantidade de água ao total
      final updatedIntake = currentState.intake.totalIntake + event.amount;

      // Cria uma nova lista de entradas com o novo registro
      final updatedEntries = List<WaterEntry>.from(currentState.intake.entries)
        ..add(WaterEntry(
          time: DateFormat('h:mm a').format(DateTime.now()), // Hora atual
          amount: event.amount,
        ));

      // Cria um novo objeto `WaterIntake` atualizado
      final updatedWaterIntake = WaterIntake(
        date: currentState.intake.date,
        totalIntake: updatedIntake,
        entries: updatedEntries,
      );

      // Atualiza o repositório
      await updateWaterIntake.call(event.amount);

      // Emite o novo estado com os dados atualizados
      emit(WaterLoaded(updatedWaterIntake));
    } catch (e) {
      emit(WaterError("Erro ao adicionar consumo de água."));
    }
  }
}

}