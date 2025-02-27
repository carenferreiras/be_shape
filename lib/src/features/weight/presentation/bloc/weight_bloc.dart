// lib/src/features/weight/bloc/weight_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features.dart';

class WeightBloc extends Bloc<WeightEvent, WeightState> {
  final UserRepository userRepository;
  final String userId;

  WeightBloc({
    required this.userRepository,
    required this.userId,
    required double initialWeight,
    required double initialBMR,
    required double initialTDEE,
  }) : super(WeightState(
          startWeight: initialWeight,
          currentWeight: initialWeight,
          previousWeight: initialWeight,
          targetWeight: 0.0,
          bmr: initialBMR,
          tdee: initialTDEE,
          weightHistory: const [],
        )) {
    on<InitializeWeight>(_onInitializeWeight);
    on<TargetWeightUpdated>(_onTargetWeightUpdated);
    on<WeightUpdated>(_onWeightUpdated);
    on<LoadWeightHistory>(_onLoadWeightHistory);

    // Dispara a inicialização do peso ao iniciar
    add(InitializeWeight());
    add(LoadWeightHistory());
  }

  Future<void> _onLoadWeightHistory(
    LoadWeightHistory event,
    Emitter<WeightState> emit,
  ) async {
    try {
      final history = await userRepository.getWeightHistory(userId);
      emit(state.copyWith(weightHistory: history));
    } catch (e) {
      print('Error loading weight history: $e');
    }
  }

  Future<void> _onInitializeWeight(
    InitializeWeight event,
    Emitter<WeightState> emit,
  ) async {
    try {
      final profile = await userRepository.getUserProfile(userId);
      
      if (profile != null) {
        double altura = profile.height / 100; // Convertendo cm para metros
        
        // Definição de IMC saudável
        const double imcMin = 18.5;
        const double imcMax = 24.9;

        // Cálculo dos pesos mínimo e máximo recomendados pela OMS
        double pesoMinimo = imcMin * (altura * altura);
        double pesoMaximo = imcMax * (altura * altura);

        // Definir o peso ideal como a média entre peso mínimo e máximo
        double pesoIdealInicial = (pesoMinimo + pesoMaximo) / 2;

        // Atualizar o peso ideal no Firebase
        await userRepository.updateUserTargetWeight(userId, pesoIdealInicial);

        // Atualiza o estado do Bloc
        emit(state.copyWith(targetWeight: pesoIdealInicial));
      }
    } catch (e) {
      print('Error initializing target weight: $e');
    }
  }

  Future<void> _onTargetWeightUpdated(
    TargetWeightUpdated event,
    Emitter<WeightState> emit,
  ) async {
    try {
      await userRepository.updateUserTargetWeight(userId, event.newTargetWeight);
      emit(state.copyWith(targetWeight: event.newTargetWeight));
    } catch (e) {
      print('Error updating target weight: $e');
    }
  }

  Future<void> _onWeightUpdated(
    WeightUpdated event,
    Emitter<WeightState> emit,
  ) async {
    final newWeight = event.newWeight;

    // Atualiza o peso no estado para animação otimista
    emit(state.copyWith(
      currentWeight: newWeight,
      previousWeight: state.currentWeight,
    ));

    try {
      final profile = await userRepository.getUserProfile(userId);
      if (profile != null) {
        // Recalcula o TMB e TDEE com base no novo peso
        double newTMB;
        final genderLower = profile.gender.toLowerCase();
        if (genderLower == 'male' || genderLower == 'm') {
          newTMB = 66 + (13.8 * newWeight) + (5 * profile.height) - (6.8 * profile.age);
        } else {
          newTMB = 655 + (9.6 * newWeight) + (1.8 * profile.height) - (4.7 * profile.age);
        }

        final newTDEE = newTMB * profile.activityLevel;
        final newMacroTargets = MacroTargets.fromTDEE(newTDEE, newWeight);

        // Calcula o novo IMC
        final altura = profile.height / 100; // cm para metros
        final newBMI = newWeight / (altura * altura);

        // Adiciona entrada no histórico
        final weightEntry = WeightHistory(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: userId,
          weight: newWeight,
          bmi: newBMI,
          date: DateTime.now(),
        );

        await userRepository.addWeightEntry(weightEntry);

        // Atualiza o perfil no Firebase
        final updatedProfile = profile.copyWith(
          weight: newWeight,
          bmr: newTMB,
          tdee: newTDEE,
          macroTargets: newMacroTargets,
        );

        await userRepository.updateUserProfile(updatedProfile);

        // Recarrega o histórico
        add(LoadWeightHistory());

        // Emite o novo estado atualizado
        emit(state.copyWith(
          bmr: newTMB,
          tdee: newTDEE,
        ));
      }
    } catch (e) {
      print('Error updating weight: $e');
    }
  }
}
