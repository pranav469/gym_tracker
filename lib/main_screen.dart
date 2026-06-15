import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'features/home/presentation/pages/home_screen.dart';
import 'features/nutrition/presentation/pages/nutrition_screen.dart';
import 'features/progress/presentation/pages/progress_screen.dart';
import 'features/workout/presentation/pages/workout_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    WorkoutScreen(),
    NutritionScreen(),
    ProgressScreen(),
    Center(child: Text("Profile")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],

      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(0.08),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 10,
            ),
            child: GNav(
              gap: 8,
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },

              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),

              activeColor: Colors.white,
              color: Colors.grey,

              tabBackgroundColor: Colors.blue,

              tabs: const [
                GButton(
                  icon: Icons.home_rounded,
                  text: "Home",
                ),
                GButton(
                  icon: Icons.fitness_center,
                  text: "Workout",
                ),
                GButton(
                  icon: Icons.rice_bowl,
                  text: "Nutrition",
                ),
                GButton(
                  icon: Icons.show_chart,
                  text: "Progress",
                ),
                GButton(
                  icon: Icons.person,
                  text: "Profile",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}