import 'package:flutter/material.dart';
import '../models/nutrition_data.dart';

class NutritionCard extends StatelessWidget {
  final NutritionData nutritionData;

  const NutritionCard({super.key, required this.nutritionData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow('Total Kalori Harian', 
                '${nutritionData.calories.round()} kcal'),
            _buildInfoRow('Protein', '${nutritionData.protein.round()} g'),
            _buildInfoRow('Karbohidrat', '${nutritionData.carbs.round()} g'),
            _buildInfoRow('Lemak', '${nutritionData.fat.round()} g'),
            const SizedBox(height: 8),
            _buildMacroBreakdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMacroBreakdown() {
    final totalCalories = nutritionData.calories;
    final proteinCalories = nutritionData.protein * 4;
    final carbsCalories = nutritionData.carbs * 4;
    final fatCalories = nutritionData.fat * 9;

    return Column(
      children: [
        _buildMacroBar('Protein', proteinCalories / totalCalories, Colors.blue),
        _buildMacroBar('Karbo', carbsCalories / totalCalories, Colors.green),
        _buildMacroBar('Lemak', fatCalories / totalCalories, Colors.orange),
      ],
    );
  }

  Widget _buildMacroBar(String label, double percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[300],
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(percentage * 100).round()}%',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}