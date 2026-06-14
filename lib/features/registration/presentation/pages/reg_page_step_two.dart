import 'package:flutter/material.dart';
import 'package:gyn_tracking/features/registration/presentation/pages/reg_page_step_three.dart';

class RegPageStepTwo extends StatefulWidget {
  const RegPageStepTwo({super.key});

  @override
  State<RegPageStepTwo> createState() => _RRegPageStepTwoState();
}

class _RRegPageStepTwoState extends State<RegPageStepTwo> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    ageController.dispose();
    emailController.dispose();
    mobileNoController.dispose();
    passwordController.dispose();
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
              child: Column(
                children: [
                  const Text(
                    "Step 2 of 3",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),

                  const SizedBox(height: 8),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: fieldDecoration("Age", Icons.numbers),
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    items: const [
                      DropdownMenuItem(value: "Male", child: Text("Male")),
                      DropdownMenuItem(value: "Female", child: Text("Female")),
                      DropdownMenuItem(value: "Other", child: Text("Other")),
                    ],
                    onChanged: (_) {},
                    decoration: const InputDecoration(labelText: "Gender"),
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: fieldDecoration("Height (cm)", Icons.height),
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: fieldDecoration(
                      "Current Weight (kg)",
                      Icons.monitor_weight_outlined,
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: fieldDecoration(
                      "Target Weight (kg)",
                      Icons.monitor_weight_outlined,
                    ),
                  ),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegPageStepThree()),
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
