import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_data.dart';
import '../models/nutrition_data.dart';
import '../models/hydration_data.dart';
import '../models/daily_log.dart';

class DatabaseService {
  static late Box<UserData> _userDataBox;
  static late Box<NutritionData> _nutritionDataBox;
  static late Box<HydrationData> _hydrationDataBox;
  static late Box<DailyLog> _dailyLogsBox;

  static Future<void> init() async {
    _userDataBox = Hive.box<UserData>('user_data');
    _nutritionDataBox = Hive.box<NutritionData>('nutrition_data');
    _hydrationDataBox = Hive.box<HydrationData>('hydration_data');
    _dailyLogsBox = Hive.box<DailyLog>('daily_logs');
  }

  // User Data methods
  static Future<void> saveUserData(UserData data) async {
    await _userDataBox.put('current_user', data);
  }

  static UserData? getUserData() {
    return _userDataBox.get('current_user');
  }

  // Nutrition Data methods
  static Future<void> saveNutritionData(NutritionData data) async {
    await _nutritionDataBox.add(data);
  }

  static List<NutritionData> getNutritionHistory() {
    return _nutritionDataBox.values.toList();
  }

  static NutritionData? getLatestNutritionData() {
    final history = getNutritionHistory();
    if (history.isEmpty) return null;
    history.sort((a, b) => b.calculatedAt.compareTo(a.calculatedAt));
    return history.first;
  }

  // Hydration Data methods
  static Future<void> saveHydrationData(HydrationData data) async {
    final dateKey = _formatDateKey(data.date);
    await _hydrationDataBox.put(dateKey, data);
  }

  static HydrationData? getHydrationData(DateTime date) {
    final dateKey = _formatDateKey(date);
    return _hydrationDataBox.get(dateKey);
  }

  static HydrationData? getTodayHydrationData() {
    return getHydrationData(DateTime.now());
  }

  static List<HydrationData> getAllHydrationData() {
    return _hydrationDataBox.values.toList();
  }

  // Daily Log methods
  static Future<void> saveDailyLog(DailyLog log) async {
    final dateKey = _formatDateKey(log.date);
    await _dailyLogsBox.put(dateKey, log);
  }

  static DailyLog? getDailyLog(DateTime date) {
    final dateKey = _formatDateKey(date);
    return _dailyLogsBox.get(dateKey);
  }

  static DailyLog? getTodayDailyLog() {
    return getDailyLog(DateTime.now());
  }

  static List<DailyLog> getDailyLogs() {
    return _dailyLogsBox.values.toList();
  }

  static List<DailyLog> getDailyLogsSorted() {
    final logs = getDailyLogs();
    logs.sort((a, b) => b.date.compareTo(a.date));
    return logs;
  }

  // Helper method untuk format key
  static String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Clear all data (for testing)
  static Future<void> clearAllData() async {
    await _userDataBox.clear();
    await _nutritionDataBox.clear();
    await _hydrationDataBox.clear();
    await _dailyLogsBox.clear();
  }
}