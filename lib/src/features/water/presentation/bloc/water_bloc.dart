import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'water_event.dart';
import 'water_state.dart';

class WaterBloc extends Bloc<WaterEvent, WaterState> {
  final SharedPreferences _prefs;
  static const String _waterKey = 'water_intake';
  static const String _dateKey = 'water_date';

  WaterBloc({required SharedPreferences prefs})
      : _prefs = prefs,
        super(const WaterState()) {
    on<AddWater>(_onAddWater);
    on<LoadWaterIntake>(_onLoadWaterIntake);
    on<ResetWaterIntake>(_onResetWaterIntake);

    // Verifica se precisa resetar o contador diariamente
    _checkDailyReset();
  }

  Future<void> _onAddWater(AddWater event, Emitter<WaterState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      
      final newIntake = state.currentIntake + event.amount;
      await _prefs.setDouble(_waterKey, newIntake);
      
      emit(state.copyWith(
        isLoading: false,
        currentIntake: newIntake,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadWaterIntake(LoadWaterIntake event, Emitter<WaterState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      
      final intake = _prefs.getDouble(_waterKey) ?? 0;
      
      emit(state.copyWith(
        isLoading: false,
        currentIntake: intake,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onResetWaterIntake(ResetWaterIntake event, Emitter<WaterState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      
      await _prefs.setDouble(_waterKey, 0);
      await _prefs.setString(_dateKey, DateTime.now().toIso8601String());
      
      emit(state.copyWith(
        isLoading: false,
        currentIntake: 0,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _checkDailyReset() async {
    final lastDate = _prefs.getString(_dateKey);
    if (lastDate != null) {
      final lastDateTime = DateTime.parse(lastDate);
      final now = DateTime.now();
      
      if (lastDateTime.day != now.day ||
          lastDateTime.month != now.month ||
          lastDateTime.year != now.year) {
        add(ResetWaterIntake());
      }
    } else {
      await _prefs.setString(_dateKey, DateTime.now().toIso8601String());
    }
  }
}