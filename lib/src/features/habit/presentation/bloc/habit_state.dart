import 'package:equatable/equatable.dart';

import '../../habit.dart';

abstract class HabitState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HabitInitial extends HabitState {}

class HabitsLoading extends HabitState {}

class HabitsLoaded extends HabitState {
  final List<Habit> habits;

  HabitsLoaded(this.habits);

  @override
  List<Object?> get props => [habits];
}

class HabitError extends HabitState {
  final String message;

  HabitError(this.message);

  @override
  List<Object?> get props => [message];
}