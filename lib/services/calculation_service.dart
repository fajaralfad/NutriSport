class CalculationService {
  // Calculate BMR using Mifflin-St Jeor equation
  static double calculateBMR({
    required double weight,
    required double height,
    required int age,
    required String gender,
  }) {
    if (gender.toLowerCase() == 'pria') {
      return (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      return (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }
  }

  // Calculate TDEE
  static double calculateTDEE(double bmr, String intensity) {
    final multipliers = {
      'Sedentary': 1.2,
      'Ringan': 1.375,
      'Sedang': 1.55,
      'Berat': 1.725,
      'Atlet Intens': 1.9,
    };
    
    return bmr * (multipliers[intensity] ?? 1.55);
  }

  // Calculate Macronutrients
  static Map<String, double> calculateMacronutrients({
    required double weight,
    required String sportType,
    required String goal,
  }) {
    Map<String, List<double>> macroRanges = {
      'Strength/Muscle': [1.8, 2.2, 4.0, 6.0, 0.8, 1.2], // protein, carbs, fat
      'Endurance/Running': [1.2, 1.6, 6.0, 8.0, 1.0, 1.5],
      'Mixed/Team Sport': [1.6, 2.0, 5.0, 7.0, 1.0, 1.4],
    };

    final ranges = macroRanges[sportType] ?? [1.6, 2.0, 5.0, 7.0, 1.0, 1.4];
    
    // Use mid-range values for calculation
    final protein = weight * ((ranges[0] + ranges[1]) / 2);
    final carbs = weight * ((ranges[2] + ranges[3]) / 2);
    final fat = weight * ((ranges[4] + ranges[5]) / 2);

    return {
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }

  // Calculate Hydration Needs
  static double calculateHydrationNeeds({
    required double weight,
    required double exerciseDuration,
    required String intensity,
  }) {
    final baseNeed = weight * 0.04; // 40 ml per kg
    double exerciseAddition = 0.0;
    
    if (intensity == 'Ringan') {
      exerciseAddition = exerciseDuration * 0.4;
    } else if (intensity == 'Sedang') {
      exerciseAddition = exerciseDuration * 0.6;
    } else {
      exerciseAddition = exerciseDuration * 0.8;
    }
    
    return baseNeed + exerciseAddition;
  }
}