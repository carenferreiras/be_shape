// ignore_for_file: unused_local_variable

import 'package:be_shape_app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/features/features.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Criação das dependências do Health
  final healthDatasource = HealthDatasource();
  final healthRepository = HealthRepositoryImpl(healthDatasource);

  // Criação das dependências de Habits
  final habitRepository = HabitService(); // Implementação do repositório
  final loadHabits = LoadHabits(habitRepository); // Caso de uso de carregar hábitos
  final addHabit = AddHabit(habitRepository); // Caso de uso de adicionar hábitos

  // Criação das dependências do Water Tracker
  final waterRepository = WaterRepositoryImpl(); // Repositório para consumo de água
  final getCurrentWaterIntake = GetCurrentWaterIntake(waterRepository); // Caso de uso para obter consumo atual
  final updateWaterIntake = UpdateWaterIntake(waterRepository); // Caso de uso para atualizar consumo

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => FirebaseAuthRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => FirebaseUserRepository(),
        ),
        RepositoryProvider<MealRepository>(
          create: (context) => FirebaseMealRepository(),
        ),
        RepositoryProvider<SavedFoodRepository>(
          create: (context) => FirebaseSavedFoodRepository(),
        ),
        RepositoryProvider<DailyReportRepository>(
          create: (context) => FirebaseDailyReportRepository(),
        ),
        RepositoryProvider<ProgressPhotoRepository>(
          create: (context) => FirebaseProgressPhotoRepository(),
        ),
        RepositoryProvider<ExerciseRepository>(
          create: (context) => FirebaseExerciseRepository(),
        ),
        RepositoryProvider<HealthRepository>(
          create: (context) => healthRepository,
        ),
        RepositoryProvider<HabitRepository>(
          create: (context) => habitRepository, 
        ),
        RepositoryProvider<WaterRepository>(
          create: (context) => waterRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => MealBloc(
              mealRepository: context.read<MealRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => SavedFoodBloc(
              repository: context.read<SavedFoodRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ProgressPhotoBloc(
              repository: context.read<ProgressPhotoRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ExerciseBloc(
              exerciseRepository: context.read<ExerciseRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => HealthBloc(
              FetchHealthData(context.read<HealthRepository>()),
            ),
          ),
          BlocProvider(
            create: (context) => HabitBloc(
              loadHabits: LoadHabits(context.read<HabitRepository>()), 
              addHabit: AddHabit(context.read<HabitRepository>())
            ),
          ),
           BlocProvider(
            create: (context) => WaterBloc(
              getCurrentWaterIntake: getCurrentWaterIntake,
              updateWaterIntake: updateWaterIntake,
            )..add(LoadWaterIntake()), // 🟢 Garante que os dados são carregados
          ),
        ],
        child: const BeShapeApp(),
      ),
    ),
  );
}