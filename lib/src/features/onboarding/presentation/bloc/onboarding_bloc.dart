// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  OnboardingBloc({
    required UserRepository userRepository,
    required AuthRepository authRepository,
  })  : _userRepository = userRepository,
        _authRepository = authRepository,
        super(const OnboardingState()) {
    on<UpdateGoal>(_onUpdateGoal);
    on<UpdateGender>(_onUpdateGender);
    on<UpdateWeight>(_onUpdateWeight);
    on<UpdateWeightUnit>(_onUpdateWeightUnit);
    on<UpdateAge>(_onUpdateAge);
    on<UpdateHeight>(_onUpdateHeight);
    on<UpdateTargetWeight>(_onUpdateTargetWeight);
    on<UpdateActivityLevel>(_onUpdateActivityLevel);
    on<UpdateName>(_onUpdateName);
    on<SaveUserProfile>(_onSaveUserProfile);
    _loadInitialUserData();
  }

  void _onUpdateGoal(UpdateGoal event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(selectedGoal: event.goal));
  }

  void _onUpdateGender(UpdateGender event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(selectedGender: event.gender));
  }

  void _onUpdateWeight(UpdateWeight event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(
      weight: event.weight,
      targetWeight: state.targetWeight ?? event.weight,
    ));
  }

  void _onUpdateWeightUnit(UpdateWeightUnit event, Emitter<OnboardingState> emit) {
    final newWeight = event.unit == 'kg' 
        ? state.weight 
        : state.weight * 2.20462; // Convert kg to lbs
    emit(state.copyWith(
      weightUnit: event.unit,
      weight: newWeight,
    ));
  }

  void _onUpdateAge(UpdateAge event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(age: event.age));
  }

  void _onUpdateHeight(UpdateHeight event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(height: event.height));
  }

  void _onUpdateTargetWeight(UpdateTargetWeight event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(targetWeight: event.targetWeight));
  }

  void _onUpdateActivityLevel(UpdateActivityLevel event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(activityLevel: event.activityLevel));
  }

  void _onUpdateName(UpdateName event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _onSaveUserProfile(SaveUserProfile event, Emitter<OnboardingState> emit) async {
  try {
    // Validate user authentication
    final userId = _authRepository.currentUser?.uid;
    if (userId == null) {
      emit(state.copyWith(error: 'User not authenticated'));
      return;
    }

    // Validate required fields
    final validationError = _validateFields();
    if (validationError != null) {
      emit(state.copyWith(error: validationError));
      return;
    }

    // Convert weight to kg if needed
    final weight = state.weightUnit == 'kg' ? state.weight : state.weight / 2.20462;
    final targetWeight = state.targetWeight ?? weight;
    final height = state.height! / 100; // Convert height to meters

    // Calculate BMR using Harris-Benedict equation
    double bmr;
    if (state.selectedGender?.toLowerCase() == 'male') {
      bmr = 88.362 + (13.397 * weight) + (4.799 * state.height!) - (5.677 * state.age!);
    } else {
      bmr = 447.593 + (9.247 * weight) + (3.098 * state.height!) - (4.330 * state.age!);
    }

    // Calculate TDEE using activity level
    final activityLevel = state.activityLevel ?? 1.2;
    final tdee = bmr * activityLevel;

    // Create user profile
    final userProfile = UserProfile(
      id: userId,
      name: state.name ?? 'User',
      age: state.age!,
      gender: state.selectedGender!,
      height: state.height!,
      weight: weight,
      targetWeight: targetWeight,
      goal: state.selectedGoal!,
      measurements: {},
      bmr: bmr,
      tdee: tdee,
      activityLevel: activityLevel,
    );

    // Save to Firebase
    await _userRepository.saveUserProfile(userProfile);
    
    emit(state.copyWith(isProfileSaved: true, error: null));
  } catch (e) {
    emit(state.copyWith(error: e.toString()));
  }
}

  String? _validateFields() {
    if (state.selectedGoal == null) {
      return 'Please select your fitness goal';
    }
    if (state.selectedGender == null) {
      return 'Please select your gender';
    }
    if (state.age == null || state.age! < 13 || state.age! > 100) {
      return 'Please enter a valid age between 13 and 100';
    }
    if (state.height == null || state.height! < 140 || state.height! > 220) {
      return 'Please enter a valid height between 140cm and 220cm';
    }
    if (state.weight < 40 || state.weight > 200) {
      return 'Please enter a valid weight';
    }
    return null;
  }
  Future<void> _loadInitialUserData() async {
  final user = _authRepository.currentUser;
  if (user != null) {
    // Busca o perfil do usuário no banco de dados
    final userProfile = await _userRepository.getUserProfile(user.uid);

    // 🔥 Só atualiza se o perfil já existir (para não pular o onboarding)
    if (userProfile != null && userProfile.name.isNotEmpty) {
      emit(state.copyWith(name: userProfile.name));
    }
  }
}
}