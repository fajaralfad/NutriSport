import 'package:flutter/material.dart';
import 'schedule_button.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 360;
        final isMediumScreen = constraints.maxWidth < 400;
        
        return Container(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
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
                    padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.access_time_rounded,
                      color: Colors.blue,
                      size: isSmallScreen ? 20 : 24,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 8 : 12),
                  Flexible(
                    child: Text(
                      'Atur Jam Latihan',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 16 : 20),
              InkWell(
                onTap: onSelectTime,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
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
                        padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.schedule_rounded,
                          color: Colors.blue,
                          size: isSmallScreen ? 24 : 28,
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 12 : 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jam Latihan',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 13,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                trainingTime.format(context),
                                style: TextStyle(
                                  fontSize: isMediumScreen ? 20 : 24,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.edit_rounded,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        size: isSmallScreen ? 20 : 24,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: isSmallScreen ? 16 : 20),
              ScheduleButton(onSchedule: onSchedule),
            ],
          ),
        );
      },
    );
  }
}