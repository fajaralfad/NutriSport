import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reminder_model.dart';

class ReminderStorageService {
  static const String _trainingTimeHourKey = 'training_time_hour';
  static const String _trainingTimeMinuteKey = 'training_time_minute';
  static const String _remindersListKey = 'reminders_list';

  // Training Time Operations
  static Future<TimeOfDay> loadTrainingTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt(_trainingTimeHourKey) ?? TimeOfDay.now().hour;
    final minute = prefs.getInt(_trainingTimeMinuteKey) ?? TimeOfDay.now().minute;
    return TimeOfDay(hour: hour, minute: minute);
  }

  static Future<void> saveTrainingTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_trainingTimeHourKey, time.hour);
    await prefs.setInt(_trainingTimeMinuteKey, time.minute);
  }

  // Reminders Operations
  static Future<List<Reminder>> loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final remindersJson = prefs.getStringList(_remindersListKey);
    
    if (remindersJson != null && remindersJson.isNotEmpty) {
      final reminders = <Reminder>[];
      for (final json in remindersJson) {
        final reminder = Reminder.fromJson(json);
        if (reminder != null) {
          reminders.add(reminder);
        }
      }
      return reminders;
    }
    
    return getDefaultReminders();
  }

  static Future<void> saveReminders(List<Reminder> reminders) async {
    final prefs = await SharedPreferences.getInstance();
    final remindersJson = reminders.map((r) => r.toJson()).toList();
    await prefs.setStringList(_remindersListKey, remindersJson);
  }

  static List<Reminder> getDefaultReminders() {
    return [
      Reminder(
        id: 1,
        title: 'Pre-workout Meal',
        description: 'Makan 1.5 jam sebelum latihan - Oatmeal dengan buah atau roti gandum dengan telur',
        iconCode: 'restaurant',
        color: Colors.orange,
        isActive: true,
        offset: const Duration(hours: 1, minutes: 30),
      ),
      Reminder(
        id: 2,
        title: 'Konsumsi Creatine',
        description: '5g creatine dengan air - Konsumsi 30 menit sebelum latihan',
        iconCode: 'science',
        color: Colors.purple,
        isActive: true,
        offset: const Duration(minutes: 30),
      ),
      Reminder(
        id: 3,
        title: 'Siapkan Minuman Isotonik',
        description: 'Siapkan minuman isotonik untuk latihan > 1.5 jam',
        iconCode: 'local_drink',
        color: Colors.cyan,
        isActive: false,
        offset: const Duration(minutes: 15),
      ),
      Reminder(
        id: 4,
        title: 'Post-workout Meal',
        description: 'Makan dalam 30 menit setelah latihan - Protein tinggi + karbohidrat kompleks',
        iconCode: 'dinner_dining',
        color: Colors.green,
        isActive: true,
        offset: const Duration(hours: -1),
      ),
      Reminder(
        id: 5,
        title: 'Konsumsi Whey Protein',
        description: '30g whey protein setelah latihan - Dalam 45 menit setelah latihan',
        iconCode: 'fitness_center',
        color: Colors.blue,
        isActive: true,
        offset: const Duration(hours: -1, minutes: -15),
      ),
    ];
  }
}