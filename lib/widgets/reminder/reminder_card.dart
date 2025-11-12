import 'package:flutter/material.dart';
import 'package:nutrisport/models/reminder_model.dart';
import 'package:nutrisport/utils/reminder_utils.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 360;
        
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
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
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
                        size: isSmallScreen ? 20 : 24,
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 12 : 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reminder.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 14 : 15,
                              color: reminder.isActive
                                  ? (isDark ? Colors.white : Colors.black87)
                                  : (isDark ? Colors.grey[500] : Colors.grey[400]),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            reminder.description,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 13,
                              color: reminder.isActive
                                  ? (isDark ? Colors.grey[400] : Colors.grey[600])
                                  : (isDark ? Colors.grey[600] : Colors.grey[400]),
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 8 : 10,
                              vertical: 4,
                            ),
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
                                  size: isSmallScreen ? 12 : 14,
                                  color: reminder.isActive
                                      ? reminder.color
                                      : (isDark ? Colors.grey[600] : Colors.grey[400]),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    ReminderUtils.getOffsetText(reminder.offset),
                                    style: TextStyle(
                                      color: reminder.isActive
                                          ? reminder.color
                                          : (isDark ? Colors.grey[600] : Colors.grey[400]),
                                      fontSize: isSmallScreen ? 10 : 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 8 : 12),
                    Transform.scale(
                      scale: isSmallScreen ? 0.85 : 1.0,
                      child: Switch(
                        value: reminder.isActive,
                        onChanged: (_) => onToggle(reminder.id),
                        activeColor: reminder.color,
                        activeTrackColor: reminder.color.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}