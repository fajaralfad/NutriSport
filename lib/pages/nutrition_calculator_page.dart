import 'package:flutter/material.dart';
import 'package:nutrisport/models/user_data.dart';
import 'package:nutrisport/models/nutrition_data.dart';
import 'package:nutrisport/services/calculation_service.dart';
import 'package:nutrisport/services/database_service.dart';
import 'package:nutrisport/widgets/nutrition/nutrition_page_widgets.dart';

class NutritionCalculatorPage extends StatefulWidget {
  final VoidCallback onDataSaved;

  const NutritionCalculatorPage({super.key, required this.onDataSaved});

  @override
  State<NutritionCalculatorPage> createState() => _NutritionCalculatorPageState();
}

class _NutritionCalculatorPageState extends State<NutritionCalculatorPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  
  // State variables
  String _gender = 'Pria';
  String _sportType = 'Strength/Muscle';
  String _intensity = 'Sedang';
  String _goal = 'Maintenance';
  
  NutritionData? _calculatedData;
  bool _isCalculating = false;
  
  // Animation
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _loadExistingData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _initializeAnimation() {
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

  void _loadExistingData() {
    final userData = DatabaseService.getUserData();
    if (userData != null) {
      setState(() {
        _nameController.text = userData.name;
        _ageController.text = userData.age.toString();
        _weightController.text = userData.weight.toString();
        _heightController.text = userData.height.toString();
        _gender = userData.gender;
        _sportType = userData.sportType;
        _intensity = userData.intensity;
        _goal = userData.goal;
      });
    }

    final latestNutrition = DatabaseService.getLatestNutritionData();
    if (latestNutrition != null) {
      setState(() {
        _calculatedData = latestNutrition;
      });
    }
  }

  Future<void> _calculateNutrition() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isCalculating = true);
    await Future.delayed(const Duration(milliseconds: 500));

    final weight = double.parse(_weightController.text);
    final height = double.parse(_heightController.text);
    final age = int.parse(_ageController.text);

    final bmr = CalculationService.calculateBMR(
      weight: weight,
      height: height,
      age: age,
      gender: _gender,
    );

    final tdee = CalculationService.calculateTDEE(bmr, _intensity);
    final macros = CalculationService.calculateMacronutrients(
      weight: weight,
      sportType: _sportType,
      goal: _goal,
    );

    double adjustedCalories = tdee;
    if (_goal == 'Cutting') {
      adjustedCalories = tdee * 0.8;
    } else if (_goal == 'Bulking') {
      adjustedCalories = tdee * 1.2;
    }

    setState(() {
      _calculatedData = NutritionData(
        bmr: bmr,
        tdee: tdee,
        protein: macros['protein']!,
        carbs: macros['carbs']!,
        fat: macros['fat']!,
        calories: adjustedCalories,
        calculatedAt: DateTime.now(),
      );
      _isCalculating = false;
    });

    _saveData(weight, height, age);
    _showSuccessSnackbar();
  }

  void _saveData(double weight, double height, int age) {
    final userData = UserData(
      name: _nameController.text,
      age: age,
      gender: _gender,
      weight: weight,
      height: height,
      sportType: _sportType,
      intensity: _intensity,
      goal: _goal,
    );

    DatabaseService.saveUserData(userData);
    DatabaseService.saveNutritionData(_calculatedData!);
    widget.onDataSaved();
  }

  void _showSuccessSnackbar() {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Data berhasil disimpan!'),
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
        title: const Text('Kalkulator Gizi'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const InfoBanner(),
                const SizedBox(height: 24),
                _buildPersonalInfoSection(),
                const SizedBox(height: 20),
                _buildSportsDataSection(),
                const SizedBox(height: 32),
                CalculateButton(
                  isCalculating: _isCalculating,
                  onPressed: _calculateNutrition,
                ),
                if (_calculatedData != null) ...[
                  const SizedBox(height: 32),
                  ResultSection(nutritionData: _calculatedData!),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return SectionCard(
      title: 'Informasi Pribadi',
      icon: Icons.person_rounded,
      children: [
        CustomTextField(
          controller: _nameController,
          label: 'Nama Lengkap',
          icon: Icons.badge_rounded,
          validator: FormValidators.validateName,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _ageController,
                label: 'Usia',
                icon: Icons.cake_rounded,
                keyboardType: TextInputType.number,
                validator: FormValidators.validateAge,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomDropdown(
                value: _gender,
                label: 'Jenis Kelamin',
                icon: Icons.wc_rounded,
                items: const ['Pria', 'Wanita'],
                onChanged: (value) => setState(() => _gender = value!),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _weightController,
                label: 'Berat (kg)',
                icon: Icons.monitor_weight_rounded,
                keyboardType: TextInputType.number,
                validator: FormValidators.validateWeight,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                controller: _heightController,
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

  Widget _buildSportsDataSection() {
    return SectionCard(
      title: 'Data Olahraga',
      icon: Icons.fitness_center_rounded,
      children: [
        CustomDropdown(
          value: _sportType,
          label: 'Jenis Olahraga',
          icon: Icons.sports_gymnastics_rounded,
          items: const [
            'Strength/Muscle',
            'Endurance/Running',
            'Mixed/Team Sport',
          ],
          onChanged: (value) => setState(() => _sportType = value!),
        ),
        const SizedBox(height: 16),
        CustomDropdown(
          value: _intensity,
          label: 'Intensitas Latihan',
          icon: Icons.speed_rounded,
          items: const [
            'Sedentary',
            'Ringan',
            'Sedang',
            'Berat',
            'Atlet Intens',
          ],
          onChanged: (value) => setState(() => _intensity = value!),
        ),
        const SizedBox(height: 16),
        CustomDropdown(
          value: _goal,
          label: 'Tujuan',
          icon: Icons.flag_rounded,
          items: const [
            'Cutting',
            'Maintenance',
            'Bulking',
          ],
          onChanged: (value) => setState(() => _goal = value!),
        ),
      ],
    );
  }
}