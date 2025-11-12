import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nutrisport/models/daily_log.dart';
import 'package:nutrisport/services/database_service.dart';

class ProgressUtils {
  static Animation<double> createFadeAnimation(TickerProvider vsync) {
    final controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: vsync,
    );
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
    controller.forward();
    return animation;
  }

  static void showSuccessMessage(BuildContext context, String message) {
    _showSnackBar(context, message, Icons.check_circle, Colors.green);
  }

  static void showWarningMessage(BuildContext context, String message) {
    _showSnackBar(context, message, Icons.warning_rounded, Colors.orange);
  }

  static void _showSnackBar(
    BuildContext context,
    String message,
    IconData icon,
    Color color,
  ) {
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

  static Color getChartColor(String chartType) {
    switch (chartType) {
      case 'weight':
        return Colors.blue;
      case 'water':
        return Colors.cyan;
      case 'calories':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  static IconData getChartIcon(String chartType) {
    switch (chartType) {
      case 'weight':
        return Icons.monitor_weight_rounded;
      case 'water':
        return Icons.water_drop_rounded;
      case 'calories':
        return Icons.local_fire_department_rounded;
      default:
        return Icons.bar_chart_rounded;
    }
  }

  static String getChartTitle(String chartType) {
    switch (chartType) {
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
}

class ProgressController {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController waterController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  List<DailyLog> dailyLogs = [];
  String selectedChart = 'weight';

  bool get hasData => dailyLogs.isNotEmpty;

  void initialize() {
    _loadTodayData();
    _loadDailyLogs();
  }

  void _loadTodayData() {
    final todayLog = DatabaseService.getTodayDailyLog();
    if (todayLog != null) {
      weightController.text = todayLog.weight.toStringAsFixed(1);
      waterController.text = todayLog.waterConsumed.toStringAsFixed(1);
      caloriesController.text = todayLog.caloriesConsumed.toStringAsFixed(0);
      notesController.text = todayLog.notes;
    }
  }

  void _loadDailyLogs() {
    dailyLogs = DatabaseService.getDailyLogsSorted();
  }

  bool saveLog() {
    if (!_validateInput()) return false;

    final log = _createDailyLog();
    DatabaseService.saveDailyLog(log);
    _loadDailyLogs();
    _clearForm();
    return true;
  }

  bool _validateInput() {
    return weightController.text.isNotEmpty;
  }

  DailyLog _createDailyLog() {
    return DailyLog(
      date: DateTime.now(),
      weight: double.parse(weightController.text),
      waterConsumed: waterController.text.isEmpty 
          ? 0.0 
          : double.parse(waterController.text),
      caloriesConsumed: caloriesController.text.isEmpty 
          ? 0.0 
          : double.parse(caloriesController.text),
      notes: notesController.text,
    );
  }

  void _clearForm() {
    weightController.clear();
    waterController.clear();
    caloriesController.clear();
    notesController.clear();
  }

  List<FlSpot> getChartData() {
  switch (selectedChart) {
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
  final sortedLogs = List<DailyLog>.from(dailyLogs)
    ..sort((a, b) => a.date.compareTo(b.date));
  
  return sortedLogs.asMap().entries.map((entry) {
    return FlSpot(entry.key.toDouble(), entry.value.weight);
  }).toList();
}

List<FlSpot> _getWaterSpots() {
  final sortedLogs = List<DailyLog>.from(dailyLogs)
    ..sort((a, b) => a.date.compareTo(b.date));
  
  return sortedLogs.asMap().entries.map((entry) {
    final waterInLiters = entry.value.waterConsumed / 1000;
    return FlSpot(entry.key.toDouble(), waterInLiters);
  }).toList();
}

List<FlSpot> _getCalorieSpots() {
  final sortedLogs = List<DailyLog>.from(dailyLogs)
    ..sort((a, b) => a.date.compareTo(b.date));
  
  return sortedLogs.asMap().entries.map((entry) {
    return FlSpot(entry.key.toDouble(), entry.value.caloriesConsumed);
  }).toList();
}

  void dispose() {
    weightController.dispose();
    waterController.dispose();
    caloriesController.dispose();
    notesController.dispose();
  }
}