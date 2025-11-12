import 'package:flutter/material.dart';
import 'package:nutrisport/services/hydration_service.dart';
import 'package:nutrisport/services/database_service.dart';
import 'package:nutrisport/utils/hydration_validator.dart';

class HydrationUtils {
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

  static Color getProgressColor(double progress) {
    if (progress < 0.3) return Colors.red;
    if (progress < 0.5) return Colors.orange;
    if (progress < 0.7) return Colors.amber;
    if (progress < 1.0) return Colors.lightGreen;
    return Colors.green;
  }
}

class HydrationController {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  
  String intensity = 'Sedang';
  double consumedWater = 0.0;
  double recommendedWater = 0.0;

  void initialize() {
    _loadData();
  }

  void _loadData() {
    final hydrationData = HydrationService.loadTodayData();
    
    if (hydrationData != null) {
      consumedWater = hydrationData.consumedWater;
      recommendedWater = hydrationData.recommendedWater;
      durationController.text = hydrationData.exerciseDuration.toString();
      intensity = hydrationData.intensity;
      weightController.text = hydrationData.weight.toString();
    } else {
      _loadUserWeight();
    }
  }

  void _loadUserWeight() {
    final userData = DatabaseService.getUserData();
    if (userData != null) {
      weightController.text = userData.weight.toString();
    }
  }

  bool calculateHydrationNeeds() {
    if (!HydrationValidator.validateInputs(
        weightController.text, durationController.text)) {
      return false;
    }

    final weight = HydrationValidator.parseDouble(weightController.text);
    final duration = HydrationValidator.parseDouble(durationController.text);

    if (weight == null || duration == null) {
      return false;
    }

    recommendedWater = HydrationService.calculateHydrationNeeds(
      weight: weight,
      duration: duration,
      intensity: intensity,
    );

    final hydrationData = HydrationService.createHydrationData(
      weight: weight,
      duration: duration,
      intensity: intensity,
      recommendedWater: recommendedWater,
      consumedWater: consumedWater,
    );

    HydrationService.saveHydrationData(hydrationData);
    return true;
  }

  void updateWaterConsumption(double newAmount) {
    consumedWater = newAmount;

    final weight = HydrationValidator.parseDouble(weightController.text);
    final duration = HydrationValidator.parseDouble(durationController.text);

    if (weight != null && duration != null) {
      final hydrationData = HydrationService.createHydrationData(
        weight: weight,
        duration: duration,
        intensity: intensity,
        recommendedWater: recommendedWater,
        consumedWater: consumedWater,
      );

      HydrationService.saveHydrationData(hydrationData);
    }
  }

  void dispose() {
    weightController.dispose();
    durationController.dispose();
  }
}