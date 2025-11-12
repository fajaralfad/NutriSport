import 'package:flutter/material.dart';
import 'package:nutrisport/utils/hydration_utils.dart';
import 'hydration_text_field.dart';
import 'hydration_dropdown.dart';

class HydrationInputSection extends StatelessWidget {
  final bool isDark;
  final HydrationController controller;
  final VoidCallback onCalculate;

  const HydrationInputSection({
    super.key,
    required this.isDark,
    required this.controller,
    required this.onCalculate,
  });

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
          SizedBox(height: isSmallScreen ? 16 : 20),
          HydrationTextField(
            controller: controller.weightController,
            label: 'Berat Badan (kg)',
            icon: Icons.monitor_weight_rounded,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          HydrationTextField(
            controller: controller.durationController,
            label: 'Durasi Latihan (jam)',
            icon: Icons.timer_rounded,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          HydrationDropdown(
            value: controller.intensity,
            label: 'Intensitas Latihan',
            icon: Icons.speed_rounded,
            items: const ['Ringan', 'Sedang', 'Berat'],
            onChanged: (value) {
              if (value != null) {
                controller.intensity = value;
              }
            },
          ),
          SizedBox(height: isSmallScreen ? 20 : 24),
          _buildCalculateButton(isSmallScreen),
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
            color: Colors.cyan.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.calculate_rounded,
            color: Colors.cyan,
            size: isSmallScreen ? 20 : 24,
          ),
        ),
        SizedBox(width: isSmallScreen ? 8 : 12),
        Expanded(
          child: Text(
            'Hitung Kebutuhan Hidrasi',
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

  Widget _buildCalculateButton(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      height: isSmallScreen ? 50 : 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.cyan, Colors.cyanAccent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onCalculate,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16 : 24,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calculate_rounded,
              color: Colors.white,
              size: isSmallScreen ? 18 : 20,
            ),
            SizedBox(width: isSmallScreen ? 6 : 8),
            Flexible(
              child: Text(
                'Hitung Kebutuhan Air',
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}