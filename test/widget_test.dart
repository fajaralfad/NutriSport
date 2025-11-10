import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrisport/main.dart';

void main() {
  testWidgets('Home page loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NutriSportApp());

    // Verify that the home page loads with the correct title
    expect(find.text('NutriSport'), findsOneWidget);
    
    // Verify that feature cards are present
    expect(find.text('Kalkulator Gizi'), findsOneWidget);
    expect(find.text('Pemantauan Hidrasi'), findsOneWidget);
    expect(find.text('Rekomendasi Menu'), findsOneWidget);
    expect(find.text('Pengingat'), findsOneWidget);
    expect(find.text('Tracking Harian'), findsOneWidget);
  });

  testWidgets('Navigation to nutrition calculator', (WidgetTester tester) async {
    await tester.pumpWidget(const NutriSportApp());

    // Tap on the nutrition calculator card
    await tester.tap(find.text('Kalkulator Gizi'));
    await tester.pumpAndSettle();

    // Verify navigation to nutrition calculator page
    expect(find.text('Kalkulator Kebutuhan Gizi'), findsOneWidget);
  });

  testWidgets('Navigation to hydration tracker', (WidgetTester tester) async {
    await tester.pumpWidget(const NutriSportApp());

    // Tap on the hydration tracker card
    await tester.tap(find.text('Pemantauan Hidrasi'));
    await tester.pumpAndSettle();

    // Verify navigation to hydration tracker page
    expect(find.text('Pemantauan Hidrasi'), findsOneWidget);
  });

  testWidgets('Theme toggle button exists', (WidgetTester tester) async {
    await tester.pumpWidget(const NutriSportApp());

    // Verify that theme toggle button exists
    expect(find.byIcon(Icons.dark_mode), findsOneWidget);
  });

  testWidgets('App starts with light theme', (WidgetTester tester) async {
    await tester.pumpWidget(const NutriSportApp());

    // Verify initial theme (should be light)
    final appBar = tester.widget<AppBar>(find.byType(AppBar));
    expect(appBar.backgroundColor, Colors.blue);
  });
}