import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/core/core.dart';
import 'src/features/features.dart';



class BeShapeApp extends StatelessWidget {
  const BeShapeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authRepository: context.read<AuthRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => OnboardingBloc(
            userRepository: context.read<UserRepository>(),
            authRepository: context.read<AuthRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => MealBloc(
            mealRepository: context.read<MealRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Health Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: AppRouter.initial,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}