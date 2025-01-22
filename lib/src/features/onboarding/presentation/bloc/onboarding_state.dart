class OnboardingState {
  final String? selectedGoal;
  final String? selectedGender;
  final double weight;
  final String weightUnit;
  final int? age;
  final double? height;
  final double? targetWeight;
  final double? activityLevel;
  final String? name;
  final bool isProfileSaved;
  final String? error;

  const OnboardingState({
    this.selectedGoal,
    this.selectedGender,
    this.weight = 70.0,
    this.weightUnit = 'kg',
    this.age,
    this.height,
    this.targetWeight,
    this.activityLevel,
    this.name,
    this.isProfileSaved = false,
    this.error,
  });

  OnboardingState copyWith({
    String? selectedGoal,
    String? selectedGender,
    double? weight,
    String? weightUnit,
    int? age,
    double? height,
    double? targetWeight,
    double? activityLevel,
    String? name,
    bool? isProfileSaved,
    String? error,
  }) {
    return OnboardingState(
      selectedGoal: selectedGoal ?? this.selectedGoal,
      selectedGender: selectedGender ?? this.selectedGender,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
      age: age ?? this.age,
      height: height ?? this.height,
      targetWeight: targetWeight ?? this.targetWeight,
      activityLevel: activityLevel ?? this.activityLevel,
      name: name ?? this.name,
      isProfileSaved: isProfileSaved ?? this.isProfileSaved,
      error: error ?? this.error,
    );
  }
}