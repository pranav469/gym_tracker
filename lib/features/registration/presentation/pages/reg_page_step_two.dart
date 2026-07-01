import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyn_tracking/features/home/presentation/pages/home_screen.dart';
import 'package:gyn_tracking/features/registration/presentation/pages/reg_page_step_three.dart';

import '../../../../main_screen.dart';
import '../../domain/entities/user_profile.dart';
import '../bloc/registartion_event.dart';
import '../bloc/registration_bloc.dart';

class RegPageStepTwo extends StatefulWidget {
  final UserProfile profile;
  const RegPageStepTwo({super.key, required this.profile});

  @override
  State<RegPageStepTwo> createState() => _RRegPageStepTwoState();
}

class _RRegPageStepTwoState extends State<RegPageStepTwo> {
  // final TextEditingController ageController = TextEditingController();
  // final TextEditingController emailController = TextEditingController();
  // final TextEditingController mobileNoController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    // ageController.dispose();
    // emailController.dispose();
    // mobileNoController.dispose();
    // passwordController.dispose();
  }

  late TextEditingController targetWeightController;
  late TextEditingController calorieController;
  late TextEditingController proteinController;
  late TextEditingController carbController;
  late TextEditingController fatController;
  late TextEditingController waterController;

  @override
  void initState() {
    super.initState();

    targetWeightController =
        TextEditingController(
          text: widget.profile.targetWeight.toStringAsFixed(1),
        );

    calorieController =
        TextEditingController(
          text: widget.profile.dailyCalorieTarget.toString(),
        );

    proteinController =
        TextEditingController(
          text: widget.profile.dailyProteinTarget.toStringAsFixed(1),
        );

    carbController =
        TextEditingController(
          text: widget.profile.dailyCarbTarget.toStringAsFixed(1),
        );

    fatController =
        TextEditingController(
          text: widget.profile.dailyFatTarget.toStringAsFixed(1),
        );

    waterController =
        TextEditingController(
          text: widget.profile.dailyWaterTarget.toStringAsFixed(1),
        );
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration fieldDecoration(String label, IconData icon) {
      return InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      );
    }

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
              child:Column(
                children: [

                  Text(
                    "Review Your Daily Targets",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 25),

                  TextFormField(
                    controller: targetWeightController,
                    decoration: const InputDecoration(
                      labelText: "Target Weight (kg)",
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  SizedBox(height: 15),

                  TextFormField(
                    controller: calorieController,
                    decoration: const InputDecoration(
                      labelText: "Calories",
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  SizedBox(height: 15),

                  TextFormField(
                    controller: proteinController,
                    decoration: const InputDecoration(
                      labelText: "Protein (g)",
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  SizedBox(height: 15),

                  TextFormField(
                    controller: carbController,
                    decoration: const InputDecoration(
                      labelText: "Carbs (g)",
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  SizedBox(height: 15),

                  TextFormField(
                    controller: fatController,
                    decoration: const InputDecoration(
                      labelText: "Fat (g)",
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  SizedBox(height: 15),

                  TextFormField(
                    controller: waterController,
                    decoration: const InputDecoration(
                      labelText: "Water (L)",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              )
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
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (_) => const RegPageStepThree()),
                  // );
                  final updatedProfile = UserProfile(
                    id: widget.profile.id,
                    name: widget.profile.name,
                    email: widget.profile.email,
                    age: widget.profile.age,
                    gender: widget.profile.gender,
                    height: widget.profile.height,
                    currentWeight: widget.profile.currentWeight,

                    targetWeight:
                    double.parse(targetWeightController.text),

                    goal: widget.profile.goal,

                    activityLevel: widget.profile.activityLevel,

                    workoutDays: widget.profile.workoutDays,

                    dailyCalorieTarget:
                    int.parse(calorieController.text),

                    dailyProteinTarget:
                    double.parse(proteinController.text),

                    dailyCarbTarget:
                    double.parse(carbController.text),

                    dailyFatTarget:
                    double.parse(fatController.text),

                    dailyWaterTarget:
                    double.parse(waterController.text),
                  );

                  context.read<RegistrationBloc>().add(
                    SaveProfileEvent(updatedProfile),
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MainScreen()),
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
