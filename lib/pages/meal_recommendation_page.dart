import 'package:flutter/material.dart';
import 'package:nutrisport/models/nutrition_data.dart';
import 'package:nutrisport/services/database_service.dart';

class MealRecommendationPage extends StatefulWidget {
  const MealRecommendationPage({super.key});

  @override
  State<MealRecommendationPage> createState() => _MealRecommendationPageState();
}

class _MealRecommendationPageState extends State<MealRecommendationPage> {
  String _sportType = 'Strength/Muscle';
  String _trainingPhase = 'Pre-workout';
  NutritionData? _latestNutritionData;

  final Map<String, List<Meal>> _mealDatabase = {
    'Pre-workout': [
      Meal(
        name: 'Oatmeal dengan Buah',
        description: 'Oatmeal + Pisang + Madu + Yogurt',
        calories: 350,
        protein: 15,
        carbs: 60,
        fat: 5,
        preparationTime: 10,
        ingredients: ['Oatmeal 50g', 'Pisang 1 buah', 'Yogurt 100g', 'Madu 1 sdm'],
      ),
      Meal(
        name: 'Roti Gandum dengan Telur',
        description: 'Roti gandum + Telur rebus + Alpukat',
        calories: 400,
        protein: 20,
        carbs: 45,
        fat: 15,
        preparationTime: 15,
        ingredients: ['Roti gandum 2 slice', 'Telur 2 butir', 'Alpukat 1/2 buah'],
      ),
      Meal(
        name: 'Smoothie Protein',
        description: 'Whey protein + Pisang + Oat + Susu almond',
        calories: 320,
        protein: 25,
        carbs: 40,
        fat: 6,
        preparationTime: 5,
        ingredients: ['Whey protein 1 scoop', 'Pisang 1 buah', 'Oat 30g', 'Susu almond 300ml'],
      ),
    ],
    'Intra-workout': [
      Meal(
        name: 'Minuman Isotonik',
        description: 'Elektrolit + Karbohidrat sederhana',
        calories: 120,
        protein: 0,
        carbs: 30,
        fat: 0,
        preparationTime: 2,
        ingredients: ['Minuman isotonik 500ml'],
      ),
      Meal(
        name: 'Pisang',
        description: 'Buah pisang matang',
        calories: 105,
        protein: 1,
        carbs: 27,
        fat: 0,
        preparationTime: 1,
        ingredients: ['Pisang 1 buah'],
      ),
      Meal(
        name: 'Energy Gel',
        description: 'Gel energi cepat serap',
        calories: 100,
        protein: 0,
        carbs: 25,
        fat: 0,
        preparationTime: 1,
        ingredients: ['Energy gel 1 pack'],
      ),
    ],
    'Post-workout': [
      Meal(
        name: 'Nasi + Ayam + Sayur',
        description: 'Nasi merah + Dada ayam panggang + Brokoli',
        calories: 450,
        protein: 35,
        carbs: 50,
        fat: 10,
        preparationTime: 20,
        ingredients: ['Nasi merah 100g', 'Dada ayam 150g', 'Brokoli 100g'],
      ),
      Meal(
        name: 'Protein Shake + Kentang',
        description: 'Whey protein + Kentang rebus + Madu',
        calories: 380,
        protein: 30,
        carbs: 45,
        fat: 5,
        preparationTime: 10,
        ingredients: ['Whey protein 1 scoop', 'Kentang 150g', 'Madu 1 sdm'],
      ),
      Meal(
        name: 'Ikan Salmon + Quinoa',
        description: 'Salmon grill + Quinoa + Asparagus',
        calories: 500,
        protein: 40,
        carbs: 35,
        fat: 20,
        preparationTime: 25,
        ingredients: ['Salmon 150g', 'Quinoa 80g', 'Asparagus 100g'],
      ),
    ],
  };

  final Map<String, String> _phaseDescriptions = {
    'Pre-workout': 'Makan 1-2 jam sebelum latihan. Fokus pada karbohidrat kompleks dan protein ringan untuk energi berkelanjutan.',
    'Intra-workout': 'Konsumsi selama latihan jika durasi > 1.5 jam. Fokus pada karbohidrat cepat serap dan elektrolit.',
    'Post-workout': 'Makan dalam 30-60 menit setelah latihan. Kombinasi protein tinggi dan karbohidrat untuk pemulihan.',
  };

  @override
  void initState() {
    super.initState();
    _loadNutritionData();
  }

  void _loadNutritionData() {
    final nutritionHistory = DatabaseService.getNutritionHistory();
    if (nutritionHistory.isNotEmpty) {
      setState(() {
        _latestNutritionData = nutritionHistory.last;
      });
    }
  }

  List<Meal> get _filteredMeals {
    return _mealDatabase[_trainingPhase] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekomendasi Menu Makanan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sport Type Selection
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jenis Olahraga',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _sportType,
                      isExpanded: true,
                      decoration: const InputDecoration(
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
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Training Phase Selection
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fase Latihan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _trainingPhase,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        'Pre-workout',
                        'Intra-workout',
                        'Post-workout',
                      ]
                          .map((phase) => DropdownMenuItem(
                                value: phase,
                                child: Text(phase),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _trainingPhase = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _phaseDescriptions[_trainingPhase] ?? '',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Nutrition Info (if available)
            if (_latestNutritionData != null) ...[
              _buildNutritionInfo(),
              const SizedBox(height: 16),
            ],

            // Meal Recommendations
            _buildMealRecommendations(),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionInfo() {
    return Card(
      elevation: 4,
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kebutuhan Harian Anda',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Kalori: ${_latestNutritionData!.calories.round()} kcal'),
            Text('Protein: ${_latestNutritionData!.protein.round()} g'),
            Text('Karbohidrat: ${_latestNutritionData!.carbs.round()} g'),
            Text('Lemak: ${_latestNutritionData!.fat.round()} g'),
          ],
        ),
      ),
    );
  }

  Widget _buildMealRecommendations() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Rekomendasi Menu $_trainingPhase',  
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 16),
      ..._filteredMeals.map((meal) => _buildMealCard(meal)),
    ],
  );
}

  Widget _buildMealCard(Meal meal) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    meal.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text('${meal.calories} kcal'),
                  backgroundColor: Colors.blue[100],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              meal.description,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            // Macronutrients
            Row(
              children: [
                _buildMacroChip('Protein', '${meal.protein}g', Colors.green),
                const SizedBox(width: 8),
                _buildMacroChip('Karbo', '${meal.carbs}g', Colors.orange),
                const SizedBox(width: 8),
                _buildMacroChip('Lemak', '${meal.fat}g', Colors.blue),
                const SizedBox(width: 8),
                _buildMacroChip('Waktu', '${meal.preparationTime}m', Colors.purple),
              ],
            ),
            const SizedBox(height: 12),
            // Ingredients
            const Text(
              'Bahan-bahan:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: meal.ingredients
                  .map((ingredient) => Chip(
                        label: Text(ingredient),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroChip(String label, String value, Color color) {
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: const TextStyle(fontSize: 12),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}

class Meal {
  final String name;
  final String description;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int preparationTime;
  final List<String> ingredients;

  Meal({
    required this.name,
    required this.description,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.preparationTime,
    required this.ingredients,
  });
}