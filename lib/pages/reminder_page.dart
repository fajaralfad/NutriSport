import 'package:flutter/material.dart';
import '../models/reminder_model.dart';
import '../services/reminder_storage_service.dart';
import '../services/notification_service.dart';
import '../utils/reminder_helpers.dart';
import '../widgets/reminder/reminder_widgets.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage>
    with SingleTickerProviderStateMixin {
  TimeOfDay _trainingTime = TimeOfDay.now();
  final List<Reminder> _reminders = [];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _loadData();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    _trainingTime = await ReminderStorageService.loadTrainingTime();
    final reminders = await ReminderStorageService.loadReminders();
    setState(() {
      _reminders.clear();
      _reminders.addAll(reminders);
    });
  }

  Future<void> _selectTrainingTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _trainingTime,
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
      setState(() => _trainingTime = picked);
      await ReminderStorageService.saveTrainingTime(picked);
    }
  }

  void _scheduleReminders() async {
    final activeReminders = _reminders.where((r) => r.isActive).toList();
    
    if (activeReminders.isEmpty) {
      _showNoActiveRemindersSnackbar();
      return;
    }

    final result = await ReminderHelpers.scheduleReminders(
      reminders: _reminders,
      trainingTime: _trainingTime,
    );

    await ReminderStorageService.saveReminders(_reminders);

    if (!mounted) return;
    _showScheduleResultSnackbar(result);
  }

  void _showNoActiveRemindersSnackbar() {
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

  void _showScheduleResultSnackbar(Map<String, int> result) {
  final scheduledCount = result['scheduled']!;
  final skippedCount = result['skipped']!;
  final isToday = result['isToday']! == 1;
  
  final now = DateTime.now();
  
  // Gunakan logika yang sama dengan ReminderHelpers
  final trainingDateTime = DateTime(
    now.year,
    now.month,
    now.day,
    _trainingTime.hour,
    _trainingTime.minute,
  );
  
  // Tentukan waktu training yang benar
  final scheduledTrainingTime = isToday ? trainingDateTime : trainingDateTime.add(const Duration(days: 1));
  
  // Format waktu dengan benar
  final formattedTime = ReminderHelpers.formatTime(scheduledTrainingTime);
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

  void _toggleReminder(int id) async {
    setState(() {
      final reminder = _reminders.firstWhere((r) => r.id == id);
      reminder.isActive = !reminder.isActive;
    });
    await ReminderStorageService.saveReminders(_reminders);
  }

  void _testNotification() {
    NotificationService.showInstantNotification(
      title: 'Test Notification',
      body: 'Ini adalah test notifikasi dari NutriSport',
    );

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

  void _cancelAllNotifications() {
    NotificationService.cancelAllNotifications();

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        title: const Text('Pengingat Makan & Suplemen'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_rounded),
            onPressed: _testNotification,
            tooltip: 'Test Notifikasi',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_off_rounded),
            onPressed: _cancelAllNotifications,
            tooltip: 'Batalkan Semua',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReminderInfoBanner(isDark: isDark),
              const SizedBox(height: 24),
              TrainingTimeSection(
                isDark: isDark,
                trainingTime: _trainingTime,
                onSelectTime: _selectTrainingTime,
                onSchedule: _scheduleReminders,
              ),
              const SizedBox(height: 24),
              RemindersHeader(
                isDark: isDark,
                activeCount: _reminders.where((r) => r.isActive).length,
                totalCount: _reminders.length,
              ),
              const SizedBox(height: 16),
              ..._reminders.map((reminder) => ReminderCard(
                    reminder: reminder,
                    isDark: isDark,
                    onToggle: _toggleReminder,
                  )),
              const SizedBox(height: 24),
              TipsSection(isDark: isDark),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}