import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'src/core/core.dart';
import 'src/features/features.dart';



class BeShapeApp extends StatelessWidget {
    final ValueNotifier<GraphQLClient> graphQLClient;

  const BeShapeApp({super.key, required this.graphQLClient});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
      child: GraphQLProvider(
         client: graphQLClient,
        child: CacheProvider(
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
        ),
      ),
    );
  }
}