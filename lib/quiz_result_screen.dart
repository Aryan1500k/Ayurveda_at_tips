import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizResultScreen extends StatefulWidget {
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
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  @override
  void initState() {
    super.initState();
    _saveResultsToFirebase();
  }

  Future<void> _saveResultsToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'dominantDosha': widget.finalDosha,
          'scores': {
            'vata': widget.vata,
            'pitta': widget.pitta,
            'kapha': widget.kapha,
          },
          'lastQuizDate': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint("Firestore Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1E9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text("ANALYSIS COMPLETE", style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, color: Colors.brown)),
              const SizedBox(height: 20),
              Text(widget.finalDosha, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF1B4332))),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Text(widget.description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black54)),
              ),
              const SizedBox(height: 30),
              _buildScoreRow("Vata", widget.vata, const Color(0xFF8ECAE6)),
              _buildScoreRow("Pitta", widget.pitta, const Color(0xFFFB8500)),
              _buildScoreRow("Kapha", widget.kapha, const Color(0xFF2D6A4F)),
              const Spacer(),
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