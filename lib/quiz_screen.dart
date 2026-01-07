import 'package:ayurveda_app/quiz_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// --- 1. DATA MODEL ---
class QuizQuestion {
  final String category;
  final String questionText;
  final List<String> options;

  QuizQuestion({
    required this.category,
    required this.questionText,
    required this.options,
  });
}

// --- 2. DATA (Ensure all 30 questions are here) ---
final List<QuizQuestion> doshaQuestions = [
  QuizQuestion(
    category: "Physical Traits",
    questionText: "How would you describe your natural body frame?",
    options: ["Lean & light", "Medium & muscular", "Broad & heavy"],
  ),
  // ... Paste all your other 29 questions here following the same format
];

// --- 3. UI & RESULT LOGIC ---
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _questionIndex = 0;
  int _vataScore = 0;
  int _pittaScore = 0;
  int _kaphaScore = 0;

  void _answerQuestion(int optionIndex) {
    setState(() {
      // Logic: Index 0=Vata, 1=Pitta, 2=Kapha
      if (optionIndex == 0) _vataScore++;
      else if (optionIndex == 1) _pittaScore++;
      else if (optionIndex == 2) _kaphaScore++;

      if (_questionIndex < doshaQuestions.length - 1) {
        _questionIndex++;
      } else {
        _showResult();
      }
    });
  }

  Future<void> _showResult() async { // Change to Future<void> and add async
    String finalDosha = "";
    String description = "";

    // ... (Your existing calculation logic for finalDosha and description) ...

    // --- SAVE TO FIREBASE LOGIC ---
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'dominantDosha': finalDosha,
          'doshaScores': {
            'vata': _vataScore,
            'pitta': _pittaScore,
            'kapha': _kaphaScore,
          },
          'lastAssessmentDate': DateTime.now(),
        }, SetOptions(merge: true)); // merge: true prevents overwriting other user data
      } catch (e) {
        print("Error saving quiz: $e");
      }
    }

    // Navigate to the result screen
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultScreen(
            finalDosha: finalDosha,
            description: description,
            vata: _vataScore,
            pitta: _pittaScore,
            kapha: _kaphaScore,
          ),
        ),
      );
    }
  }

  Widget _buildResultRow(String label, double percent, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 50, child: Text(label)),
          Expanded(
            child: LinearProgressIndicator(
              value: percent / 100,
              backgroundColor: Colors.grey.shade200,
              color: color,
              minHeight: 8,
            ),
          ),
          const SizedBox(width: 10),
          Text("${percent.toStringAsFixed(0)}%"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = doshaQuestions[_questionIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFE8F3EE), // Pistachio background
      appBar: AppBar(
        title: Text("Question ${_questionIndex + 1} / ${doshaQuestions.length}"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_questionIndex + 1) / doshaQuestions.length,
              color: const Color(0xFF009460),
            ),
            const SizedBox(height: 40),
            Text(currentQuestion.questionText,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const SizedBox(height: 40),
            // Loop through options
            ...currentQuestion.options.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () => _answerQuestion(entry.key),
                  child: Text(entry.value),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}