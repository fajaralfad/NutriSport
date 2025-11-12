import 'package:flutter/material.dart';
import 'package:nutrisport/utils/nutrition_utils.dart';
import 'package:nutrisport/widgets/nutrition/custom_dropdown.dart';

class SportsDataSection extends StatelessWidget {
  final NutritionController controller;

  const SportsDataSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {

    return _buildSectionCard(
      context,
      title: 'Data Olahraga',
      icon: Icons.fitness_center_rounded,
      children: [
        CustomDropdown(
          value: controller.sportType,
          label: 'Jenis Olahraga',
          icon: Icons.sports_gymnastics_rounded,
          items: const [
            'Strength/Muscle',
            'Endurance/Running',
            'Mixed/Team Sport',
          ],
          onChanged: (value) {
            if (value != null) {
              controller.sportType = value;
            }
          },
        ),
        const SizedBox(height: 16),
        CustomDropdown(
          value: controller.intensity,
          label: 'Intensitas Latihan',
          icon: Icons.speed_rounded,
          items: const [
            'Sedentary',
            'Ringan',
            'Sedang',
            'Berat',
            'Atlet Intens',
          ],
          onChanged: (value) {
            if (value != null) {
              controller.intensity = value;
            }
          },
        ),
        const SizedBox(height: 16),
        CustomDropdown(
          value: controller.goal,
          label: 'Tujuan',
          icon: Icons.flag_rounded,
          items: const [
            'Cutting',
            'Maintenance',
            'Bulking',
          ],
          onChanged: (value) {
            if (value != null) {
              controller.goal = value;
            }
          },
        ),
      ],
    );
  }

  Widget _buildSectionCard(BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.blue,
                  size: isSmallScreen ? 20 : 24,
                ),
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),
              Expanded(
                child: Text(
                  title,
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
          ),
          SizedBox(height: isSmallScreen ? 16 : 20),
          ...children,
        ],
      ),
    );
  }
}