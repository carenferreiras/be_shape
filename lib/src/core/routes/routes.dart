import 'package:be_shape_app/src/features/chat/presentation/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/features.dart';

class AppRouter {
  static const String initial = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String onboarding = '/onboarding';
  static const String addMeal = '/add-meal';
  static const String addCalories = '/add-calories';
  static const String addFoodTracking = '/add-food';
  static const String mealHistory = '/meal-history';
  static const String addExercise = '/add-exercise';
  static const String addProgressPhoto = '/add-progress-photo';
  static const String addSavedFood = '/saved-food';
  static const String reports = '/reports';
  static const String dailyTracking = '/daily-tracking';
  static const String reportDetails = '/report-details';
  static const String progressPhotos = '/progress-photos';
  static const String exercisesList = '/exercises-list';
  static const String healthPage = '/health-page';
  static const String chatScreen = '/chat-screen';
  static const String habit = '/habits';
  static const String waterTracker ='/water-tracker'; 
  static const String profile = '/profile';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute(
          builder: (_) =>  SplashScreen(),
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );
      case addMeal:
        return MaterialPageRoute(
          builder: (_) => const AddMealScreen(),
        );
      case addCalories:
        return MaterialPageRoute(
          builder: (_) => const DailyFoodTrackingScreen(),
        );
      case addFoodTracking:
        return MaterialPageRoute(
          builder: (_) => const AddFoodScreen(),
        );
      case mealHistory:
        return MaterialPageRoute(
          builder: (_) => const MealHistoryScreen(),
        );
      case reports:
        return MaterialPageRoute(
          builder: (_) => const ReportsListScreen(),
        );
      case reportDetails:
        final report = settings.arguments as DailyReport;
        return MaterialPageRoute(
          builder: (_) => DailyReportScreen(report: report),
        );
      case addExercise:
        return MaterialPageRoute(
          builder: (_) => const AddExerciseScreen(),
        );
      case dailyTracking:
        return MaterialPageRoute(
          builder: (_) => const DailyFoodTrackingScreen(),
        );
      case addSavedFood:
        return MaterialPageRoute(
          builder: (_) => const SavedFoodFormScreen(),
        );
      case addProgressPhoto:
        return MaterialPageRoute(
          builder: (_) => const AddProgressPhotoScreen(),
        );
      case progressPhotos:
        return MaterialPageRoute(
          builder: (_) => const ProgressPhotosScreen(),
        );
      case exercisesList:
        return MaterialPageRoute(
          builder: (_) => const ExerciseListScreen(),
        );
      case profile:
        return MaterialPageRoute(builder: (_)=> const UserProfileScreen());
      case healthPage:
        return MaterialPageRoute(builder: (_) => const HealthPage());
      case chatScreen:
        return MaterialPageRoute(builder: (_) => const ChatScreen());
      case habit:
        return MaterialPageRoute(builder: (_) => const HabitsScreen());
      case waterTracker:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: BlocProvider.of<WaterBloc>(
                _), // 🟢 Obtém o WaterBloc do contexto global
            child: const WaterTrackerScreen(),
          ),
        ); // 📌 Chama a tela de água

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
