import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/quiz_model.dart';
import 'quiz_result_screen.dart';

class QuizQuestionScreen extends StatefulWidget {
  const QuizQuestionScreen({super.key});

  @override
  State<QuizQuestionScreen> createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen> {
  int _currentIndex = 0;
  int _vataScore = 0;
  int _pittaScore = 0;
  int _kaphaScore = 0;

  void _answerQuestion(int optionIndex) {
    // 1. Logic: Index 0=Vata, 1=Pitta, 2=Kapha
    if (optionIndex == 0) _vataScore++;
    else if (optionIndex == 1) _pittaScore++;
    else if (optionIndex == 2) _kaphaScore++;

    // 2. Navigation Logic
    if (_currentIndex < doshaQuestions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      _navigateToResults();
    }
  }

  void _navigateToResults() {
    String finalDosha = "";
    String description = "";

    // Calculation for final winner
    if (_vataScore >= _pittaScore && _vataScore >= _kaphaScore) {
      finalDosha = "Vata";
      description = "Your personality is characterized by space and air. You are creative, energetic, and thrive on change.";
    } else if (_pittaScore >= _vataScore && _pittaScore >= _kaphaScore) {
      finalDosha = "Pitta";
      description = "Your personality is characterized by fire and water. You are sharp, determined, and highly organized.";
    } else {
      finalDosha = "Kapha";
      description = "Your personality is characterized by earth and water. You are calm, loving, and provide steady support to others.";
    }

    // Move to Result Screen
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

  @override
  Widget build(BuildContext context) {
    final currentQuestion = doshaQuestions[_currentIndex];
    final progressValue = (_currentIndex + 1) / doshaQuestions.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("AYURVEDA AT TIPS", style: TextStyle(letterSpacing: 2, fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: progressValue,
            backgroundColor: const Color(0xFFE8F3EE),
            color: const Color(0xFF009460),
            minHeight: 4,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(color: const Color(0xFFE8F3EE), borderRadius: BorderRadius.circular(20)),
                    child: Text(currentQuestion.category, style: const TextStyle(color: Color(0xFF009460), fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    currentQuestion.questionText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.instrumentSans(fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
                  ),
                  const SizedBox(height: 50),
                  ...currentQuestion.options.asMap().entries.map((entry) => GestureDetector(
                    onTap: () => _answerQuestion(entry.key),
                    child: _buildOptionCard(entry.value),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 16, height: 1.4)),
    );
  }
}