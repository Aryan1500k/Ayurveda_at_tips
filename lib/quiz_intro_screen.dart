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

  // Complete List of 30 Questions with Categories
  final List<Map<String, dynamic>> _quizData = [
    // --- Physical Traits (1-10) ---
    {"cat": "Physical traits", "q": "How would you describe your natural body frame?", "a": ["Thin, bony, or lanky", "Medium or athletic", "Broad or heavy-set"]},
    {"cat": "Physical traits", "q": "How is your skin texture usually?", "a": ["Dry and rough", "Oily and sensitive", "Soft and thick"]},
    {"cat": "Physical traits", "q": "Your hair is mostly...", "a": ["Dry or frizzy", "Fine or thinning", "Thick and oily"]},
    {"cat": "Physical traits", "q": "How do your joints feel?", "a": ["Prominent/Crack easily", "Flexible", "Sturdy/Well-padded"]},
    {"cat": "Physical traits", "q": "How would you describe your eyes?", "a": ["Small or active", "Sharp or piercing", "Large and calm"]},
    {"cat": "Physical traits", "q": "Your teeth and gums are...", "a": ["Irregular", "Medium/Prone to bleeding", "Strong and white"]},
    {"cat": "Physical traits", "q": "How is your physical strength?", "a": ["Low/Energy bursts", "Moderate/Competitive", "High/Steady endurance"]},
    {"cat": "Physical traits", "q": "Your walking pace is...", "a": ["Fast and hurried", "Steady and purposeful", "Slow and graceful"]},
    {"cat": "Physical traits", "q": "Your nails are usually...", "a": ["Brittle or rough", "Soft and pink", "Thick and smooth"]},
    {"cat": "Physical traits", "q": "Reaction to weather...", "a": ["Dislike cold", "Dislike heat", "Dislike damp"]},

    // --- Physiological Traits (11-20) ---
    {"cat": "Physiological traits", "q": "How would you describe your appetite?", "a": ["Irregular", "Strong and intense", "Steady but low"]},
    {"cat": "Physiological traits", "q": "How is your digestion?", "a": ["Prone to gas", "Prone to acidity", "Slow/Feels heavy"]},
    {"cat": "Physiological traits", "q": "How would you describe your sleep?", "a": ["Light/Interrupted", "Moderate/Sound", "Deep and heavy"]},
    {"cat": "Physiological traits", "q": "Your speech is generally...", "a": ["Fast/Talkative", "Sharp/Convincing", "Slow/Melodious"]},
    {"cat": "Physiological traits", "q": "Body temperature feels...", "a": ["Cold (hands/feet)", "Warm/Hot", "Cool/Consistent"]},
    {"cat": "Physiological traits", "q": "How is your memory?", "a": ["Quick to learn/forget", "Sharp and clear", "Slow to learn/Never forgets"]},
    {"cat": "Physiological traits", "q": "Your sweating is...", "a": ["Scanty", "Profuse/Strong-smelling", "Moderate/Steady"]},
    {"cat": "Physiological traits", "q": "Your bowel movements are...", "a": ["Hard/Constipated", "Soft/Loose", "Regular/Heavy"]},
    {"cat": "Physiological traits", "q": "Response to stress...", "a": ["Fear/Anxiety", "Anger/Irritability", "Calm/Withdrawal"]},
    {"cat": "Physiological traits", "q": "Your dreams are often...", "a": ["Active/Fearful", "Vivid/Conflict", "Peaceful/Water"]},

    // --- Psychological Traits (21-30) ---
    {"cat": "Psychological traits", "q": "Your concentration style is...", "a": ["Short-term", "Focused/Intense", "Steady/Calm"]},
    {"cat": "Psychological traits", "q": "In decision making, you are...", "a": ["Indecisive", "Quick/Confident", "Slow but firm"]},
    {"cat": "Psychological traits", "q": "Your mood changes...", "a": ["Quickly/Frequently", "Predictably", "Rarely/Stable"]},
    {"cat": "Psychological traits", "q": "How do you handle money?", "a": ["Spend impulsively", "Spend on quality", "Save/Accumulate"]},
    {"cat": "Psychological traits", "q": "Your social nature is...", "a": ["Talkative", "Selective", "Loyal/Reserved"]},
    {"cat": "Psychological traits", "q": "Handling new challenges...", "a": ["Excitement then worry", "Determination", "Initial resistance"]},
    {"cat": "Psychological traits", "q": "Your belief system is...", "a": ["Experimental", "Logical", "Traditional"]},
    {"cat": "Psychological traits", "q": "In a group, you are...", "a": ["Active participant", "The leader", "The supporter"]},
    {"cat": "Psychological traits", "q": "Your sexual desire is...", "a": ["Variable", "Passionate", "Steady"]},
    {"cat": "Psychological traits", "q": "Long-term energy is...", "a": ["Exhausted easily", "Goal-oriented", "Steady/Lasting"]},
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

  // --- Intro UI ---
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
              const Text("Answer a few simple questions to understand your unique body-mind constitution.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
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

  // --- Question UI with Dynamic Categories ---
  Widget _buildQuiz() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 18), onPressed: () => setState(() => _currentStep = 0)),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Text(_quizData[_questionIndex]['cat'], style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_quizData[_questionIndex]['q'], textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            ...List.generate(3, (i) => _quizOption(_quizData[_questionIndex]['a'][i], i)),
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
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  // --- Dynamic Results Section ---
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
            const SizedBox(height: 40),
            ElevatedButton(onPressed: widget.onViewPlan, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B6B23), minimumSize: const Size(280, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text("View My Dosha Plan", style: TextStyle(color: Colors.white))),
            const SizedBox(height: 15),
            TextButton(onPressed: widget.onConsultExpert, child: const Text("Consult an Ayurvedic Expert", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
            TextButton(onPressed: () => setState(() { _currentStep = 0; _questionIndex = 0; _vataScore = 0; _pittaScore = 0; _kaphaScore = 0; }), child: const Text("Retake the quiz", style: TextStyle(color: Colors.grey))),
            const SizedBox(height: 60),
          ],
        ),
      ),
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