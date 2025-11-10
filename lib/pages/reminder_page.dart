import 'package:flutter/material.dart';
import 'package:nutrisport/services/notification_service.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  TimeOfDay _trainingTime = TimeOfDay.now();
  final List<Reminder> _reminders = [];

  @override
  void initState() {
    super.initState();
    _loadDefaultReminders();
  }

  void _loadDefaultReminders() {
    setState(() {
      _reminders.addAll([
        Reminder(
          id: 1,
          title: 'Pre-workout Meal',
          description: 'Makan 1.5 jam sebelum latihan - Oatmeal dengan buah atau roti gandum dengan telur',
          isActive: true,
          offset: const Duration(hours: 1, minutes: 30),
        ),
        Reminder(
          id: 2,
          title: 'Konsumsi Creatine',
          description: '5g creatine dengan air - Konsumsi 30 menit sebelum latihan',
          isActive: true,
          offset: const Duration(minutes: 30),
        ),
        Reminder(
          id: 3,
          title: 'Siapkan Minuman Isotonik',
          description: 'Siapkan minuman isotonik untuk latihan > 1.5 jam',
          isActive: false,
          offset: const Duration(minutes: 15),
        ),
        Reminder(
          id: 4,
          title: 'Post-workout Meal',
          description: 'Makan dalam 30 menit setelah latihan - Protein tinggi + karbohidrat kompleks',
          isActive: true,
          offset: const Duration(hours: -1), // Negative duration for after training
        ),
        Reminder(
          id: 5,
          title: 'Konsumsi Whey Protein',
          description: '30g whey protein setelah latihan - Dalam 45 menit setelah latihan',
          isActive: true,
          offset: const Duration(hours: -1, minutes: -15), // 1 hour 15 minutes after
        ),
      ]);
    });
  }

  Future<void> _selectTrainingTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _trainingTime,
    );
    
    if (picked != null) {
      setState(() {
        _trainingTime = picked;
      });
    }
  }

  void _scheduleReminders() {
    final now = DateTime.now();
    final trainingDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _trainingTime.hour,
      _trainingTime.minute,
    );

    // Jika waktu latihan sudah lewat hari ini, schedule untuk besok
    final scheduledTrainingTime = trainingDateTime.isBefore(now)
        ? trainingDateTime.add(const Duration(days: 1))
        : trainingDateTime;

    int scheduledCount = 0;

    for (final reminder in _reminders) {
      if (reminder.isActive) {
        final reminderTime = scheduledTrainingTime.subtract(reminder.offset);
        
        if (reminderTime.isAfter(now)) {
          NotificationService.scheduleNotification(
            id: reminder.id,
            title: reminder.title,
            body: reminder.description,
            scheduledTime: reminderTime,
          );
          scheduledCount++;
        }
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$scheduledCount pengingat berhasil dijadwalkan untuk ${_formatTime(scheduledTrainingTime)}'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _toggleReminder(int id) {
    setState(() {
      final reminder = _reminders.firstWhere((r) => r.id == id);
      reminder.isActive = !reminder.isActive;
    });
  }

  void _testNotification() {
    NotificationService.showInstantNotification(
      title: 'Test Notification',
      body: 'Ini adalah test notifikasi dari NutriSport',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Test notifikasi berhasil dikirim')),
    );
  }

  void _cancelAllNotifications() {
    NotificationService.cancelAllNotifications();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Semua pengingat dibatalkan')),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _getOffsetText(Duration offset) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengingat Makan & Suplemen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: _testNotification,
            tooltip: 'Test Notifikasi',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_off),
            onPressed: _cancelAllNotifications,
            tooltip: 'Batalkan Semua Pengingat',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Training Time Selection
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Atur Jam Latihan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.access_time, color: Colors.blue),
                      title: const Text('Jam Latihan'),
                      subtitle: Text(
                        _trainingTime.format(context),
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: _selectTrainingTime,
                      ),
                      onTap: _selectTrainingTime,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _scheduleReminders,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Jadwalkan Semua Pengingat'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Reminders List
            const Text(
              'Daftar Pengingat',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            ..._reminders.map((reminder) => _buildReminderCard(reminder)),

            // Tips Section
            const SizedBox(height: 24),
            _buildTipsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderCard(Reminder reminder) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      color: reminder.isActive ? null : Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Switch(
              value: reminder.isActive,
              onChanged: (_) => _toggleReminder(reminder.id),
              activeColor: Colors.blue,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: reminder.isActive ? null : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reminder.description,
                    style: TextStyle(
                      color: reminder.isActive ? Colors.grey[600] : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getOffsetText(reminder.offset),
                    style: TextStyle(
                      color: reminder.isActive ? Colors.blue[600] : Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tips Pengaturan Pengingat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildTipItem('Pilih jam latihan yang sesuai dengan jadwal rutin Anda'),
            _buildTipItem('Aktifkan hanya pengingat yang diperlukan'),
            _buildTipItem('Pre-workout meal: 1-2 jam sebelum latihan'),
            _buildTipItem('Post-workout nutrition: dalam 30-60 menit setelah latihan'),
            _buildTipItem('Notifikasi akan muncul sesuai jadwal yang ditetapkan'),
            _buildTipItem('Pastikan izin notifikasi diaktifkan pada pengaturan perangkat'),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info, size: 16, color: Colors.blue[400]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class Reminder {
  final int id;
  final String title;
  final String description;
  bool isActive;
  final Duration offset;

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.isActive,
    required this.offset,
  });
}