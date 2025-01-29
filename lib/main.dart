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
  final fetchHealthData = FetchHealthData(healthRepository);

  // Criação das dependências de Habits
  final habitRepository = HabitService(); // Implementação do repositório
  final loadHabits = LoadHabits(habitRepository); // Caso de uso de carregar hábitos
  final addHabit = AddHabit(habitRepository); // Caso de uso de adicionar hábitos

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
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
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
        ],
        child: const BeShapeApp(),
      ),
    ),
  );
}