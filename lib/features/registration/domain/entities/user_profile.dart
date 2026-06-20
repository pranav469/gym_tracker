class UserProfile {
  final int id;
  final String name;
  final String email;
  final int age;
  final String gender;
  final double height;
  final double currentWeight;
  final double targetWeight;
  final String goal;
  final String activityLevel;
  final int workoutDays;
  final int dailyCalorieTarget;
  final double dailyProteinTarget;
  final double dailyCarbTarget;
  final double dailyFatTarget;
  final double dailyWaterTarget;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.gender,
    required this.height,
    required this.currentWeight,
    required this.targetWeight,
    required this.goal,
    required this.activityLevel,
    required this.workoutDays,
    required this.dailyCalorieTarget,
    required this.dailyProteinTarget,
    required this.dailyCarbTarget,
    required this.dailyFatTarget,
    required this.dailyWaterTarget,
  });
}