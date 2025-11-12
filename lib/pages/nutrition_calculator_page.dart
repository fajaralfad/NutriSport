import 'package:flutter/material.dart';
import 'package:nutrisport/widgets/nutrition/nutrition_info_banner.dart';
import 'package:nutrisport/widgets/nutrition/nutrition_input_section.dart';
import 'package:nutrisport/widgets/nutrition/result_section.dart';
import 'package:nutrisport/utils/nutrition_utils.dart';

class NutritionCalculatorPage extends StatefulWidget {
  final VoidCallback onDataSaved;

  const NutritionCalculatorPage({super.key, required this.onDataSaved});

  @override
  State<NutritionCalculatorPage> createState() => _NutritionCalculatorPageState();
}

class _NutritionCalculatorPageState extends State<NutritionCalculatorPage>
    with SingleTickerProviderStateMixin {
  late final NutritionController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = NutritionController();
    _fadeAnimation = NutritionUtils.createFadeAnimation(this);
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        title: const Text('Kalkulator Gizi'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const NutritionInfoBanner(),
              const SizedBox(height: 24),
              NutritionInputSection(
                controller: _controller,
                onCalculate: () => _handleCalculate(context),
              ),
              if (_controller.calculatedData != null) ...[
                const SizedBox(height: 32),
                ResultSection(nutritionData: _controller.calculatedData!),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCalculate(BuildContext context) {
    if (_controller.calculateNutrition()) {
      setState(() {});
      NutritionUtils.showSuccessMessage(context, 'Data berhasil disimpan!');
      widget.onDataSaved();
    }
  }
}