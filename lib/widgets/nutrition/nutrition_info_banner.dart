import 'package:flutter/material.dart';

class NutritionInfoBanner extends StatelessWidget {
  const NutritionInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
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
            padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.info_rounded,
              color: isDark ? Colors.blue[300] : Colors.blue[700],
              size: isSmallScreen ? 20 : 24,
            ),
          ),
          SizedBox(width: isSmallScreen ? 12 : 16),
          Expanded(
            child: Text(
              'Isi data dengan lengkap untuk mendapatkan rekomendasi nutrisi yang akurat',
              style: TextStyle(
                color: isDark ? Colors.blue[100] : Colors.blue[900],
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