import 'package:hive/hive.dart';

part 'nutrition_data.g.dart';

@HiveType(typeId: 1)
class NutritionData {
  @HiveField(0)
  final double bmr;
  
  @HiveField(1)
  final double tdee;
  
  @HiveField(2)
  final double protein;
  
  @HiveField(3)
  final double carbs;
  
  @HiveField(4)
  final double fat;
  
  @HiveField(5)
  final double calories;
  
  @HiveField(6)
  final DateTime calculatedAt;

  NutritionData({
    required this.bmr,
    required this.tdee,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.calories,
    required this.calculatedAt,
  });
}