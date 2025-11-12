import 'package:flutter/material.dart';
import 'package:nutrisport/utils/nutrition_utils.dart';
import 'package:nutrisport/widgets/nutrition/custom_text_field.dart';
import 'package:nutrisport/widgets/nutrition/custom_dropdown.dart';
import 'package:nutrisport/utils/form_validators.dart';

class PersonalInfoSection extends StatelessWidget {
  final NutritionController controller;

  const PersonalInfoSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {

    return _buildSectionCard(
      context,
      title: 'Informasi Pribadi',
      icon: Icons.person_rounded,
      children: [
        CustomTextField(
          controller: controller.nameController,
          label: 'Nama Lengkap',
          icon: Icons.badge_rounded,
          validator: FormValidators.validateName,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: controller.ageController,
                label: 'Usia',
                icon: Icons.cake_rounded,
                keyboardType: TextInputType.number,
                validator: FormValidators.validateAge,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomDropdown(
                value: controller.gender,
                label: 'Jenis Kelamin',
                icon: Icons.wc_rounded,
                items: const ['Pria', 'Wanita'],
                onChanged: (value) {
                  if (value != null) {
                    controller.gender = value;
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: controller.weightController,
                label: 'Berat (kg)',
                icon: Icons.monitor_weight_rounded,
                keyboardType: TextInputType.number,
                validator: FormValidators.validateWeight,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                controller: controller.heightController,
                label: 'Tinggi (cm)',
                icon: Icons.height_rounded,
                keyboardType: TextInputType.number,
                validator: FormValidators.validateHeight,
              ),
            ),
          ],
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