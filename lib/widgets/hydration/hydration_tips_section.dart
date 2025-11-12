import 'package:flutter/material.dart';
import 'hydration_tip_item.dart';

class HydrationTipsSection extends StatelessWidget {
  final bool isDark;

  const HydrationTipsSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isSmallScreen),
          SizedBox(height: isSmallScreen ? 12 : 16),
          const HydrationTipItem('Minum 500ml air 2 jam sebelum latihan'),
          const HydrationTipItem('Minum 150-250ml setiap 15-20 menit selama latihan'),
          const HydrationTipItem('Minum 500ml setelah latihan untuk rehidrasi'),
          const HydrationTipItem('Perhatikan warna urine - harus jernih'),
          const HydrationTipItem('Hindari minuman berkafein berlebihan'),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isSmallScreen) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.lightbulb_rounded,
            color: Colors.blue,
            size: isSmallScreen ? 20 : 24,
          ),
        ),
        SizedBox(width: isSmallScreen ? 8 : 12),
        Expanded(
          child: Text(
            'Tips Hidrasi Sehat',
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}