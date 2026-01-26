import 'package:flutter/material.dart';

class QuizIntroScreen extends StatefulWidget {
  final VoidCallback onConsultExpert;
  final VoidCallback onViewPlan;

  const QuizIntroScreen({
    super.key,
    required this.onConsultExpert,
    required this.onViewPlan,
  });

  @override
  State<QuizIntroScreen> createState() => _QuizIntroScreenState();
}

class _QuizIntroScreenState extends State<QuizIntroScreen> {
  int _currentStep = 0; // 0: Intro, 1: Quiz, 2: Result
  int _questionIndex = 0;

  int _vataScore = 0;
  int _pittaScore = 0;
  int _kaphaScore = 0;

  // Updated Question List with specific categories and new questions
  final List<Map<String, dynamic>> _quizData = [
    // --- Physical Traits (1-7) - BLUE ---
    {"cat": "Physical traits", "color": const Color(0xFFE1F5FE), "q": "How would you describe your natural body frame?", "a": ["Thin and light, with prominent joints and bones", "Medium build with well-defined muscles", "Solid and sturdy with a broader, heavier frame"]},
    {"cat": "Physical traits", "color": const Color(0xFFE1F5FE), "q": "What best describes your skin?", "a": ["Dry, rough, thin, or prone to cracking", "Warm, sensitive, prone to redness or acne", "Smooth, soft, oily, and cool to touch"]},
    {"cat": "Physical traits", "color": const Color(0xFFE1F5FE), "q": "How would you describe your hair?", "a": ["Dry, frizzy, curly, or thin", "Fine, straight, early graying or thinning", "Thick, wavy, lustrous, and oily"]},
    {"cat": "Physical traits", "color": const Color(0xFFE1F5FE), "q": "What best describes your eyes?", "a": ["Small, dry, dark, active and quick-moving", "Medium, sharp, penetrating, light-colored", "Large, calm, soft, and attractive"]},
    {"cat": "Physical traits", "color": const Color(0xFFE1F5FE), "q": "How are your teeth and nails?", "a": ["Irregular, crooked teeth; brittle, dry nails", "Medium, yellowish teeth; soft, pink nails", "Strong, white teeth; thick, smooth nails"]},
    {"cat": "Physical traits", "color": const Color(0xFFE1F5FE), "q": "How would you describe your voice?", "a": ["Low, weak, hoarse, or cracking", "Sharp, clear, and penetrating", "Deep, pleasant, and melodious"]},
    {"cat": "Physical traits", "color": const Color(0xFFE1F5FE), "q": "What best describes your appetite?", "a": ["Variable - sometimes ravenous, sometimes none", "Strong and consistent - irritable if I miss meals", "Steady but moderate - I can easily skip meals"]},

    // --- Physiological Functions (8-12) - GREEN ---
    {"cat": "Physiological Functions", "color": const Color(0xFFE8F5E9), "q": "How does your digestion typically behave?", "a": ["Irregular - bloating, gas, constipation common", "Strong and efficient - rarely have issues", "Slow and steady - feel heavy after eating"]},
    {"cat": "Physiological Functions", "color": const Color(0xFFE8F5E9), "q": "How thirsty do you usually feel?", "a": ["Variable thirst, often forget to drink water", "Frequently thirsty, need lots of fluids", "Rarely thirsty, can go long without water"]},
    {"cat": "Physiological Functions", "color": const Color(0xFFE8F5E9), "q": "What best describes your sleep patterns?", "a": ["Light sleeper, wake easily, vivid dreams", "Moderate sleep, can function on less", "Deep and long sleep, hard to wake up"]},
    {"cat": "Physiological Functions", "color": const Color(0xFFE8F5E9), "q": "How do you tolerate different temperatures?", "a": ["Dislike cold, prefer warmth and sunshine", "Dislike heat, prefer cool environments", "Dislike cold and damp, prefer dry warmth"]},
    {"cat": "Physiological Functions", "color": const Color(0xFFE8F5E9), "q": "How would you describe your stamina and endurance?", "a": ["Quick bursts of energy, tire easily", "Moderate, steady energy with good drive", "High endurance, slow to start but last long"]},

    // --- Mental & Emotional Traits (13-18) - LAVENDER ---
    {"cat": "Mental & Emotional Traits", "color": const Color(0xFFF3E5F5), "q": "How would you describe your typical mood pattern?", "a": ["Changeable, enthusiastic then anxious", "Intense, passionate, can get irritable", "Calm, steady, content, can be complacent"]},
    {"cat": "Mental & Emotional Traits", "color": const Color(0xFFF3E5F5), "q": "When stressed, how do you typically respond?", "a": ["Anxious, worried, restless thoughts", "Irritable, frustrated, quick to react", "Withdrawn, quiet, seeking comfort"]},
    {"cat": "Mental & Emotional Traits", "color": const Color(0xFFF3E5F5), "q": "What are you most prone to fear?", "a": ["Uncertainty, loneliness, the unknown", "Failure, being wrong, loss of control", "Change, taking risks, new situations"]},
    {"cat": "Mental & Emotional Traits", "color": const Color(0xFFF3E5F5), "q": "How do you typically express emotions?", "a": ["Quickly, openly, but briefly", "Intensely and directly", "Slowly, after much consideration"]},
    {"cat": "Mental & Emotional Traits", "color": const Color(0xFFF3E5F5), "q": "How do you make decisions?", "a": ["Quickly, but may change my mind often", "Decisively and confidently", "Slowly and carefully, after much thought"]},
    {"cat": "Mental & Emotional Traits", "color": const Color(0xFFF3E5F5), "q": "How would you describe your memory?", "a": ["Quick to learn, quick to forget", "Sharp memory, especially for details", "Slow to learn, but never forget"]},

    // --- Behavioral & Cognitive Style (19-24) - ORANGE ---
    {"cat": "Behavioral & Cognitive Style", "color": const Color(0xFFFFF3E0), "q": "How fast do you typically speak?", "a": ["Fast, sometimes jumping between topics", "Clear, precise, and to the point", "Slow, steady, and thoughtful"]},
    {"cat": "Behavioral & Cognitive Style", "color": const Color(0xFFFFF3E0), "q": "What is your work pattern like?", "a": ["Creative bursts, easily distracted", "Focused, organized, goal-driven", "Steady, methodical, thorough"]},
    {"cat": "Behavioral & Cognitive Style", "color": const Color(0xFFFFF3E0), "q": "How do you behave in social situations?", "a": ["Talkative, make friends easily but briefly", "Selective, prefer meaningful connections", "Reserved initially, but deeply loyal"]},
    {"cat": "Behavioral & Cognitive Style", "color": const Color(0xFFFFF3E0), "q": "How easily do you adapt to change?", "a": ["Easily, I enjoy variety and new things", "When it makes sense, I adapt purposefully", "Slowly, I prefer stability and routine"]},
    {"cat": "Behavioral & Cognitive Style", "color": const Color(0xFFFFF3E0), "q": "How would you describe your leadership style?", "a": ["Inspiring ideas, but prefer others to lead", "Natural leader, decisive and commanding", "Supportive leader, steady and nurturing"]},
    {"cat": "Behavioral & Cognitive Style", "color": const Color(0xFFFFF3E0), "q": "How do you respond to criticism?", "a": ["Sensitive, may feel hurt or anxious", "Defensive, may argue or feel challenged", "Take it in stride, rarely bothered"]},

    // --- Lifestyle Preferences (25-30) - GOLD/YELLOW ---
    {"cat": "Lifestyle Preferences", "color": const Color(0xFFFFF9C4), "q": "What kind of environment do you prefer?", "a": ["Warm, cozy, protected from wind", "Cool, well-ventilated, near water", "Spacious, bright, with variety"]},
    {"cat": "Lifestyle Preferences", "color": const Color(0xFFFFF9C4), "q": "What foods do you typically crave?", "a": ["Crunchy, dry, light snacks", "Spicy, hot, intense flavors", "Sweet, creamy, comfort foods"]},
    {"cat": "Lifestyle Preferences", "color": const Color(0xFFFFF9C4), "q": "What weather do you prefer?", "a": ["Warm and humid, avoid cold and wind", "Cool and dry, avoid heat and sun", "Warm and dry, avoid cold and damp"]},
    {"cat": "Lifestyle Preferences", "color": const Color(0xFFFFF9C4), "q": "How structured is your daily routine?", "a": ["Irregular, varies from day to day", "Organized, planned with clear goals", "Steady, predictable, and comfortable"]},
    {"cat": "Lifestyle Preferences", "color": const Color(0xFFFFF9C4), "q": "How does your energy flow throughout the day?", "a": ["Peaks and dips, unpredictable", "Strong midday, steady afternoon", "Slow start, builds gradually, lasts long"]},
    {"cat": "Lifestyle Preferences", "color": const Color(0xFFFFF9C4), "q": "What is your natural sleep timing habit?", "a": ["Variable bedtime, light and interrupted sleep", "Moderate sleeper, sleep efficiently", "Love to sleep long, hard to wake up"]},
  ];

