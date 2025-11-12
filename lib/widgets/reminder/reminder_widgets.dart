import 'package:flutter/material.dart';
import '../../models/reminder_model.dart';
import '../../utils/reminder_helpers.dart';

class ReminderInfoBanner extends StatelessWidget {
  final bool isDark;

  const ReminderInfoBanner({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.deepPurple[700]!.withOpacity(0.3), Colors.deepPurple[900]!.withOpacity(0.3)]
              : [Colors.deepPurple[50]!, Colors.deepPurple[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.deepPurple[700]!.withOpacity(0.3) : Colors.deepPurple[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.alarm_rounded,
              color: isDark ? Colors.deepPurple[300] : Colors.deepPurple[700],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Pengingat tepat waktu membantu konsistensi nutrisi dan performa optimal',
              style: TextStyle(
                color: isDark ? Colors.deepPurple[100] : Colors.deepPurple[900],
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TrainingTimeSection extends StatelessWidget {
  final bool isDark;
  final TimeOfDay trainingTime;
  final VoidCallback onSelectTime;
  final VoidCallback onSchedule;

  const TrainingTimeSection({
    super.key,
    required this.isDark,
    required this.trainingTime,
    required this.onSelectTime,
    required this.onSchedule,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.access_time_rounded, color: Colors.blue, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                'Atur Jam Latihan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: onSelectTime,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800]!.withOpacity(0.5) : Colors.grey[50],
                border: Border.all(
                  color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.schedule_rounded, color: Colors.blue, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jam Latihan',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          trainingTime.format(context),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.edit_rounded,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ScheduleButton(onSchedule: onSchedule),
        ],
      ),
    );
  }
}

class ScheduleButton extends StatelessWidget {
  final VoidCallback onSchedule;

  const ScheduleButton({super.key, required this.onSchedule});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.blueAccent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onSchedule,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.alarm_add_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Jadwalkan Semua Pengingat',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RemindersHeader extends StatelessWidget {
  final bool isDark;
  final int activeCount;
  final int totalCount;

  const RemindersHeader({
    super.key,
    required this.isDark,
    required this.activeCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.notifications_rounded, color: Colors.orange, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daftar Pengingat',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                '$activeCount dari $totalCount aktif',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ReminderCard extends StatelessWidget {
  final Reminder reminder;
  final bool isDark;
  final Function(int) onToggle;

  const ReminderCard({
    super.key,
    required this.reminder,
    required this.isDark,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: reminder.isActive
              ? reminder.color.withOpacity(0.3)
              : (isDark ? Colors.grey[800]! : Colors.grey[200]!),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onToggle(reminder.id),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: reminder.isActive
                        ? reminder.color.withOpacity(0.1)
                        : (isDark ? Colors.grey[800] : Colors.grey[100]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    reminder.icon,
                    color: reminder.isActive
                        ? reminder.color
                        : (isDark ? Colors.grey[600] : Colors.grey[400]),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: reminder.isActive
                              ? (isDark ? Colors.white : Colors.black87)
                              : (isDark ? Colors.grey[500] : Colors.grey[400]),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        reminder.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: reminder.isActive
                              ? (isDark ? Colors.grey[400] : Colors.grey[600])
                              : (isDark ? Colors.grey[600] : Colors.grey[400]),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: reminder.isActive
                              ? reminder.color.withOpacity(0.1)
                              : (isDark ? Colors.grey[800] : Colors.grey[100]),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer_rounded,
                              size: 14,
                              color: reminder.isActive
                                  ? reminder.color
                                  : (isDark ? Colors.grey[600] : Colors.grey[400]),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              ReminderHelpers.getOffsetText(reminder.offset),
                              style: TextStyle(
                                color: reminder.isActive
                                    ? reminder.color
                                    : (isDark ? Colors.grey[600] : Colors.grey[400]),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Switch(
                  value: reminder.isActive,
                  onChanged: (_) => onToggle(reminder.id),
                  activeColor: reminder.color,
                  activeTrackColor: reminder.color.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TipsSection extends StatelessWidget {
  final bool isDark;

  const TipsSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.tips_and_updates_rounded, color: Colors.green, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                'Tips Pengaturan Pengingat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TipItem('Pilih jam latihan yang sesuai dengan jadwal rutin Anda', isDark),
          TipItem('Aktifkan hanya pengingat yang diperlukan', isDark),
          TipItem('Pre-workout meal: 1-2 jam sebelum latihan', isDark),
          TipItem('Post-workout nutrition: dalam 30-60 menit setelah latihan', isDark),
          TipItem('Notifikasi akan muncul sesuai jadwal yang ditetapkan', isDark),
          TipItem('Pastikan izin notifikasi diaktifkan pada pengaturan perangkat', isDark),
        ],
      ),
    );
  }
}

class TipItem extends StatelessWidget {
  final String text;
  final bool isDark;

  const TipItem(this.text, this.isDark, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              size: 16,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.grey[700],
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}