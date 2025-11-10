import 'package:hive/hive.dart';

part 'user_data.g.dart';

@HiveType(typeId: 0)
class UserData {
  @HiveField(0)
  final String name;
  
  @HiveField(1)
  final int age;
  
  @HiveField(2)
  final String gender;
  
  @HiveField(3)
  final double weight;
  
  @HiveField(4)
  final double height;
  
  @HiveField(5)
  final String sportType;
  
  @HiveField(6)
  final String intensity;
  
  @HiveField(7)
  final String goal;

  UserData({
    required this.name,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    required this.sportType,
    required this.intensity,
    required this.goal,
  });
}