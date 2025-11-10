import 'package:flutter/material.dart';
import 'package:nutrisport/models/hydration_data.dart';
import 'package:nutrisport/services/calculation_service.dart';
import 'package:nutrisport/services/database_service.dart';
import 'package:nutrisport/widgets/hydration_tracker.dart';

class HydrationTrackerPage extends StatefulWidget {
  const HydrationTrackerPage({super.key});

  @override
  State<HydrationTrackerPage> createState() => _HydrationTrackerPageState();
}

class _HydrationTrackerPageState extends State<HydrationTrackerPage> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  
  String _intensity = 'Sedang';
  double _consumedWater = 0.0;
  double _recommendedWater = 0.0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadTodayData();
  }

  void _loadUserData() {
    final userData = DatabaseService.getUserData();
    if (userData != null) {
      _weightController.text = userData.weight.toString();
    }
  }

  void _loadTodayData() {
    final hydrationData = DatabaseService.getTodayHydrationData();
    if (hydrationData != null) {
      setState(() {
        _consumedWater = hydrationData.consumedWater;
        _recommendedWater = hydrationData.recommendedWater;
        _durationController.text = hydrationData.exerciseDuration.toString();
        _intensity = hydrationData.intensity;
      });
    } else {
      // Jika tidak ada data hari ini, load dari user data
      _loadUserData();
    }
  }

  void _calculateHydrationNeeds() {
  if (_weightController.text.isEmpty || _durationController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Masukkan berat badan dan durasi latihan')),
    );
    return;
  }

  final weight = double.parse(_weightController.text);
  final duration = double.parse(_durationController.text);

  final recommended = CalculationService.calculateHydrationNeeds(
    weight: weight,
    exerciseDuration: duration,
    intensity: _intensity,
  );

  setState(() {
    _recommendedWater = recommended;
  });

  // Simpan langsung ke database
  final hydrationData = HydrationData(
    weight: weight,
    exerciseDuration: duration,
    intensity: _intensity,
    recommendedWater: _recommendedWater,
    consumedWater: _consumedWater,
    date: DateTime.now(),
  );

  DatabaseService.saveHydrationData(hydrationData);
  }


  void _updateWaterConsumption(double newAmount) {
  setState(() {
    _consumedWater = newAmount;
  });

  // Simpan data langsung ke database
  if (_weightController.text.isNotEmpty && _durationController.text.isNotEmpty) {
    final weight = double.parse(_weightController.text);
    final duration = double.parse(_durationController.text);
    
    final hydrationData = HydrationData(
      weight: weight,
      exerciseDuration: duration,
      intensity: _intensity,
      recommendedWater: _recommendedWater,
      consumedWater: _consumedWater,
      date: DateTime.now(),
    );

    DatabaseService.saveHydrationData(hydrationData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemantauan Hidrasi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Input Section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Hitung Kebutuhan Hidrasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _weightController,
                      decoration: const InputDecoration(
                        labelText: 'Berat Badan (kg)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _durationController,
                      decoration: const InputDecoration(
                        labelText: 'Durasi Latihan (jam)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _intensity,
                      decoration: const InputDecoration(
                        labelText: 'Intensitas Latihan',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        'Ringan',
                        'Sedang',
                        'Berat',
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
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _calculateHydrationNeeds,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Hitung Kebutuhan Air'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Hydration Tracker
            if (_recommendedWater > 0)
              HydrationTracker(
                currentAmount: _consumedWater,
                targetAmount: _recommendedWater,
                onUpdate: _updateWaterConsumption,
              ),

            // Hydration Tips
            const SizedBox(height: 24),
            _buildHydrationTips(),
          ],
        ),
      ),
    );
  }

  Widget _buildHydrationTips() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tips Hidrasi Sehat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildTipItem('Minum 500ml air 2 jam sebelum latihan'),
            _buildTipItem('Minum 150-250ml setiap 15-20 menit selama latihan'),
            _buildTipItem('Minum 500ml setelah latihan untuk rehidrasi'),
            _buildTipItem('Perhatikan warna urine - harus jernih'),
            _buildTipItem('Hindari minuman berkafein berlebihan'),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.water_drop, size: 16, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}