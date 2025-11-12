import 'package:flutter/material.dart';
import '../models/reminder_model.dart';
import '../services/notification_service.dart';

class ReminderHelpers {
  static String formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute'; 
  }

  static String getOffsetText(Duration offset) {
    if (offset.inHours > 0) {
      final hours = offset.inHours;
      final minutes = offset.inMinutes.remainder(60);
      if (minutes > 0) {
        return '$hours jam $minutes menit sebelum latihan';
      }
      return '$hours jam sebelum latihan';
    } else if (offset.inMinutes > 0) {
      return '${offset.inMinutes} menit sebelum latihan';
    } else if (offset.inMinutes < 0) {
      final minutes = offset.inMinutes.abs();
      if (minutes > 60) {
        final hours = minutes ~/ 60;
        final remainingMinutes = minutes.remainder(60);
        if (remainingMinutes > 0) {
          return '$hours jam $remainingMinutes menit setelah latihan';
        }
        return '$hours jam setelah latihan';
      }
      return '$minutes menit setelah latihan';
    } else {
      return 'Saat latihan dimulai';
    }
  }

  static Future<Map<String, int>> scheduleReminders({
    required List<Reminder> reminders,
    required TimeOfDay trainingTime,
  }) async {
    final now = DateTime.now();
    
    // Buat DateTime untuk training hari ini
    final trainingToday = DateTime(
      now.year,
      now.month,
      now.day,
      trainingTime.hour,
      trainingTime.minute,
    );
    
    DateTime scheduledTrainingTime;
    bool isToday;
    
    if (trainingToday.isAfter(now)) {
      
      scheduledTrainingTime = trainingToday;
      isToday = true;
    } else {
      
      scheduledTrainingTime = trainingToday.add(const Duration(days: 1));
      isToday = false;
    }

    int scheduledCount = 0;
    int skippedCount = 0;

    final activeReminders = reminders.where((r) => r.isActive).toList();

    // Debug info
    print('=== SCHEDULING DEBUG INFO ===');
    print('Sekarang: $now');
    print('Training today: $trainingToday');
    print('Scheduled training: $scheduledTrainingTime');
    print('isToday: $isToday');
    print('Active reminders: ${activeReminders.length}');

    for (final reminder in activeReminders) {
      try {
        final reminderTime = scheduledTrainingTime.subtract(reminder.offset);
        
        print('--- ${reminder.title} ---');
        print('Offset: ${reminder.offset}');
        print('Reminder time: $reminderTime');
        print('Is after now: ${reminderTime.isAfter(now)}');

        if (reminderTime.isAfter(now)) {
          await NotificationService.scheduleNotification(
            id: reminder.id,
            title: reminder.title,
            body: reminder.description,
            scheduledTime: reminderTime,
          );
          scheduledCount++;
          print('Berhasil dijadwalkan');
        } else {
          skippedCount++;
          print('Dilewati (waktu sudah lewat)');
        }
      } catch (e) {
        print('Error scheduling ${reminder.title}: $e');
        skippedCount++;
      }
      print(''); 
    }

    print('=== RESULT: scheduled=$scheduledCount, skipped=$skippedCount, isToday=$isToday ===');

    return {
      'scheduled': scheduledCount,
      'skipped': skippedCount,
      'isToday': isToday ? 1 : 0,
    };
  }
}