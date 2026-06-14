import 'package:flutter/material.dart';
import 'package:gyn_tracking/features/registration/presentation/pages/reg_page_step_two.dart';

class RegPageStepOne extends StatefulWidget {
  const RegPageStepOne({super.key});

  @override
  State<RegPageStepOne> createState() => _RegPageStepOneState();
}

class _RegPageStepOneState extends State<RegPageStepOne> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
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
    super.dispose();
  }

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
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Step 1 of 3",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),

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
