import 'package:hive/hive.dart';

part 'daily_log.g.dart';

@HiveType(typeId: 3)
class DailyLog {
  @HiveField(0)
  final DateTime date;
  
  @HiveField(1)
  final double weight;
  
  @HiveField(2)
  final double waterConsumed;
  
  @HiveField(3)
  final double caloriesConsumed;
  
  @HiveField(4)
  final String notes;

  DailyLog({
    required this.date,
    required this.weight,
    required this.waterConsumed,
    required this.caloriesConsumed,
    required this.notes,
  });
}