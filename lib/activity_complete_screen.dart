import 'package:flutter/material.dart';
import 'app_theme.dart';

class ActivityCompleteScreen extends StatelessWidget {
  final String title;
  final int minutes;

  const ActivityCompleteScreen({
    super.key,
    required this.title,
    required this.minutes
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1E9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            children: [
              // Header
              Text(
                "$title Complete!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B4332)
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Well done — you invested in yourself today",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 40),

              // Summary Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xFFF1EDE4),
                            child: Icon(Icons.auto_awesome, color: Color(0xFFC9A227)),
                          ),
                          const SizedBox(height: 12),
                          Text("$minutes mins", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const Text("Total Time", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    const VerticalDivider(),
                    Expanded(
                      child: Column(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xFFF1EDE4),
                            child: Icon(Icons.emoji_events_outlined, color: Color(0xFFC9A227)),
                          ),
                          const SizedBox(height: 12),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock, size: 14, color: Colors.grey),
                              SizedBox(width: 4),
                              Text("Unlock streaks", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Text("Save your progress", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Action Button
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC9A227),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  "Start Another Activity",
                  style: TextStyle(color: Color(0xFF1B4332), fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),

              // Progress Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0xFFF1EDE4),
                          radius: 18,
                          child: Icon(Icons.auto_awesome, size: 18, color: Color(0xFFC9A227)),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Save Your Progress & Build Streaks",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Track your wellness journey, earn badges, and join our community of mindful families",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () {
                        // Logic to save progress to Firebase later
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        side: const BorderSide(color: Color(0xFFC9A227)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text("Save My Progress", style: TextStyle(color: Color(0xFFC9A227))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}