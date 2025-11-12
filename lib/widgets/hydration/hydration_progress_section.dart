import 'package:flutter/material.dart';
import 'package:nutrisport/utils/hydration_utils.dart';
import 'hydration_tracker.dart';

class HydrationProgressSection extends StatelessWidget {
  final bool isDark;
  final HydrationController controller;
  final Function(double) onUpdate;

  const HydrationProgressSection({
    super.key,
    required this.isDark,
    required this.controller,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(isSmallScreen),
        SizedBox(height: isSmallScreen ? 12 : 16),
        HydrationTracker(
          currentAmount: controller.consumedWater,
          targetAmount: controller.recommendedWater,
          onUpdate: onUpdate,
        ),
      ],
    );
  }

  Widget _buildHeader(bool isSmallScreen) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.local_drink_rounded,
            color: Colors.green,
            size: isSmallScreen ? 20 : 24,
          ),
        ),
        SizedBox(width: isSmallScreen ? 8 : 12),
        Expanded(
          child: Text(
            'Progress Hidrasi',
            style: TextStyle(
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}