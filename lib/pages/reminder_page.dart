import 'package:flutter/material.dart';
import 'package:nutrisport/widgets/reminder/reminder_info_banner.dart';
import 'package:nutrisport/widgets/reminder/training_time_section.dart';
import 'package:nutrisport/widgets/reminder/reminders_header.dart';
import 'package:nutrisport/widgets/reminder/reminder_card.dart';
import 'package:nutrisport/widgets/reminder/tips_section.dart';
import 'package:nutrisport/utils/reminder_utils.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage>
    with SingleTickerProviderStateMixin {
  late final ReminderController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = ReminderController();
    _fadeAnimation = ReminderUtils.createFadeAnimation(this);
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            onPressed: _handleTestNotification,
            tooltip: 'Test Notifikasi',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_off_rounded),
            onPressed: _handleCancelAllNotifications,
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
                trainingTime: _controller.trainingTime,
                onSelectTime: _handleSelectTrainingTime,
                onSchedule: _handleScheduleReminders,
              ),
              const SizedBox(height: 24),
              RemindersHeader(
                isDark: isDark,
                activeCount: _controller.activeRemindersCount,
                totalCount: _controller.reminders.length,
              ),
              const SizedBox(height: 16),
              ..._controller.reminders.map((reminder) => ReminderCard(
                    reminder: reminder,
                    isDark: isDark,
                    onToggle: _handleToggleReminder,
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

  void _handleSelectTrainingTime() async {
    final result = await _controller.selectTrainingTime(context);
    if (result != null) {
      setState(() {});
    }
  }

  void _handleScheduleReminders() async {
    final result = await _controller.scheduleReminders();
    if (!mounted) return;
    
    if (result != null) {
      ReminderUtils.showScheduleResultSnackbar(context, result, _controller.trainingTime);
    } else {
      ReminderUtils.showNoActiveRemindersSnackbar(context);
    }
  }

  void _handleToggleReminder(int id) {
    setState(() {
      _controller.toggleReminder(id);
    });
  }

  void _handleTestNotification() {
    _controller.testNotification();
    if (mounted) {
      ReminderUtils.showTestNotificationSnackbar(context);
    }
  }

  void _handleCancelAllNotifications() {
    _controller.cancelAllNotifications();
    if (mounted) {
      ReminderUtils.showCancelAllSnackbar(context);
    }
  }
}