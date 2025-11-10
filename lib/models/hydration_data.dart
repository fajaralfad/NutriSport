import 'package:hive/hive.dart';

part 'hydration_data.g.dart';

@HiveType(typeId: 2)
class HydrationData {
  @HiveField(0)
  final double weight;
  
  @HiveField(1)
  final double exerciseDuration;
  
  @HiveField(2)
  final String intensity;
  
  @HiveField(3)
  final double recommendedWater;
  
  @HiveField(4)
  final double consumedWater;
  
  @HiveField(5)
  final DateTime date;

  HydrationData({
    required this.weight,
    required this.exerciseDuration,
    required this.intensity,
    required this.recommendedWater,
    required this.consumedWater,
    required this.date,
  });

  double get progress => (consumedWater / recommendedWater).clamp(0.0, 1.0);
}