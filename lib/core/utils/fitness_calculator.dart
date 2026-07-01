class FitnessCalculator {
  /// BMR using Mifflin-St Jeor Equation
  static double calculateBMR({
    required double weight,
    required double height,
    required int age,
    required String gender,
  }) {
    if (gender == "Male") {
      return (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      return (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }
  }

  /// TDEE
  static double calculateTDEE({
    required double bmr,
    required String activityLevel,
  }) {
    double factor;

    switch (activityLevel) {
      case "Sedentary":
        factor = 1.2;
        break;

      case "Lightly Active":
        factor = 1.375;
        break;

      case "Moderately Active":
        factor = 1.55;
        break;

      case "Very Active":
        factor = 1.725;
        break;

      default:
        factor = 1.2;
    }

    return bmr * factor;
  }

  /// Calories according to goal
  static int calculateCalories({
    required double tdee,
    required String goal,
  }) {
    switch (goal) {
      case "Weight Loss":
        return (tdee - 500).round();

      case "Weight Gain":
        return (tdee + 300).round();

      default:
        return tdee.round();
    }
  }

  /// Protein (grams/day)
  static double calculateProtein({
    required double weight,
    required String goal,
  }) {
    switch (goal) {
      case "Weight Loss":
        return weight * 2.0;

      case "Weight Gain":
        return weight * 1.8;

      default:
        return weight * 1.6;
    }
  }

  /// Fat (grams/day)
  static double calculateFat(double weight) {
    return weight * 0.8;
  }

  /// Carbs (grams/day)
  static double calculateCarbs({
    required int calories,
    required double protein,
    required double fat,
  }) {
    final proteinCalories = protein * 4;
    final fatCalories = fat * 9;

    final remainingCalories =
        calories - proteinCalories - fatCalories;

    return remainingCalories / 4;
  }

  /// Water (Litres/day)
  static double calculateWater(double weight) {
    return (weight * 35) / 1000;
  }

  /// BMI
  static double calculateBMI({
    required double weight,
    required double height,
  }) {
    final h = height / 100;

    return weight / (h * h);
  }

  /// Suggested target weight (BMI = 22)
  static double calculateTargetWeight(double height) {
    final h = height / 100;

    return 22 * h * h;
  }
}