import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Ensure this matches your project name
import 'package:ayurveda_app/main.dart';

void main() {
  testWidgets('App load smoke test', (WidgetTester tester) async {
    // 1. Change MyApp() to AyurvedaApp()
    await tester.pumpWidget(const MyApp());

    // 2. Verify that the Home Screen text appears
    // This checks if the text from your Figma design is found on the screen
    expect(find.text('AYURVEDA AT TIPS'), findsOneWidget);

    // 3. Verify that the bottom navigation exists
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}