import 'package:flutter/material.dart';

class QuizResultScreen extends StatelessWidget {
  final String finalDosha;
  final String description;
  final int vata;
  final int pitta;
  final int kapha;

  const QuizResultScreen({
    super.key,
    required this.finalDosha,
    required this.description,
    required this.vata,
    required this.pitta,
    required this.kapha,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1E9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            children: [
              const Text(
                "ANALYSIS COMPLETE",
                style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, color: Colors.brown),
              ),
              const SizedBox(height: 20),

              // Dosha Title
              Text(
                finalDosha,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF1B4332)),
              ),
              const SizedBox(height: 10),

              // Description Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 30),

              // Score Breakdown Table
              _buildScoreRow("Vata", vata, const Color(0xFF8ECAE6)),
              _buildScoreRow("Pitta", pitta, const Color(0xFFFB8500)),
              _buildScoreRow("Kapha", kapha, const Color(0xFF2D6A4F)),

              const Spacer(),

              // Action Button
              ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009460),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Return to Dashboard", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreRow(String label, int score, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
            child: LinearProgressIndicator(
              value: score / 30,
              backgroundColor: Colors.grey[200],
              color: color,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(width: 10),
          Text("$score"),
        ],
      ),
    );
  }
}