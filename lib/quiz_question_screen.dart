import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/quiz_model.dart'; // Import the model above

class QuizQuestionScreen extends StatefulWidget {
  const QuizQuestionScreen({super.key});

  @override
  State<QuizQuestionScreen> createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen> {
  int _currentIndex = 0; // Tracks the current question (0 to 29)

  void _nextQuestion() {
    if (_currentIndex < doshaQuestions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      // Logic for when the quiz ends (e.g., show results)
      print("Quiz Completed!");
    }
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("AYURVEDA AT TIPS", style: TextStyle(letterSpacing: 2, fontSize: 14, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text("${_currentIndex + 1} of ${doshaQuestions.length}"),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Dynamic Progress Bar
          LinearProgressIndicator(
            value: progressValue,
            backgroundColor: const Color(0xFFE8F3EE),
            color: const Color(0xFF009460),
            minHeight: 3,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Dynamic Category Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(color: const Color(0xFFE8F3EE), borderRadius: BorderRadius.circular(20)),
                    child: Text(currentQuestion.category, style: const TextStyle(color: Color(0xFF009460), fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 40),
                  // Dynamic Question Text
                  Text(
                    currentQuestion.questionText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.instrumentSans(fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
                  ),
                  const SizedBox(height: 50),
                  // Generate Options dynamically
                  ...currentQuestion.options.map((optionText) => GestureDetector(
                    onTap: _nextQuestion, // Move to next question on tap
                    child: _buildOptionCard(optionText),
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