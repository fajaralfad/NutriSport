import 'dart:convert';
import 'package:flutter/material.dart';

class Reminder {
  final int id;
  final String title;
  final String description;
  final String iconCode;
  final Color color;
  bool isActive;
  final Duration offset;

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.iconCode,
    required this.color,
    required this.isActive,
    required this.offset,
  });

  IconData get icon {
    return _iconMap[iconCode] ?? Icons.notifications;
  }

  String toJson() {
    return jsonEncode({
      'id': id,
      'title': title,
      'description': description,
      'iconCode': iconCode,
      'color': color.value,
      'isActive': isActive,
      'offset': offset.inMinutes,
    });
  }

  static Reminder? fromJson(String jsonString) {
    try {
      final data = jsonDecode(jsonString);
      return Reminder(
        id: data['id'],
        title: data['title'],
        description: data['description'],
        iconCode: data['iconCode'],
        color: Color(data['color']),
        isActive: data['isActive'],
        offset: Duration(minutes: data['offset']),
      );
    } catch (e) {
      print('Error parsing reminder: $e');
      return null;
    }
  }

  static final Map<String, IconData> _iconMap = {
    'restaurant': Icons.restaurant_rounded,
    'science': Icons.science_rounded,
    'local_drink': Icons.local_drink_rounded,
    'dinner_dining': Icons.dinner_dining_rounded,
    'fitness_center': Icons.fitness_center_rounded,
    'notifications': Icons.notifications_rounded,
    'alarm': Icons.alarm_rounded,
    'timer': Icons.timer_rounded,
    'schedule': Icons.schedule_rounded,
    'access_time': Icons.access_time_rounded,
  };
}