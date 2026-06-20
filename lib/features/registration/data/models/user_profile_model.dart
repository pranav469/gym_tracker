import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  UserProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.age,
    required super.gender,
    required super.height,
    required super.currentWeight,
    required super.targetWeight,
    required super.goal,
    required super.activityLevel,
    required super.workoutDays,
    required super.dailyCalorieTarget,
    required super.dailyProteinTarget,
    required super.dailyCarbTarget,
    required super.dailyFatTarget,
    required super.dailyWaterTarget,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "age": age,
      "gender": gender,
      "height": height,
      "current_weight": currentWeight,
      "target_weight": targetWeight,
      "goal": goal,
      "activity_level": activityLevel,
      "workout_days": workoutDays,
      "daily_calorie_target": dailyCalorieTarget,
      "daily_protein_target": dailyProteinTarget,
      "daily_carb_target": dailyCarbTarget,
      "daily_fat_target": dailyFatTarget,
      "daily_water_target": dailyWaterTarget,
    };
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      age: map['age'] as int,
      gender: map['gender'] as String,
      height: (map['height'] as num).toDouble(),
      currentWeight: (map['current_weight'] as num).toDouble(),
      targetWeight: (map['target_weight'] as num).toDouble(),
      goal: map['goal'] as String,
      activityLevel: map['activity_level'] as String,
      workoutDays: map['workout_days'] as int,
      dailyCalorieTarget: map['daily_calorie_target'] as int,
      dailyProteinTarget:
      (map['daily_protein_target'] as num).toDouble(),
      dailyCarbTarget:
      (map['daily_carb_target'] as num).toDouble(),
      dailyFatTarget:
      (map['daily_fat_target'] as num).toDouble(),
      dailyWaterTarget:
      (map['daily_water_target'] as num).toDouble(),
    );
  }


}