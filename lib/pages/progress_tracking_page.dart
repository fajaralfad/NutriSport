import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nutrisport/models/daily_log.dart';
import 'package:nutrisport/services/database_service.dart';
import 'package:nutrisport/widgets/tracking/progress_widgets.dart';

class ProgressTrackingPage extends StatefulWidget {
  const ProgressTrackingPage({super.key});

  @override
  State<ProgressTrackingPage> createState() => _ProgressTrackingPageState();
}

class _ProgressTrackingPageState extends State<ProgressTrackingPage>
    with SingleTickerProviderStateMixin {
  // Controllers
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _waterController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // State
  List<DailyLog> _dailyLogs = [];
  String _selectedChart = 'weight';

  // Animation
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _loadData();
  }

  @override
  void dispose() {
    _disposeControllers();
    _animationController.dispose();
    super.dispose();
  }

  // Initialization Methods
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

  void _loadData() {
    _loadTodayData();
    _loadDailyLogs();
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

  void _disposeControllers() {
    _weightController.dispose();
    _waterController.dispose();
    _caloriesController.dispose();
    _notesController.dispose();
  }

  // Data Management Methods
  void _addDailyLog() {
    if (!_validateInput()) return;

    final log = _createDailyLog();
    DatabaseService.saveDailyLog(log);
    _loadDailyLogs();
    _clearForm();
    _showSuccessMessage();
  }

  bool _validateInput() {
    if (_weightController.text.isEmpty) {
      _showWarningMessage('Masukkan berat badan terlebih dahulu');
      return false;
    }
    return true;
  }

  DailyLog _createDailyLog() {
    return DailyLog(
      date: DateTime.now(),
      weight: double.parse(_weightController.text),
      waterConsumed: _waterController.text.isEmpty 
          ? 0.0 
          : double.parse(_waterController.text),
      caloriesConsumed: _caloriesController.text.isEmpty 
          ? 0.0 
          : double.parse(_caloriesController.text),
      notes: _notesController.text,
    );
  }

  void _clearForm() {
    _weightController.clear();
    _waterController.clear();
    _caloriesController.clear();
    _notesController.clear();
  }

  // Chart Data Methods
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

  List<FlSpot> _getWeightSpots() {
    return _dailyLogs.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.weight);
    }).toList();
  }

  List<FlSpot> _getWaterSpots() {
    return _dailyLogs.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.waterConsumed);
    }).toList();
  }

  List<FlSpot> _getCalorieSpots() {
    return _dailyLogs.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.caloriesConsumed);
    }).toList();
  }

  // UI Feedback Methods
  void _showSuccessMessage() {
    _showSnackBar(
      message: 'Data harian berhasil disimpan!',
      icon: Icons.check_circle,
      color: Colors.green,
    );
  }

  void _showWarningMessage(String message) {
    _showSnackBar(
      message: message,
      icon: Icons.warning_rounded,
      color: Colors.orange,
    );
  }

  void _showSnackBar({
    required String message,
    required IconData icon,
    required Color color,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: color,
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
        title: const Text('Tracking & Progress'),
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
              ProgressInfoBanner(isDark: isDark),
              const SizedBox(height: 24),
              ProgressInputSection(
                isDark: isDark,
                weightController: _weightController,
                waterController: _waterController,
                caloriesController: _caloriesController,
                notesController: _notesController,
                onSave: _addDailyLog,
              ),
              const SizedBox(height: 24),
              ChartSelectionSection(
                isDark: isDark,
                selectedChart: _selectedChart,
                onChartChanged: (newChart) {
                  setState(() => _selectedChart = newChart);
                },
              ),
              const SizedBox(height: 24),
              if (_dailyLogs.isNotEmpty) ...[
                ProgressChart(
                  isDark: isDark,
                  chartType: _selectedChart,
                  data: _getChartData(),
                ),
                const SizedBox(height: 24),
              ],
              RecentLogsSection(
                isDark: isDark,
                dailyLogs: _dailyLogs,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}