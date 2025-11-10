class AppConstants {
  // Activity multipliers
  static const Map<String, double> activityMultipliers = {
    'Sedentary': 1.2,
    'Ringan': 1.375,
    'Sedang': 1.55,
    'Berat': 1.725,
    'Atlet Intens': 1.9,
  };

  // Macronutrient ranges per sport type
  static const Map<String, List<double>> macroRanges = {
    'Strength/Muscle': [1.8, 2.2, 4.0, 6.0, 0.8, 1.2],
    'Endurance/Running': [1.2, 1.6, 6.0, 8.0, 1.0, 1.5],
    'Mixed/Team Sport': [1.6, 2.0, 5.0, 7.0, 1.0, 1.4],
  };

  // Hydration multipliers
  static const Map<String, double> hydrationMultipliers = {
    'Ringan': 0.4,
    'Sedang': 0.6,
    'Berat': 0.8,
  };

  // Notification IDs
  static const int preWorkoutMealId = 1;
  static const int creatineReminderId = 2;
  static const int intraWorkoutId = 3;
  static const int postWorkoutMealId = 4;
  static const int proteinReminderId = 5;
}

class AppStrings {
  static const String appName = 'NutriSport';
  static const String appDescription = 'Aplikasi Nutrisi & Recovery Atlet';
  
  static const String hydrationTipsTitle = 'Tips Hidrasi Sehat';
  static const List<String> hydrationTips = [
    'Minum 500ml air 2 jam sebelum latihan',
    'Minum 150-250ml setiap 15-20 menit selama latihan',
    'Minum 500ml setelah latihan untuk rehidrasi',
    'Perhatikan warna urine - harus jernih',
    'Hindari minuman berkafein berlebihan',
  ];
}