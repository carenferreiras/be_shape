
import 'package:equatable/equatable.dart';

import '../../../../auth/auth.dart';

abstract class FoodSuggestionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFoodSuggestions extends FoodSuggestionEvent {
  final UserProfile userProfile;

  LoadFoodSuggestions({required this.userProfile});

  @override
  List<Object?> get props => [userProfile];
}