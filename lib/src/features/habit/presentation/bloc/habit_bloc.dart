import 'package:flutter_bloc/flutter_bloc.dart';

import '../../habit.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final LoadHabits loadHabits; // Caso de uso para carregar hábitos
  final AddHabit addHabit; // Caso de uso para adicionar hábitos

  HabitBloc({required this.loadHabits, required this.addHabit})
      : super(HabitInitial()) {
    on<LoadHabitsEvent>(_onLoadHabits);
    on<AddHabitEvent>(_onAddHabit);
    on<UpdateHabitEvent>(_onUpdateHabit);
    on<DeleteHabitEvent>(_onDeleteHabit);
    on<AddEmotionCheckInEvent>(_onAddEmotionCheckIn);
  }

  // Lógica para carregar hábitos do armazenamento local
  Future<void> _onLoadHabits(
      LoadHabitsEvent event, Emitter<HabitState> emit) async {
    emit(HabitsLoading()); // Emite estado de carregamento
    try {
      final habits = await loadHabits.call(event.date); // Recupera os hábitos
      emit(HabitsLoaded(habits)); // Emite estado com os hábitos carregados
    } catch (e) {
      emit(HabitError("Failed to load habits")); // Emite erro, se necessário
    }
  }

  // Lógica para adicionar um novo hábito e salvá-lo localmente
  Future<void> _onAddHabit(
      AddHabitEvent event, Emitter<HabitState> emit) async {
    if (state is HabitsLoaded) {
      final currentState = state as HabitsLoaded;
      try {
        // 🟢 Carrega a lista de hábitos existentes antes de adicionar um novo
        final existingHabits = List<Habit>.from(currentState.habits);

        // 🚨 Verifica se o hábito já existe na lista para evitar duplicação
        final isAlreadyAdded = existingHabits.any((habit) =>
            habit.title == event.habit.title && habit.date == event.habit.date);

        if (!isAlreadyAdded) {
          existingHabits.add(event.habit);
          await addHabit.call(event.habit); // Salva no banco de dados

          emit(HabitsLoaded(existingHabits)); // Atualiza a UI
        }
      } catch (e) {
        emit(HabitError("Failed to add habit"));
      }
    }
  }

  // 🟢 Atualizar o progresso de um hábito e salvar a alteração
  Future<void> _onUpdateHabit(
      UpdateHabitEvent event, Emitter<HabitState> emit) async {
    if (state is HabitsLoaded) {
      final currentState = state as HabitsLoaded;
      try {
        // Atualiza a lista de hábitos
        final updatedHabits = currentState.habits.map((habit) {
          return habit.title == event.habit.title &&
                  habit.date == event.habit.date
              ? event.habit
              : habit;
        }).toList();

        await addHabit.call(event.habit); // Salva no SharedPreferences
        emit(HabitsLoaded(updatedHabits)); // Atualiza o estado
      } catch (e) {
        emit(HabitError("Failed to update habit progress"));
      }
    }
  }

  /// 📌 **Excluir um hábito**
 Future<void> _onDeleteHabit(
    DeleteHabitEvent event, Emitter<HabitState> emit) async {
  if (state is HabitsLoaded) {
    final currentState = state as HabitsLoaded;
    try {
      // 🟢 Remove o hábito da lista
      final updatedHabits = List<Habit>.from(currentState.habits)
        ..removeWhere((habit) =>
            habit.title == event.habit.title &&
            habit.date == event.habit.date);

      // 🛑 Salvar a lista correta sem o hábito excluído
      await addHabit.repository.saveHabits(updatedHabits);

      // 🚀 Atualiza o estado para refletir a exclusão
      emit(HabitsLoaded(updatedHabits));
    } catch (e) {
      emit(HabitError("Failed to delete habit"));
    }
  }
}
/// 🟢 **Adicionar Check-in Emocional**
  Future<void> _onAddEmotionCheckIn(
    AddEmotionCheckInEvent event,
    Emitter<HabitState> emit,
  ) async {
    if (state is HabitsLoaded) {
      final currentState = state as HabitsLoaded;
      try {
        final updatedHabits = currentState.habits.map((habit) {
          if (habit.title == event.habit.title && habit.date == event.habit.date) {
            final updatedCheckIns = List<EmotionCheckIn>.from(habit.checkIns)
              ..add(event.checkIn);

            return habit.copyWith(checkIns: updatedCheckIns);
          }
          return habit;
        }).toList();

        // Salva o hábito com o check-in emocional adicionado
        await addHabit.repository.saveHabits(updatedHabits);
        emit(HabitsLoaded(updatedHabits)); // Atualiza o estado com o novo check-in
      } catch (e) {
        emit(HabitError("Failed to add emotion check-in")); // Emite erro, se necessário
      }
    }
  }
}
