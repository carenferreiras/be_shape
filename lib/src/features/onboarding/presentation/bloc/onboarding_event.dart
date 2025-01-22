abstract class OnboardingEvent {
  const OnboardingEvent();
}

class UpdateGoal extends OnboardingEvent {
  final String goal;
  const UpdateGoal(this.goal);
}

class UpdateGender extends OnboardingEvent {
  final String gender;
  const UpdateGender(this.gender);
}

class UpdateWeight extends OnboardingEvent {
  final double weight;
  const UpdateWeight(this.weight);
}

class UpdateWeightUnit extends OnboardingEvent {
  final String unit;
  const UpdateWeightUnit(this.unit);
}

class UpdateAge extends OnboardingEvent {
  final int age;
  const UpdateAge(this.age);
}

class UpdateHeight extends OnboardingEvent {
  final double height;
  const UpdateHeight(this.height);
}

class UpdateTargetWeight extends OnboardingEvent {
  final double targetWeight;
  const UpdateTargetWeight(this.targetWeight);
}

class UpdateActivityLevel extends OnboardingEvent {
  final double activityLevel;
  const UpdateActivityLevel(this.activityLevel);
}

class UpdateName extends OnboardingEvent {
  final String name;
  const UpdateName(this.name);
}

class SaveUserProfile extends OnboardingEvent {
  const SaveUserProfile();
}