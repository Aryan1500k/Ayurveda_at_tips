import 'package:flutter/material.dart';
import 'quiz_question_screen.dart';

class QuizIntroScreen extends StatelessWidget {
  const QuizIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        // Logo updated to Image.asset as per previous instruction
        title: Image.asset('assets/logo.png', height: 30, errorBuilder: (context, error, stackTrace) {
          return const Text("AYURVEDA", style: TextStyle(color: Colors.black, letterSpacing: 2));
        }),
        centerTitle: true,
      ),
      // FIX: Added SingleChildScrollView to prevent overflow
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            // Reduced vertical padding to save space
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Leaf Icon
                const CircleAvatar(
                  radius: 50, // Slightly reduced radius from 60 to 50
                  backgroundColor: Color(0xFFF1F8F5),
                  child: Icon(Icons.eco, size: 50, color: Color(0xFF009460)),
                ),
                const SizedBox(height: 30),

                const Text(
                  "Find your Dosha",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Answer a few simple questions to understand your unique body-mind constitution.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 15, height: 1.4),
                ),
                const SizedBox(height: 30),

                // Info Row
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.access_time, size: 18, color: Colors.black54),
                    SizedBox(width: 8),
                    Text("30 questions  •  ~5 minutes",
                        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 40),

                // Start Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QuizQuestionScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009460),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 54), // Reduced height from 56 to 54
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Start", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Based on traditional Ayurvedic principles",
                  style: TextStyle(color: Colors.black45, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}