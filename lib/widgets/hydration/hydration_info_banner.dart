import 'package:flutter/material.dart';

class HydrationInfoBanner extends StatelessWidget {
  final bool isDark;

  const HydrationInfoBanner({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.cyan[700]!.withOpacity(0.3), Colors.cyan[900]!.withOpacity(0.3)]
              : [Colors.cyan[50]!, Colors.cyan[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.cyan[700]!.withOpacity(0.3) : Colors.cyan[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
            decoration: BoxDecoration(
              color: Colors.cyan.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.water_drop_rounded,
              color: isDark ? Colors.cyan[300] : Colors.cyan[700],
              size: isSmallScreen ? 20 : 24,
            ),
          ),
          SizedBox(width: isSmallScreen ? 12 : 16),
          Expanded(
            child: Text(
              'Hidrasi yang tepat meningkatkan performa olahraga hingga 20%',
              style: TextStyle(
                color: isDark ? Colors.cyan[100] : Colors.cyan[900],
                fontSize: isSmallScreen ? 12 : 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}