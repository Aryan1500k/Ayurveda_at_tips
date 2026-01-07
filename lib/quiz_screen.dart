import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; //
import 'package:firebase_auth/firebase_auth.dart'; //

// 1. DATA MODEL
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

// 2. DATA (30 Questions)
final List<QuizQuestion> doshaQuestions = [
  // --- SECTION 1: PHYSICAL TRAITS ---
  QuizQuestion(category: "Physical Traits", questionText: "How would you describe your natural body frame?", options: ["Lean & light", "Medium & muscular", "Broad & heavy"]),
  QuizQuestion(category: "Physical Traits", questionText: "What is your skin type?", options: ["Dry, rough", "Warm, reddish, oily", "Soft, moist"]),
  QuizQuestion(category: "Physical Traits", questionText: "Describe your hair texture.", options: ["Dry, frizzy", "Fine, straight", "Thick, oily"]),
  QuizQuestion(category: "Physical Traits", questionText: "How would you describe your eyes?", options: ["Small, active", "Sharp, penetrating", "Large, calm"]),
  QuizQuestion(category: "Physical Traits", questionText: "Describe your teeth and nails.", options: ["Irregular, brittle", "Medium, pink", "Strong, smooth"]),
  QuizQuestion(category: "Physical Traits", questionText: "How is the quality of your voice?", options: ["Low, unsteady", "Clear, commanding", "Deep, steady"]),
  // --- SECTION 2: PHYSIOLOGICAL FUNCTIONS ---
  QuizQuestion(category: "Physiological Functions", questionText: "How is your usual appetite?", options: ["Irregular", "Strong", "Slow"]),
  QuizQuestion(category: "Physiological Functions", questionText: "How is your digestion?", options: ["Variable", "Fast", "Sluggish"]),
  QuizQuestion(category: "Physiological Functions", questionText: "What is your typical thirst level?", options: ["Low", "High", "Moderate"]),
  QuizQuestion(category: "Physiological Functions", questionText: "Describe your sleep quality.", options: ["Light", "Moderate", "Deep"]),
  QuizQuestion(category: "Physiological Functions", questionText: "What is your temperature tolerance?", options: ["Hates cold", "Hates heat", "Tolerates both"]),
  QuizQuestion(category: "Physiological Functions", questionText: "How is your physical stamina?", options: ["Low", "Moderate", "High"]),
  // --- SECTION 3: MENTAL & EMOTIONAL TRAITS ---
  QuizQuestion(category: "Mental & Emotional", questionText: "Describe your mood pattern.", options: ["Fluctuates often", "Short-tempered", "Stable"]),
  QuizQuestion(category: "Mental & Emotional", questionText: "How do you react to stress?", options: ["Anxious", "Angry", "Withdrawn"]),
  QuizQuestion(category: "Mental & Emotional", questionText: "What is your fear tendency?", options: ["Frequent", "Occasional", "Rare"]),
  QuizQuestion(category: "Mental & Emotional", questionText: "How do you express your emotions?", options: ["Expressive, dramatic", "Direct, intense", "Reserved"]),
  QuizQuestion(category: "Mental & Emotional", questionText: "What is your decision-making style?", options: ["Indecisve", "Quick, confident", "Slow, steady"]),
  QuizQuestion(category: "Mental & Emotional", questionText: "How is your memory?", options: ["Quick learn / forget", "Sharp", "Slow learn / long retain"]),
  // --- SECTION 4: BEHAVIORAL & COGNITIVE STYLE ---
  QuizQuestion(category: "Behavioral Style", questionText: "What is your speed of speech?", options: ["Fast", "Moderate", "Slow"]),
  QuizQuestion(category: "Behavioral Style", questionText: "What is your work pattern?", options: ["Creative but inconsistent", "Organized & goal-driven", "Patient & steady"]),
  QuizQuestion(category: "Behavioral Style", questionText: "Describe your social behavior.", options: ["Talkative", "Dominant", "Listener"]),
  QuizQuestion(category: "Behavioral Style", questionText: "How is your adaptability to new situations?", options: ["High", "Medium", "Low"]),
  QuizQuestion(category: "Behavioral Style", questionText: "What is your leadership style?", options: ["Flexible, idea-oriented", "Decisive, commanding", "Supportive, nurturing"]),
  QuizQuestion(category: "Behavioral Style", questionText: "How do you respond to criticism?", options: ["Gets hurt", "Defends strongly", "Takes quietly"]),
  // --- SECTION 5: LIFESTYLE PREFERENCES ---
  QuizQuestion(category: "Lifestyle", questionText: "What is your preferred environment?", options: ["Warm, calm", "Cool, open", "Dry & active"]),
  QuizQuestion(category: "Lifestyle", questionText: "What kind of food do you crave most?", options: ["Salty, crispy", "Spicy, sour", "Sweet, heavy"]),
  QuizQuestion(category: "Lifestyle", questionText: "What is your preferred weather?", options: ["Warm", "Cool", "Dry"]),
  QuizQuestion(category: "Lifestyle", questionText: "How is your daily routine?", options: ["Irregular", "Organized", "Slow & steady"]),
  QuizQuestion(category: "Lifestyle", questionText: "What is your natural energy pattern?", options: ["Bursts then fatigue", "Consistent", "Gradual but sustained"]),
  QuizQuestion(category: "Lifestyle", questionText: "What is your typical sleep timing habit?", options: ["Sleeps late", "Regulated/Planned", "Sleeps early"]),
];

// 3. UI & CALCULATION LOGIC
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
      // 0=Vata, 1=Pitta, 2=Kapha
      if (optionIndex == 0) _vataScore++;
      else if (optionIndex == 1) _pittaScore++;
      else if (optionIndex == 2) _kaphaScore++;

      if (_questionIndex < doshaQuestions.length - 1) {
        _questionIndex++;
      } else {
        // Delayed to prevent UI freeze on the last question
        Future.delayed(Duration.zero, () => _showResult());
      }
    });
  }

  Future<void> _showResult() async {
    String finalDosha = "";
    String description = "";

    // Calculation logic
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

    // SAVE TO FIREBASE
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'dominantDosha': finalDosha,
          'scores': {'vata': _vataScore, 'pitta': _pittaScore, 'kapha': _kaphaScore},
          'lastQuizDate': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint("Firebase Save Error: $e");
      }
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Center(child: Text("Your Dominant Dosha: $finalDosha", style: const TextStyle(fontWeight: FontWeight.bold))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.spa, color: Color(0xFF009460), size: 50),
            const SizedBox(height: 15),
            Text(description, textAlign: TextAlign.center),
            const Divider(height: 30),
            Text("Vata: $_vataScore  |  Pitta: $_pittaScore  |  Kapha: $_kaphaScore",
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Close Dialog
              Navigator.pop(context); // Go back
            },
            child: const Text("Done", style: TextStyle(color: Color(0xFF009460))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = doshaQuestions[_questionIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFE8F3EE),
      appBar: AppBar(
        title: Text("Question ${_questionIndex + 1} / 30"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_questionIndex + 1) / 30,
              backgroundColor: Colors.white,
              color: const Color(0xFF009460),
            ),
            const SizedBox(height: 30),
            Text(currentQuestion.category, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(currentQuestion.questionText,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const SizedBox(height: 40),
            ...currentQuestion.options.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
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