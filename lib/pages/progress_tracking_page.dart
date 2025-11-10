import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nutrisport/models/daily_log.dart';
import 'package:nutrisport/services/database_service.dart';

class ProgressTrackingPage extends StatefulWidget {
  const ProgressTrackingPage({super.key});

  @override
  State<ProgressTrackingPage> createState() => _ProgressTrackingPageState();
}

class _ProgressTrackingPageState extends State<ProgressTrackingPage> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _waterController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  List<DailyLog> _dailyLogs = [];
  String _selectedChart = 'weight';

  @override
  void initState() {
  super.initState();
  _loadDailyLogs();
  _loadTodayData();
  }

  void _loadTodayData() {
  final todayLog = DatabaseService.getTodayDailyLog();
  if (todayLog != null) {
    setState(() {
      _weightController.text = todayLog.weight.toString();
      _waterController.text = todayLog.waterConsumed.toString();
      _caloriesController.text = todayLog.caloriesConsumed.toString();
      _notesController.text = todayLog.notes;
    });
  }
  } 

  void _loadDailyLogs() {
  setState(() {
    _dailyLogs = DatabaseService.getDailyLogsSorted();
  });
  }

 void _addDailyLog() {
  if (_weightController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Masukkan berat badan terlebih dahulu')),
    );
    return;
  }

  final log = DailyLog(
    date: DateTime.now(),
    weight: double.parse(_weightController.text),
    waterConsumed: _waterController.text.isEmpty ? 0.0 : double.parse(_waterController.text),
    caloriesConsumed: _caloriesController.text.isEmpty ? 0.0 : double.parse(_caloriesController.text),
    notes: _notesController.text,
  );

  DatabaseService.saveDailyLog(log);
  _loadDailyLogs();

  // Clear form
  _weightController.clear();
  _waterController.clear();
  _caloriesController.clear();
  _notesController.clear();

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Data harian berhasil disimpan!')),
  );
  }

  List<FlSpot> _getWeightSpots() {
    return _dailyLogs.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.weight,
      );
    }).toList();
  }

  List<FlSpot> _getWaterSpots() {
    return _dailyLogs.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.waterConsumed,
      );
    }).toList();
  }

  List<FlSpot> _getCalorieSpots() {
    return _dailyLogs.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.caloriesConsumed,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking Harian & Progress'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Input Form
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Catatan Harian',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _weightController,
                            decoration: const InputDecoration(
                              labelText: 'Berat (kg)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _waterController,
                            decoration: const InputDecoration(
                              labelText: 'Air (L)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _caloriesController,
                      decoration: const InputDecoration(
                        labelText: 'Kalori (kcal)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Catatan Tambahan',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addDailyLog,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Simpan Data Harian'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Chart Selection
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Grafik Progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment<String>(
                          value: 'weight',
                          label: Text('Berat Badan'),
                          icon: Icon(Icons.monitor_weight),
                        ),
                        ButtonSegment<String>(
                          value: 'water',
                          label: Text('Hidrasi'),
                          icon: Icon(Icons.water_drop),
                        ),
                        ButtonSegment<String>(
                          value: 'calories',
                          label: Text('Kalori'),
                          icon: Icon(Icons.local_fire_department),
                        ),
                      ],
                      selected: <String>{_selectedChart},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() {
                          _selectedChart = newSelection.first;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Chart
            if (_dailyLogs.isNotEmpty) ...[
              _buildProgressChart(),
              const SizedBox(height: 24),
            ],

            // Recent Logs
            _buildRecentLogs(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressChart() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              _getChartTitle(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _getChartData(),
                      isCurved: true,
                      color: _getChartColor(),
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        color: _getChartColor().withOpacity(0.1),
                      ),
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getChartTitle() {
    switch (_selectedChart) {
      case 'weight':
        return 'Progress Berat Badan (kg)';
      case 'water':
        return 'Konsumsi Air Harian (L)';
      case 'calories':
        return 'Konsumsi Kalori Harian (kcal)';
      default:
        return 'Progress';
    }
  }

  List<FlSpot> _getChartData() {
    switch (_selectedChart) {
      case 'weight':
        return _getWeightSpots();
      case 'water':
        return _getWaterSpots();
      case 'calories':
        return _getCalorieSpots();
      default:
        return _getWeightSpots();
    }
  }

  Color _getChartColor() {
    switch (_selectedChart) {
      case 'weight':
        return Colors.blue;
      case 'water':
        return Colors.lightBlue;
      case 'calories':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  Widget _buildRecentLogs() {
    if (_dailyLogs.isEmpty) {
      return const Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'Belum ada data tracking.\nMulai dengan mencatat data harian Anda.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final recentLogs = _dailyLogs.reversed.take(5).toList();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Catatan Terbaru',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...recentLogs.map((log) => _buildLogItem(log)),
          ],
        ),
      ),
    );
  }

  Widget _buildLogItem(DailyLog log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${log.date.day}/${log.date.month}/${log.date.year}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Berat: ${log.weight}kg | Air: ${log.waterConsumed}L',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              if (log.notes.isNotEmpty)
                Text(
                  'Catatan: ${log.notes}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
          const Spacer(),
          Text(
            '${log.caloriesConsumed.round()} kcal',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}