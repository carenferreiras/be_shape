import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features.dart';



class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Initialize default values
    final bloc = context.read<OnboardingBloc>();
    bloc.add(const UpdateAge(25));
    bloc.add(const UpdateHeight(170));
    bloc.add(const UpdateWeight(70));
    bloc.add(const UpdateActivityLevel(1.2));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  bool _canProceed(OnboardingState state) {
    switch (_currentPage) {
      case 0: // Goal selection
        return state.selectedGoal != null;
      case 1: // Gender selection
        return state.selectedGender != null;
      case 2: // Age input
        return state.age != null && state.age! >= 13 && state.age! <= 100;
      case 3: // Height input
        return state.height != null && state.height! >= 140 && state.height! <= 220;
      case 4: // Weight input
        return state.weight >= 40 && state.weight <= 200;
      case 5: // Activity level
        return state.activityLevel != null;
      default:
        return false;
    }
  }

  Future<void> _finishOnboarding(BuildContext context) async {
    try {
      context.read<OnboardingBloc>().add(const SaveUserProfile());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
        if (state.isProfileSaved) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: () {
                          if (_currentPage > 0) {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      Text(
                        '${_currentPage + 1} of 6',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      GoalSelectionStep(),
                      GenderSelectionStep(),
                      AgeInputStep(),
                      HeightInputStep(),
                      WeightInputStep(),
                      ActivityLevelStep(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      StepIndicator(
                        currentStep: _currentPage,
                        totalSteps: 6,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: !_canProceed(state)
                              ? null
                              : () {
                                  if (_currentPage < 5) {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  } else {
                                    _finishOnboarding(context);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: state.isProfileSaved
                              ? const CircularProgressIndicator()
                              : Text(
                                  _currentPage < 5 ? 'Continue' : 'Get Started',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}