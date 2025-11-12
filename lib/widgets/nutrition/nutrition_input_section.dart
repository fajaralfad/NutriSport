import 'package:flutter/material.dart';
import 'package:nutrisport/utils/nutrition_utils.dart';
import 'package:nutrisport/widgets/nutrition/personal_info_section.dart';
import 'package:nutrisport/widgets/nutrition/sports_data_section.dart';
import 'package:nutrisport/widgets/nutrition/calculate_button.dart';

class NutritionInputSection extends StatelessWidget {
  final NutritionController controller;
  final VoidCallback onCalculate;

  const NutritionInputSection({
    super.key,
    required this.controller,
    required this.onCalculate,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      // Ganti _formKey menjadi formKey (public)
      key: controller.formKey,
      child: Column(
        children: [
          PersonalInfoSection(controller: controller),
          const SizedBox(height: 20),
          SportsDataSection(controller: controller),
          const SizedBox(height: 32),
          CalculateButton(
            isCalculating: controller.isCalculating,
            onPressed: onCalculate,
          ),
        ],
      ),
    );
  }
}