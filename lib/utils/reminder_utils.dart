import 'package:flutter/material.dart';
import 'package:nutrisport/models/reminder_model.dart';
import 'package:nutrisport/services/reminder_storage_service.dart';
import 'package:nutrisport/services/notification_service.dart';

class ReminderUtils {
  static Animation<double> createFadeAnimation(TickerProvider vsync) {
    final controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: vsync,
    );
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
    controller.forward();
    return animation;
  }

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

  static Future<Map<String, int>?> scheduleReminders({
    required List<Reminder> reminders,
    required TimeOfDay trainingTime,
  }) async {
    final now = DateTime.now();
    
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

    if (activeReminders.isEmpty) {
      return null;
    }

    for (final reminder in activeReminders) {
      try {
        final reminderTime = scheduledTrainingTime.subtract(reminder.offset);
        
        if (reminderTime.isAfter(now)) {
          await NotificationService.scheduleNotification(
            id: reminder.id,
            title: reminder.title,
            body: reminder.description,
            scheduledTime: reminderTime,
          );
          scheduledCount++;
        } else {
          skippedCount++;
        }
      } catch (e) {
        skippedCount++;
      }
    }

    return {
      'scheduled': scheduledCount,
      'skipped': skippedCount,
      'isToday': isToday ? 1 : 0,
    };
  }

  static void showNoActiveRemindersSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text('Tidak ada pengingat yang aktif. Aktifkan minimal 1 pengingat terlebih dahulu.'),
            ),
          ],
        ),
        backgroundColor: Colors.orange[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showScheduleResultSnackbar(
    BuildContext context, 
    Map<String, int> result, 
    TimeOfDay trainingTime
  ) {
    final scheduledCount = result['scheduled']!;
    final skippedCount = result['skipped']!;
    final isToday = result['isToday']! == 1;
    
    final now = DateTime.now();
    final trainingDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      trainingTime.hour,
      trainingTime.minute,
    );
    
    final scheduledTrainingTime = isToday ? trainingDateTime : trainingDateTime.add(const Duration(days: 1));
    final formattedTime = ReminderUtils.formatTime(scheduledTrainingTime);
    final dayInfo = isToday ? 'hari ini' : 'besok';

    if (scheduledCount == 0 && skippedCount > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Semua pengingat sudah melewati waktu hari ini. Pengingat akan dijadwalkan untuk $dayInfo pukul $formattedTime',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.blue[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    } else if (scheduledCount > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$scheduledCount pengingat berhasil dijadwalkan',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (skippedCount > 0)
                      Text(
                        '$skippedCount pengingat dilewati (sudah lewat waktu)',
                        style: const TextStyle(fontSize: 12),
                      ),
                    Text(
                      'Untuk latihan $dayInfo pukul $formattedTime',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  static void showTestNotificationSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.notifications_active, color: Colors.white),
            SizedBox(width: 12),
            Text('Test notifikasi berhasil dikirim'),
          ],
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static void showCancelAllSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.notifications_off, color: Colors.white),
            SizedBox(width: 12),
            Text('Semua pengingat dibatalkan'),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class ReminderController {
  TimeOfDay trainingTime = TimeOfDay.now();
  final List<Reminder> _reminders = [];

  List<Reminder> get reminders => _reminders;
  int get activeRemindersCount => _reminders.where((r) => r.isActive).length;

  Future<void> initialize() async {
    trainingTime = await ReminderStorageService.loadTrainingTime();
    final reminders = await ReminderStorageService.loadReminders();
    _reminders.clear();
    _reminders.addAll(reminders);
  }

  Future<TimeOfDay?> selectTrainingTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: trainingTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      trainingTime = picked;
      await ReminderStorageService.saveTrainingTime(picked);
      return picked;
    }
    return null;
  }

  Future<Map<String, int>?> scheduleReminders() async {
    final result = await ReminderUtils.scheduleReminders(
      reminders: _reminders,
      trainingTime: trainingTime,
    );

    if (result != null) {
      await ReminderStorageService.saveReminders(_reminders);
    }

    return result;
  }

  void toggleReminder(int id) {
    final reminder = _reminders.firstWhere((r) => r.id == id);
    reminder.isActive = !reminder.isActive;
    ReminderStorageService.saveReminders(_reminders);
  }

  void testNotification() {
    NotificationService.showInstantNotification(
      title: 'Test Notification',
      body: 'Ini adalah test notifikasi dari NutriSport',
    );
  }

  void cancelAllNotifications() {
    NotificationService.cancelAllNotifications();
  }

  void dispose() {
    // Cleanup jika diperlukan
  }
}