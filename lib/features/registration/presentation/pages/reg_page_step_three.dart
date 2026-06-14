import 'package:flutter/material.dart';
import 'package:gyn_tracking/features/registration/presentation/pages/reg_page_step_two.dart';

class RegPageStepThree extends StatefulWidget {
  const RegPageStepThree({super.key});

  @override
  State<RegPageStepThree> createState() => _RegPageStepThreeState();
}

class _RegPageStepThreeState extends State<RegPageStepThree> {

  InputDecoration fieldDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

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
        body: SafeArea(child:
      SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

        child: Form(child:
        Column(
          children: [
            const Text(
              "Step 3 of 3",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Goal",
              ),
              items: const [
                DropdownMenuItem(
                  value: "Build Muscle",
                  child: Text("Build Muscle"),
                ),
                DropdownMenuItem(
                  value: "Lose Fat",
                  child: Text("Lose Fat"),
                ),
                DropdownMenuItem(
                  value: "Maintain",
                  child: Text("Maintain Weight"),
                ),
              ],
              onChanged: (_) {},
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Experience",
              ),
              items: const [
                DropdownMenuItem(
                  value: "Beginner",
                  child: Text("Beginner"),
                ),
                DropdownMenuItem(
                  value: "Intermediate",
                  child: Text("Intermediate"),
                ),
                DropdownMenuItem(
                  value: "Advanced",
                  child: Text("Advanced"),
                ),
              ],
              onChanged: (_) {},
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: "Workout Days / Week",
              ),
              items: List.generate(
                7,
                    (index) => DropdownMenuItem(
                  value: index + 1,
                  child: Text("${index + 1}"),
                ),
              ),
              onChanged: (_) {},
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Activity Level",
              ),
              items: const [
                DropdownMenuItem(
                  value: "Sedentary",
                  child: Text("Sedentary"),
                ),
                DropdownMenuItem(
                  value: "Light",
                  child: Text("Lightly Active"),
                ),
                DropdownMenuItem(
                  value: "Moderate",
                  child: Text("Moderately Active"),
                ),
                DropdownMenuItem(
                  value: "Very Active",
                  child: Text("Very Active"),
                ),
              ],
              onChanged: (_) {},
            ),
          ],
        )),
      )
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegPageStepTwo()),
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
