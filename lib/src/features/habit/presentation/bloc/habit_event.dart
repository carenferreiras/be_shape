import 'package:equatable/equatable.dart';
import '../../habit.dart';

abstract class HabitEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Evento para carregar hábitos de um dia específico
class LoadHabitsEvent extends HabitEvent {
  final String date;

  LoadHabitsEvent(this.date);

  @override
  List<Object?> get props => [date];
}

// Evento para adicionar um novo hábito
class AddHabitEvent extends HabitEvent {
  final Habit habit;

  AddHabitEvent(this.habit);

  @override
  List<Object?> get props => [habit];
}

// Evento para atualizar o progresso de um hábito
class UpdateHabitEvent extends HabitEvent {
  final Habit habit;

  UpdateHabitEvent(this.habit);

  @override
  List<Object?> get props => [habit];
}

class DeleteHabitEvent extends HabitEvent {
  final Habit habit;

  DeleteHabitEvent(this.habit);

  @override
  List<Object?> get props => [habit];
}

class AddEmotionCheckInEvent extends HabitEvent {
  final Habit habit;
  final EmotionCheckIn checkIn;

  AddEmotionCheckInEvent(this.habit, this.checkIn);

  @override
  List<Object?> get props => [habit];
}