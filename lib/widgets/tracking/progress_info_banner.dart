import 'package:flutter/material.dart';

class ProgressInfoBanner extends StatelessWidget {
  final bool isDark;

  const ProgressInfoBanner({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.blue[700]!.withOpacity(0.3), Colors.blue[900]!.withOpacity(0.3)]
              : [Colors.blue[50]!, Colors.blue[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.blue[700]!.withOpacity(0.3) : Colors.blue[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.timeline_rounded,
              color: isDark ? Colors.blue[300] : Colors.blue[700],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Tracking konsisten membantu mencapai target kesehatan 3x lebih cepat',
              style: TextStyle(
                color: isDark ? Colors.blue[100] : Colors.blue[900],
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}