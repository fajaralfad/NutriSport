import 'package:flutter/material.dart';

class ReminderInfoBanner extends StatelessWidget {
  final bool isDark;

  const ReminderInfoBanner({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(constraints.maxWidth < 360 ? 12 : 16),
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
                padding: EdgeInsets.all(constraints.maxWidth < 360 ? 8 : 12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.alarm_rounded,
                  color: isDark ? Colors.deepPurple[300] : Colors.deepPurple[700],
                  size: constraints.maxWidth < 360 ? 20 : 24,
                ),
              ),
              SizedBox(width: constraints.maxWidth < 360 ? 12 : 16),
              Expanded(
                child: Text(
                  'Pengingat tepat waktu membantu konsistensi nutrisi dan performa optimal',
                  style: TextStyle(
                    color: isDark ? Colors.deepPurple[100] : Colors.deepPurple[900],
                    fontSize: constraints.maxWidth < 360 ? 12 : 13,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}