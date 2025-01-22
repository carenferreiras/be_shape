import 'package:be_shape_app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/features/features.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
        ],
        child: const BeShapeApp(),
      ),
    ),
  );
}