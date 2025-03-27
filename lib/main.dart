// ignore_for_file: unused_local_variable

import 'package:be_shape_app/app.dart';
import 'package:be_shape_app/src/features/body/data/repositories/firebase_body_measurement_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/features/features.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initHiveForFlutter();

  final HttpLink httpLink =
      HttpLink('https://taco-api.netlify.app/.netlify/functions/graphql');

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );

// Initialize OpenAI service
  final openAIService = OpenAIService(
      apiKey:
          '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');
  // Health dependencies
  final healthDatasource = HealthDatasource();
  final healthRepository = HealthRepositoryImpl(healthDatasource);
  final supplementRepository = FirebaseSupplementRepository();
  final favoriteFoodRepository = FavoriteFoodRepository();

  // Habit dependencies
  final habitRepository = HabitService();
  final loadHabits = LoadHabits(habitRepository);
  final addHabit = AddHabit(habitRepository);

  // Water Tracker dependencies
  final waterRepository = WaterRepositoryImpl();
  final getCurrentWaterIntake = GetCurrentWaterIntake(waterRepository);
  final updateWaterIntake = UpdateWaterIntake(waterRepository);
  final prefs = await SharedPreferences.getInstance();
  final apiService = OpenFoodFactsService();
  final repository = OpenFoodFactsRepository(apiService);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<BodyMeasurementRepository>(
          create: (context) => FirebaseBodyMeasurementRepository(),
        ),
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
        RepositoryProvider<EquipmentRepository>(
          create: (context) => FirebaseEquipmentRepository(),
        ),
        RepositoryProvider<WorkoutRepository>(
          create: (context) => FirebaseWorkoutRepository(),
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
        RepositoryProvider<OpenAIService>(
          create: (context) => openAIService,
        ),
        RepositoryProvider<SupplementRepository>(
          create: (context) => supplementRepository,
        ),
        RepositoryProvider<OpenFoodFactsRepository>(
          create: (context) => repository,
        ),
        RepositoryProvider<FavoriteFoodRepository>(
          create: (context) => favoriteFoodRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
              userRepository: context.read<UserRepository>(),
            )..add(const AuthCheckRequested()),
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
            create: (context) => EquipmentBloc(
              repository: context.read<EquipmentRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => WorkoutBloc(
              repository: context.read<WorkoutRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => HealthBloc(
              FetchHealthData(context.read<HealthRepository>()),
            ),
          ),
          BlocProvider(
            create: (context) {
              final authRepo = context.read<AuthRepository>();
              final userRepo = context.read<UserRepository>();
              final userId = authRepo.currentUser?.uid ?? 'defaultUserId';

              return EquipmentBloc(
                repository: context.read<EquipmentRepository>(),
              )..add(LoadUserEquipment(userId));
            },
          ),
          BlocProvider(
            create: (context) => HabitBloc(
              loadHabits: LoadHabits(context.read<HabitRepository>()),
              addHabit: AddHabit(context.read<HabitRepository>()),
            ),
          ),
          BlocProvider(
            create: (context) =>
                WaterBloc(prefs: prefs)..add(LoadWaterIntake()),
          ),
          BlocProvider(
            create: (context) {
              final authRepo = context.read<AuthRepository>();
              final userRepo = context.read<UserRepository>();
              final userId = authRepo.currentUser?.uid ?? 'defaultUserId';

              return WeightBloc(
                userRepository: userRepo,
                userId: userId,
                initialWeight: 80.0,
                initialBMR: 1816.0,
                initialTDEE: 2179.2,
              );
            },
          ),
          BlocProvider(
            create: (context) => AIAssistantBloc(
              aiService: context.read<OpenAIService>(),
            ),
          ),
          BlocProvider(
            create: (context) => AIChatBloc(
              aiService: context.read<OpenAIService>(),
            ),
          ),
          BlocProvider(
            create: (context) =>
                SupplementBloc(repository: supplementRepository),
          ),
          BlocProvider(
            create: (context) => BodyMeasurementBloc(
                repository: context.read<BodyMeasurementRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                FoodSuggestionBloc(firestore: FirebaseFirestore.instance),
          ),
          BlocProvider(
            create: (context) => OpenFoodFactsBloc(
              context.read<OpenFoodFactsRepository>(), // Correção aqui
            ),
          ),
           BlocProvider(
            create: (context) {
              final authRepo = context.read<AuthRepository>();
              final userRepo = context.read<UserRepository>();
              final userId = authRepo.currentUser?.uid ?? 'defaultUserId';

              return FavoriteFoodBloc(
                favoriteFoodRepository:  context.read<FavoriteFoodRepository>(), userId: userId);
            },
          ),
        ],
        child: BeShapeApp(
          graphQLClient: client,
        ),
      ),
    ),
  );
}
