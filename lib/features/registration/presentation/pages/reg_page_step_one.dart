import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyn_tracking/features/registration/presentation/pages/reg_page_step_two.dart';

import '../../../../core/utils/fitness_calculator.dart';
import '../../domain/entities/user_profile.dart';
import '../bloc/registartion_event.dart';
import '../bloc/registration_bloc.dart';

class RegPageStepOne extends StatefulWidget {
  const RegPageStepOne({super.key});

  @override
  State<RegPageStepOne> createState() => _RegPageStepOneState();
}

class _RegPageStepOneState extends State<RegPageStepOne> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileNoController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  InputDecoration fieldDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  String? selectedGender;

  final List<String> genders = ["Male", "Female", "Other"];

  String? selectedDays;

  final List<String> days = ["1", "2", "3", "4", "5", "6"];

  String? selectedGoal;

  final List<String> goals = ["Weight Gain", "Weight Loss", "Keep it"];

  String? selectedLevel;

  final List<String> levels = [
    "Sedentary",
    "Lightly Active",
    "Moderately Active",
    "Very Active",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4CAF50), Color(0xFFE8F5E9)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Text(
                  //   "Step 1 of 3",
                  //   style: TextStyle(color: Colors.grey, fontSize: 15),
                  // ),
                  const SizedBox(height: 8),

                  const Text(
                    "Let's get started 💪",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Create your account to start tracking your fitness journey.",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 32),

                  TextFormField(
                    controller: nameController,
                    decoration: fieldDecoration(
                      "Full Name",
                      Icons.person_outline,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your name";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  TextFormField(
                    controller: ageController,
                    decoration: fieldDecoration(
                      "Age",
                      Icons.onetwothree_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your age";
                      }

                      final age = int.tryParse(value);

                      if (age == null || age < 10 || age > 100) {
                        return "Enter a valid age";
                      }

                      return null;
                    },
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 18),

                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    decoration: InputDecoration(
                      labelText: "Gender",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                    ),
                    items: genders.map((gender) {
                      return DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return "Please select your gender";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                  ),

                  const SizedBox(height: 18),

                  TextFormField(
                    controller: heightController,
                    decoration: fieldDecoration(
                      "Height",
                      Icons.onetwothree_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your height";
                      }

                      if (double.tryParse(value) == null) {
                        return "Invalid height";
                      }

                      return null;
                    },
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 18),

                  TextFormField(
                    controller: weightController,
                    decoration: fieldDecoration(
                      "Weight",
                      Icons.onetwothree_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your weight";
                      }

                      if (double.tryParse(value) == null) {
                        return "Invalid weight";
                      }

                      return null;
                    },
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 18),

                  DropdownButtonFormField<String>(
                    value: selectedDays,
                    decoration: InputDecoration(
                      labelText: "Workout Days",
                      prefixIcon: const Icon(Icons.numbers),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                    ),
                    items: days.map((days) {
                      return DropdownMenuItem(value: days, child: Text(days));
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return "Please select your workout days";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        selectedDays = value;
                      });
                    },
                  ),

                  const SizedBox(height: 18),

                  DropdownButtonFormField<String>(
                    value: selectedGoal,
                    decoration: InputDecoration(
                      labelText: "Goal",
                      prefixIcon: const Icon(Icons.extension_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                    ),
                    items: goals.map((goals) {
                      return DropdownMenuItem(value: goals, child: Text(goals));
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return "Please select your goal";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        selectedGoal = value;
                      });
                    },
                  ),

                  const SizedBox(height: 18),

                  DropdownButtonFormField<String>(
                    value: selectedLevel,
                    decoration: InputDecoration(
                      labelText: "Level",
                      prefixIcon: const Icon(Icons.extension_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                    ),
                    items: levels.map((levels) {
                      return DropdownMenuItem(
                        value: levels,
                        child: Text(levels),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return "Please select your level";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        selectedLevel = value;
                      });
                    },
                  ),

                  const SizedBox(height: 18),

                  TextFormField(
                    controller: emailController,
                    decoration: fieldDecoration("Email", Icons.email_outlined),
                  ),

                  const SizedBox(height: 18),

                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: fieldDecoration("Password", Icons.lock_outline),
                  ),

                  const SizedBox(height: 18),

                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: fieldDecoration(
                      "Confirm Password",
                      Icons.lock_reset_outlined,
                    ),
                  ),

                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  final age = int.parse(ageController.text);
                  final height = double.parse(heightController.text);
                  final weight = double.parse(weightController.text);

                  final bmr = FitnessCalculator.calculateBMR(
                    weight: weight,
                    height: height,
                    age: age,
                    gender: selectedGender!,
                  );

                  final tdee = FitnessCalculator.calculateTDEE(
                    bmr: bmr,
                    activityLevel: selectedLevel!,
                  );

                  final calories = FitnessCalculator.calculateCalories(
                    tdee: tdee,
                    goal: selectedGoal!,
                  );

                  final protein = FitnessCalculator.calculateProtein(
                    weight: weight,
                    goal: selectedGoal!,
                  );

                  final fat = FitnessCalculator.calculateFat(weight);

                  final carbs = FitnessCalculator.calculateCarbs(
                    calories: calories,
                    protein: protein,
                    fat: fat,
                  );

                  final water = FitnessCalculator.calculateWater(weight);

                  final targetWeight = FitnessCalculator.calculateTargetWeight(
                    height,
                  );

                  // context.read<RegistrationBloc>().add(
                  //   SaveProfileEvent(
                  //       UserProfile(
                  //         id: 1,
                  //         name: nameController.text,
                  //         email: emailController.text,
                  //         age: age,
                  //         gender: selectedGender!,
                  //         height: height,
                  //         currentWeight: weight,
                  //         targetWeight: targetWeight,
                  //         goal: selectedGoal!,
                  //         activityLevel: selectedLevel!,
                  //         workoutDays: int.parse(selectedDays!),
                  //         dailyCalorieTarget: calories,
                  //         dailyProteinTarget: protein,
                  //         dailyCarbTarget: carbs,
                  //         dailyFatTarget: fat,
                  //         dailyWaterTarget: water,
                  //       )
                  //   ),
                  // );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegPageStepTwo(
                        profile: UserProfile(
                          id: 1,
                          name: nameController.text,
                          email: emailController.text,
                          age: age,
                          gender: selectedGender!,
                          height: height,
                          currentWeight: weight,
                          targetWeight: targetWeight,
                          goal: selectedGoal!,
                          activityLevel: selectedLevel!,
                          workoutDays: int.parse(selectedDays!),
                          dailyCalorieTarget: calories,
                          dailyProteinTarget: protein,
                          dailyCarbTarget: carbs,
                          dailyFatTarget: fat,
                          dailyWaterTarget: water,
                        ),
                      ),
                    ),
                  );
                },
                child: const Text("Next"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
