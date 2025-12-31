import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About App", style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const Spacer(),
            // App Logo
            Image.asset('assets/logo.png', height: 60),
            const SizedBox(height: 20),
            const Text(
              "Ayurveda At Tips",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Version 1.0.0",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            const Text(
              "Our mission is to bring ancient Ayurvedic wisdom to the modern world through accessible digital tools. We believe in personalized wellness for every unique body type.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
            ),
            const Spacer(),
            const Text(
              "© 2026 Ayurveda At Tips. All rights reserved.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}