import 'package:flutter/material.dart';
import '../services/hydration_service.dart';
import '../services/database_service.dart';
import '../utils/hydration_validator.dart';
import '../widgets/hydration/hydration_page_widgets.dart';
import '../widgets/hydration/hydration_tracker.dart';

class HydrationTrackerPage extends StatefulWidget {
  const HydrationTrackerPage({super.key});

  @override
  State<HydrationTrackerPage> createState() => _HydrationTrackerPageState();
}

class _HydrationTrackerPageState extends State<HydrationTrackerPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  
  String _intensity = 'Sedang';
  double _consumedWater = 0.0;
  double _recommendedWater = 0.0;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _loadData();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _weightController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _loadData() {
    final hydrationData = HydrationService.loadTodayData();
    
    if (hydrationData != null) {
      setState(() {
        _consumedWater = hydrationData.consumedWater;
        _recommendedWater = hydrationData.recommendedWater;
        _durationController.text = hydrationData.exerciseDuration.toString();
        _intensity = hydrationData.intensity;
        _weightController.text = hydrationData.weight.toString();
      });
    } else {
      _loadUserWeight();
    }
  }

  void _loadUserWeight() {
    final userData = DatabaseService.getUserData();
    if (userData != null) {
      _weightController.text = userData.weight.toString();
    }
  }

  void _calculateHydrationNeeds() {
    if (!HydrationValidator.validateInputs(
        _weightController.text, _durationController.text)) {
      _showValidationError();
      return;
    }

    final weight = HydrationValidator.parseDouble(_weightController.text);
    final duration = HydrationValidator.parseDouble(_durationController.text);

    if (weight == null || duration == null) {
      _showValidationError();
      return;
    }

    final recommended = HydrationService.calculateHydrationNeeds(
      weight: weight,
      duration: duration,
      intensity: _intensity,
    );

    setState(() {
      _recommendedWater = recommended;
    });

    final hydrationData = HydrationService.createHydrationData(
      weight: weight,
      duration: duration,
      intensity: _intensity,
      recommendedWater: _recommendedWater,
      consumedWater: _consumedWater,
    );

    HydrationService.saveHydrationData(hydrationData);
    _showSuccessMessage();
  }

  void _updateWaterConsumption(double newAmount) {
    setState(() {
      _consumedWater = newAmount;
    });

    final weight = HydrationValidator.parseDouble(_weightController.text);
    final duration = HydrationValidator.parseDouble(_durationController.text);

    if (weight != null && duration != null) {
      final hydrationData = HydrationService.createHydrationData(
        weight: weight,
        duration: duration,
        intensity: _intensity,
        recommendedWater: _recommendedWater,
        consumedWater: _consumedWater,
      );

      HydrationService.saveHydrationData(hydrationData);
    }
  }

  void _showValidationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.warning_rounded, color: Colors.white),
            SizedBox(width: 12),
            Text('Masukkan berat badan dan durasi latihan'),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showSuccessMessage() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Kebutuhan hidrasi berhasil dihitung!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
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
                weightController: _weightController,
                durationController: _durationController,
                intensity: _intensity,
                onIntensityChanged: (value) {
                  setState(() => _intensity = value!);
                },
                onCalculate: _calculateHydrationNeeds,
              ),
              const SizedBox(height: 24),
              if (_recommendedWater > 0) ...[
                HydrationProgressSection(
                  isDark: isDark,
                  currentAmount: _consumedWater,
                  targetAmount: _recommendedWater,
                  onUpdate: _updateWaterConsumption,
                ),
                const SizedBox(height: 16),
                HydrationTracker(
                  currentAmount: _consumedWater,
                  targetAmount: _recommendedWater,
                  onUpdate: _updateWaterConsumption,
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
}