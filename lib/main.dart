import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nutrisport/pages/home_page.dart';
import 'package:nutrisport/services/theme_service.dart';
import 'package:nutrisport/services/notification_service.dart';
import 'package:nutrisport/services/database_service.dart'; // TAMBAHKAN INI
import 'package:nutrisport/models/user_data.dart';
import 'package:nutrisport/models/nutrition_data.dart';
import 'package:nutrisport/models/hydration_data.dart';
import 'package:nutrisport/models/daily_log.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive dengan flutter
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(UserDataAdapter());
  Hive.registerAdapter(NutritionDataAdapter());
  Hive.registerAdapter(HydrationDataAdapter());
  Hive.registerAdapter(DailyLogAdapter());
  
  // Open all boxes
  await Hive.openBox<UserData>('user_data');
  await Hive.openBox<NutritionData>('nutrition_data');
  await Hive.openBox<HydrationData>('hydration_data');
  await Hive.openBox<DailyLog>('daily_logs');
  
  await DatabaseService.init();
  
  // Initialize notifications
  await NotificationService.init();
  
  runApp(const NutriSportApp());
}

class NutriSportApp extends StatelessWidget {
  const NutriSportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeService.isDarkMode,
      builder: (context, isDark, child) {
        return MaterialApp(
          title: 'NutriSport',
          theme: ThemeService.lightTheme,
          darkTheme: ThemeService.darkTheme,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: const HomePage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}