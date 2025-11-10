import 'package:flutter/material.dart';
import 'package:nutrisport/models/user_data.dart';
import 'package:nutrisport/services/database_service.dart';
import 'package:nutrisport/services/theme_service.dart';
import 'nutrition_calculator_page.dart';
import 'hydration_tracker_page.dart';
import 'meal_recommendation_page.dart';
import 'reminder_page.dart';
import 'progress_tracking_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserData? _userData;

  @override
  void didChangeDependencies() {
  super.didChangeDependencies();
  _loadUserData();
  }


  void _loadUserData() {
    setState(() {
      _userData = DatabaseService.getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NutriSport'),
        actions: [
          IconButton(
            icon: ValueListenableBuilder<bool>(
              valueListenable: ThemeService.isDarkMode,
              builder: (context, isDark, child) {
                return Icon(isDark ? Icons.light_mode : Icons.dark_mode);
              },
            ),
            onPressed: ThemeService.toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_userData != null) ...[
              _buildWelcomeSection(),
              const SizedBox(height: 20),
            ],
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    'Kalkulator Gizi',
                    Icons.calculate,
                    Colors.blue,
                    () => _navigateTo(NutritionCalculatorPage(
                      onDataSaved: _loadUserData,
                    )),
                  ),
                  _buildFeatureCard(
                    'Pemantauan Hidrasi',
                    Icons.water_drop,
                    Colors.lightBlue,
                    () => _navigateTo(const HydrationTrackerPage()),
                  ),
                  _buildFeatureCard(
                    'Rekomendasi Menu',
                    Icons.restaurant,
                    Colors.green,
                    () => _navigateTo(const MealRecommendationPage()),
                  ),
                  _buildFeatureCard(
                    'Pengingat',
                    Icons.notifications,
                    Colors.orange,
                    () => _navigateTo(const ReminderPage()),
                  ),
                  _buildFeatureCard(
                    'Tracking Harian',
                    Icons.analytics,
                    Colors.purple,
                    () => _navigateTo(const ProgressTrackingPage()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Halo, ${_userData!.name}!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Selamat datang di NutriSport',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}