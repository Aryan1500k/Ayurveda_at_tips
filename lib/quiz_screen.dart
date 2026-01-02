import 'package:flutter/material.dart';

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

  void _showResult() {
    int totalQuestions = doshaQuestions.length;

    // Calculate Percentages
    double vataPercent = (_vataScore / totalQuestions) * 100;
    double pittaPercent = (_pittaScore / totalQuestions) * 100;
    double kaphaPercent = (_kaphaScore / totalQuestions) * 100;

    // Determine Dominant Dosha
    String finalDosha = "";
    if (_vataScore >= _pittaScore && _vataScore >= _kaphaScore) finalDosha = "Vata";
    else if (_pittaScore >= _vataScore && _pittaScore >= _kaphaScore) finalDosha = "Pitta";
    else finalDosha = "Kapha";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Your Ayurvedic Profile", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.spa, color: Color(0xFF009460), size: 50),
            const SizedBox(height: 10),
            Text("Dominant: $finalDosha",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF009460))),
            const Divider(height: 30),
            // Show Percentage Breakdown
            _buildResultRow("Vata", vataPercent, Colors.lightBlue),
            _buildResultRow("Pitta", pittaPercent, Colors.orange),
            _buildResultRow("Kapha", kaphaPercent, Colors.brown),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context); // Go back home
              },
              child: const Text("Finish", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
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