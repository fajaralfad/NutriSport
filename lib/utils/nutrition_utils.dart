import 'package:flutter/material.dart';
import 'package:nutrisport/models/user_data.dart';
import 'package:nutrisport/models/nutrition_data.dart';
import 'package:nutrisport/services/calculation_service.dart';
import 'package:nutrisport/services/database_service.dart';

class NutritionUtils {
  static Animation<double> createFadeAnimation(TickerProvider vsync) {
    final controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: vsync,
    );
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
    controller.forward();
    return animation;
  }

  static void showSuccessMessage(BuildContext context, String message) {
    _showSnackBar(context, message, Icons.check_circle, Colors.green);
  }

  static void showWarningMessage(BuildContext context, String message) {
    _showSnackBar(context, message, Icons.warning_rounded, Colors.orange);
  }

  static void _showSnackBar(
    BuildContext context,
    String message,
    IconData icon,
    Color color,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class NutritionController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  
  String gender = 'Pria';
  String sportType = 'Strength/Muscle';
  String intensity = 'Sedang';
  String goal = 'Maintenance';
  
  NutritionData? calculatedData;
  bool isCalculating = false;

  // Tambahkan formKey di sini
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void initialize() {
    _loadExistingData();
  }

  void _loadExistingData() {
    final userData = DatabaseService.getUserData();
    if (userData != null) {
      nameController.text = userData.name;
      ageController.text = userData.age.toString();
      weightController.text = userData.weight.toString();
      heightController.text = userData.height.toString();
      gender = userData.gender;
      sportType = userData.sportType;
      intensity = userData.intensity;
      goal = userData.goal;
    }

    final latestNutrition = DatabaseService.getLatestNutritionData();
    if (latestNutrition != null) {
      calculatedData = latestNutrition;
    }
  }

  bool calculateNutrition() {
    if (!formKey.currentState!.validate()) return false;

    isCalculating = true;

    final weight = double.parse(weightController.text);
    final height = double.parse(heightController.text);
    final age = int.parse(ageController.text);

    final bmr = CalculationService.calculateBMR(
      weight: weight,
      height: height,
      age: age,
      gender: gender,
    );

    final tdee = CalculationService.calculateTDEE(bmr, intensity);
    final macros = CalculationService.calculateMacronutrients(
      weight: weight,
      sportType: sportType,
      goal: goal,
    );

    double adjustedCalories = tdee;
    if (goal == 'Cutting') {
      adjustedCalories = tdee * 0.8;
    } else if (goal == 'Bulking') {
      adjustedCalories = tdee * 1.2;
    }

    calculatedData = NutritionData(
      bmr: bmr,
      tdee: tdee,
      protein: macros['protein']!,
      carbs: macros['carbs']!,
      fat: macros['fat']!,
      calories: adjustedCalories,
      calculatedAt: DateTime.now(),
    );

    _saveData(weight, height, age);
    isCalculating = false;
    return true;
  }

  void _saveData(double weight, double height, int age) {
    final userData = UserData(
      name: nameController.text,
      age: age,
      gender: gender,
      weight: weight,
      height: height,
      sportType: sportType,
      intensity: intensity,
      goal: goal,
    );

    DatabaseService.saveUserData(userData);
    DatabaseService.saveNutritionData(calculatedData!);
  }

  void dispose() {
    nameController.dispose();
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
  }
}