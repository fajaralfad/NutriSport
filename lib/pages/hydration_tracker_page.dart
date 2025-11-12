import 'package:flutter/material.dart';
import 'package:nutrisport/widgets/hydration/hydration_info_banner.dart';
import 'package:nutrisport/widgets/hydration/hydration_input_section.dart';
import 'package:nutrisport/widgets/hydration/hydration_progress_section.dart';
import 'package:nutrisport/widgets/hydration/hydration_tips_section.dart';
import 'package:nutrisport/utils/hydration_utils.dart';

class HydrationTrackerPage extends StatefulWidget {
  const HydrationTrackerPage({super.key});

  @override
  State<HydrationTrackerPage> createState() => _HydrationTrackerPageState();
}

class _HydrationTrackerPageState extends State<HydrationTrackerPage>
    with SingleTickerProviderStateMixin {
  late final HydrationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = HydrationController();
    _fadeAnimation = HydrationUtils.createFadeAnimation(this);
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
        title: const Text('Pemantauan Hidrasi'),
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
              HydrationInfoBanner(isDark: isDark),
              const SizedBox(height: 24),
              HydrationInputSection(
                isDark: isDark,
                controller: _controller,
                onCalculate: () => _handleCalculate(context),
              ),
              const SizedBox(height: 24),
              if (_controller.recommendedWater > 0) ...[
                HydrationProgressSection(
                  isDark: isDark,
                  controller: _controller,
                  onUpdate: _handleWaterUpdate,
                ),
                const SizedBox(height: 24),
              ],
              HydrationTipsSection(isDark: isDark),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCalculate(BuildContext context) {
    if (_controller.calculateHydrationNeeds()) {
      setState(() {});
      HydrationUtils.showSuccessMessage(context, 'Kebutuhan hidrasi berhasil dihitung!');
    } else {
      HydrationUtils.showWarningMessage(context, 'Masukkan berat badan dan durasi latihan');
    }
  }

  void _handleWaterUpdate(double newAmount) {
    setState(() {
      _controller.updateWaterConsumption(newAmount);
    });
  }
}