import 'package:flutter/material.dart';
import 'package:nutrisport/models/user_data.dart';
import 'package:nutrisport/models/nutrition_data.dart';
import 'package:nutrisport/services/calculation_service.dart';
import 'package:nutrisport/services/database_service.dart';
import 'package:nutrisport/widgets/nutrition_card.dart';

class NutritionCalculatorPage extends StatefulWidget {
  final VoidCallback onDataSaved;

  const NutritionCalculatorPage({super.key, required this.onDataSaved});

  @override
  State<NutritionCalculatorPage> createState() => _NutritionCalculatorPageState();
}

class _NutritionCalculatorPageState extends State<NutritionCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  
  String _gender = 'Pria';
  String _sportType = 'Strength/Muscle';
  String _intensity = 'Sedang';
  String _goal = 'Maintenance';
  
  NutritionData? _calculatedData;

  @override
  void initState() {
  super.initState();
  _loadExistingData();  
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

    // Load latest nutrition data
    final latestNutrition = DatabaseService.getLatestNutritionData();
    if (latestNutrition != null) {
      setState(() {
        _calculatedData = latestNutrition;
      });
    }
  }

  void _calculateNutrition() {
  if (_formKey.currentState!.validate()) {
    final weight = double.parse(_weightController.text);
    final height = double.parse(_heightController.text);
    final age = int.parse(_ageController.text);

    // Calculate BMR
    final bmr = CalculationService.calculateBMR(
      weight: weight,
      height: height,
      age: age,
      gender: _gender,
    );

    // Calculate TDEE
    final tdee = CalculationService.calculateTDEE(bmr, _intensity);

    // Calculate Macronutrients
    final macros = CalculationService.calculateMacronutrients(
      weight: weight,
      sportType: _sportType,
      goal: _goal,
    );

    // Adjust calories based on goal
    double adjustedCalories = tdee;
    if (_goal == 'Cutting') {
      adjustedCalories = tdee * 0.8; // 20% deficit
    } else if (_goal == 'Bulking') {
      adjustedCalories = tdee * 1.2; // 20% surplus
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
    });

    // Save user data
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data berhasil disimpan!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Kebutuhan Gizi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Personal Information Card
              _buildSectionCard(
                title: 'Informasi Pribadi',
                icon: Icons.person_outline,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukkan nama Anda';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _ageController,
                          decoration: const InputDecoration(
                            labelText: 'Usia',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan usia';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _gender,
                          decoration: const InputDecoration(
                            labelText: 'Jenis Kelamin',
                            border: OutlineInputBorder(),
                          ),
                          items: ['Pria', 'Wanita']
                              .map((gender) => DropdownMenuItem(
                                    value: gender,
                                    child: Text(gender),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _gender = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _weightController,
                          decoration: const InputDecoration(
                            labelText: 'Berat Badan (kg)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan berat badan';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _heightController,
                          decoration: const InputDecoration(
                            labelText: 'Tinggi Badan (cm)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan tinggi badan';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Sports Data Card
              _buildSectionCard(
                title: 'Data Olahraga',
                icon: Icons.fitness_center_outlined,
                children: [
                  DropdownButtonFormField<String>(
                    value: _sportType,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Olahraga',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      'Strength/Muscle',
                      'Endurance/Running',
                      'Mixed/Team Sport',
                    ]
                        .map((sport) => DropdownMenuItem(
                              value: sport,
                              child: Text(sport),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _sportType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _intensity,
                    decoration: const InputDecoration(
                      labelText: 'Intensitas Latihan',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      'Sedentary',
                      'Ringan',
                      'Sedang',
                      'Berat',
                      'Atlet Intens',
                    ]
                        .map((intensity) => DropdownMenuItem(
                              value: intensity,
                              child: Text(intensity),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _intensity = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _goal,
                    decoration: const InputDecoration(
                      labelText: 'Tujuan',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      'Cutting',
                      'Maintenance',
                      'Bulking',
                    ]
                        .map((goal) => DropdownMenuItem(
                              value: goal,
                              child: Text(goal),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _goal = value!;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _calculateNutrition,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Hitung Kebutuhan Gizi'),
              ),

              if (_calculatedData != null) ...[
                const SizedBox(height: 32),
                NutritionCard(nutritionData: _calculatedData!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}