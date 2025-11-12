import '../models/hydration_data.dart';
import 'database_service.dart';
import 'calculation_service.dart';

class HydrationService {
  static HydrationData? loadTodayData() {
    return DatabaseService.getTodayHydrationData();
  }

  static void saveHydrationData(HydrationData data) {
    DatabaseService.saveHydrationData(data);
  }

  static double calculateHydrationNeeds({
    required double weight,
    required double duration,
    required String intensity,
  }) {
    return CalculationService.calculateHydrationNeeds(
      weight: weight,
      exerciseDuration: duration,
      intensity: intensity,
    );
  }

  static HydrationData createHydrationData({
    required double weight,
    required double duration,
    required String intensity,
    required double recommendedWater,
    required double consumedWater,
  }) {
    return HydrationData(
      weight: weight,
      exerciseDuration: duration,
      intensity: intensity,
      recommendedWater: recommendedWater,
      consumedWater: consumedWater,
      date: DateTime.now(),
    );
  }
}