  void _handleAnswer(int index) {
    if (index == 0) _vataScore++;
    if (index == 1) _pittaScore++;
    if (index == 2) _kaphaScore++;

    if (_questionIndex < _quizData.length - 1) {
      setState(() => _questionIndex++);
    } else {
      setState(() => _currentStep = 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentStep == 0) return _buildIntro();
    if (_currentStep == 1) return _buildQuiz();
    return _buildResult();
  }

  Widget _buildIntro() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F4),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Find your Dosha", style: TextStyle(fontFamily: 'Trajan Pro', fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              const Text("Answer 30 simple questions to understand your unique body-mind constitution.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 25),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [_circleIcon(const Color(0xFFE1F5FE), Icons.air, Colors.lightBlue), const SizedBox(width: 10), _circleIcon(const Color(0xFFFFF3E0), Icons.whatshot, Colors.orange), const SizedBox(width: 10), _circleIcon(const Color(0xFFE8F5E9), Icons.opacity, Colors.green)]),
              const SizedBox(height: 20),
              const Text("30 questions ~ 5 minutes", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),
              ElevatedButton(onPressed: () => setState(() => _currentStep = 1), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B6B23), minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))), child: const Text("Start Quiz", style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuiz() {
    final currentQuestion = _quizData[_questionIndex];
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 18), onPressed: () => setState(() { if(_questionIndex > 0) _questionIndex--; else _currentStep = 0; })),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
              color: currentQuestion['color'], // Dynamic Category Color
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black.withOpacity(0.05))
          ),
          child: Text(currentQuestion['cat'], style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(currentQuestion['q'], textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            ...List.generate(3, (i) => _quizOption(currentQuestion['a'][i], i)),
            const SizedBox(height: 80),
            Text("${_questionIndex + 1} out of 30", style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _quizOption(String text, int index) {
    return GestureDetector(
      onTap: () => _handleAnswer(index),
      child: Container(
        width: double.infinity, margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)]),
        child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  Widget _buildResult() {
    int total = _vataScore + _pittaScore + _kaphaScore;
    double vP = _vataScore / total; double pP = _pittaScore / total; double kP = _kaphaScore / total;

    String dosha = "Vata"; Color themeColor = Colors.lightBlue;
    String description = "Vata types are creative, energetic, and thin-framed.";
    List<String> tags = ["Creative", "Energetic", "Quick", "Alert"];

    if (pP >= vP && pP >= kP) {
      dosha = "Pitta"; themeColor = Colors.orange;
      description = "Pitta types are focused, determined, and have strong leadership qualities.";
      tags = ["Focused", "Determined", "Ambitious", "Sharp"];
    } else if (kP >= vP && kP >= pP) {
      dosha = "Kapha"; themeColor = Colors.green;
      description = "Kapha types are naturally grounded, patient, and supportive. Your endurance and reliability are your greatest strengths.";
      tags = ["Calm", "Steady", "Loyal", "Nurturing"];
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F4),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Text("Your Dosha Profile", style: TextStyle(fontFamily: 'Trajan Pro', fontSize: 24, fontWeight: FontWeight.bold)),
            const Text("Based on your answers", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(color: themeColor.withOpacity(0.15), borderRadius: BorderRadius.circular(30)),
              child: Column(
                children: [
                  CircleAvatar(radius: 50, backgroundColor: Colors.white, child: Icon(Icons.spa, size: 50, color: themeColor)),
                  const SizedBox(height: 15),
                  Text(dosha, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: themeColor)),
                  const Text("Earth", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 25),
                  _resultBar("Kapha", kP, Colors.green, "${(kP * 100).toInt()}%"),
                  _resultBar("Pitta", pP, Colors.orange, "${(pP * 100).toInt()}%"),
                  _resultBar("Vata", vP, Colors.lightBlue, "${(vP * 100).toInt()}%"),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Wrap(spacing: 10, children: tags.map((t) => _Tag(label: t, color: themeColor)).toList()),
            const Padding(padding: EdgeInsets.all(30), child: Text("What This Means for You", style: TextStyle(fontFamily: 'Trajan Pro', fontSize: 20))),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 40), child: Text(description, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, height: 1.5))),

            // Tips for Balance Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: Column(
                children: [
                  const Text("Tips for Balance", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 15),
                  _buildTip("Stay active with regular, vigorous exercise"),
                  _buildTip("Favor light, warm, and stimulating foods"),
                  _buildTip("Embrace variety and new experiences"),
                  _buildTip("Rise early and maintain an active lifestyle"),
                ],
              ),
            ),

            ElevatedButton(onPressed: widget.onViewPlan, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B6B23), minimumSize: const Size(280, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text("View My Dosha Plan", style: TextStyle(color: Colors.white))),
            const SizedBox(height: 10),
            TextButton(onPressed: widget.onConsultExpert, child: const Text("Consult an Ayurvedic Expert", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
            TextButton(onPressed: () => setState(() { _currentStep = 0; _questionIndex = 0; _vataScore = 0; _pittaScore = 0; _kaphaScore = 0; }), child: const Text("Retake the quiz", style: TextStyle(color: Colors.grey))),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [const Icon(Icons.check_circle_outline, color: Colors.green, size: 20), const SizedBox(width: 10), Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.grey)))]),
    );
  }

  Widget _resultBar(String label, double val, Color color, String percent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [SizedBox(width: 60, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))), Expanded(child: LinearProgressIndicator(value: val, color: color, backgroundColor: Colors.white, minHeight: 10, borderRadius: BorderRadius.circular(5))), const SizedBox(width: 10), Text(percent, style: const TextStyle(fontWeight: FontWeight.bold))]),
    );
  }

  Widget _circleIcon(Color bg, IconData icon, Color iconColor) {
    return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: bg, shape: BoxShape.circle), child: Icon(icon, color: iconColor, size: 24));
  }
}

class _Tag extends StatelessWidget {
  final String label; final Color color;
  const _Tag({required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(border: Border.all(color: color), borderRadius: BorderRadius.circular(20)), child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)));
  }
}