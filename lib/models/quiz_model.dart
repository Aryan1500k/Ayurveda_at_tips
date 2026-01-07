import 'package:flutter/material.dart';

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

final List<QuizQuestion> doshaQuestions = [
  // --- PHYSICAL TRAITS (1-6) ---
  QuizQuestion(category: "Physical Traits", questionText: "How would you describe your natural body frame?", options: ["Lean & light", "Medium & muscular", "Broad & heavy"]),
  QuizQuestion(category: "Physical Traits", questionText: "What is your skin type?", options: ["Dry, rough", "Warm, reddish, oily", "Soft, moist"]),
  QuizQuestion(category: "Physical Traits", questionText: "Describe your hair texture.", options: ["Dry, frizzy", "Fine, straight", "Thick, oily"]),
  QuizQuestion(category: "Physical Traits", questionText: "How would you describe your eyes?", options: ["Small, active", "Sharp, penetrating", "Large, calm"]),
  QuizQuestion(category: "Physical Traits", questionText: "Describe your teeth and nails.", options: ["Irregular, brittle", "Medium, pink", "Strong, smooth"]),
  QuizQuestion(category: "Physical Traits", questionText: "How is the quality of your voice?", options: ["Low, unsteady", "Clear, commanding", "Deep, steady"]),

  // --- PHYSIOLOGICAL FUNCTIONS (7-12) ---
  QuizQuestion(category: "Physiological Functions", questionText: "How is your usual appetite?", options: ["Irregular", "Strong", "Slow"]),
  QuizQuestion(category: "Physiological Functions", questionText: "How is your digestion?", options: ["Variable", "Fast", "Sluggish"]),
  QuizQuestion(category: "Physiological Functions", questionText: "What is your typical thirst level?", options: ["Low", "High", "Moderate"]),
  QuizQuestion(category: "Physiological Functions", questionText: "Describe your sleep quality.", options: ["Light", "Moderate", "Deep"]),
  QuizQuestion(category: "Physiological Functions", questionText: "What is your temperature tolerance?", options: ["Hates cold", "Hates heat", "Tolerates both"]),
  QuizQuestion(category: "Physiological Functions", questionText: "How is your physical stamina?", options: ["Low", "Moderate", "High"]),

  // --- MENTAL & EMOTIONAL (13-18) ---
  QuizQuestion(category: "Mental & Emotional", questionText: "Describe your mood pattern.", options: ["Fluctuates often", "Short-tempered", "Stable"]),
  QuizQuestion(category: "Mental & Emotional", questionText: "How do you react to stress?", options: ["Anxious", "Angry", "Withdrawn"]),
  QuizQuestion(category: "Mental & Emotional", questionText: "What is your fear tendency?", options: ["Frequent", "Occasional", "Rare"]),
  QuizQuestion(category: "Mental & Emotional", questionText: "How do you express your emotions?", options: ["Expressive, dramatic", "Direct, intense", "Reserved"]),
  QuizQuestion(category: "Mental & Emotional", questionText: "What is your decision-making style?", options: ["Indecisve", "Quick, confident", "Slow, steady"]),
  QuizQuestion(category: "Mental & Emotional", questionText: "How is your memory?", options: ["Quick learn / forget", "Sharp", "Slow learn / long retain"]),

  // --- BEHAVIORAL STYLE (19-24) ---
  QuizQuestion(category: "Behavioral Style", questionText: "What is your speed of speech?", options: ["Fast", "Moderate", "Slow"]),
  QuizQuestion(category: "Behavioral Style", questionText: "What is your work pattern?", options: ["Creative but inconsistent", "Organized & goal-driven", "Patient & steady"]),
  QuizQuestion(category: "Behavioral Style", questionText: "Describe your social behavior.", options: ["Talkative", "Dominant", "Listener"]),
  QuizQuestion(category: "Behavioral Style", questionText: "How is your adaptability to new situations?", options: ["High", "Medium", "Low"]),
  QuizQuestion(category: "Behavioral Style", questionText: "What is your leadership style?", options: ["Flexible, idea-oriented", "Decisive, commanding", "Supportive, nurturing"]),
  QuizQuestion(category: "Behavioral Style", questionText: "How do you respond to criticism?", options: ["Gets hurt", "Defends strongly", "Takes quietly"]),

  // --- LIFESTYLE (25-30) ---
  QuizQuestion(category: "Lifestyle", questionText: "What is your preferred environment?", options: ["Warm, calm", "Cool, open", "Dry & active"]),
  QuizQuestion(category: "Lifestyle", questionText: "What kind of food do you crave most?", options: ["Salty, crispy", "Spicy, sour", "Sweet, heavy"]),
  QuizQuestion(category: "Lifestyle", questionText: "What is your preferred weather?", options: ["Warm", "Cool", "Dry"]),
  QuizQuestion(category: "Lifestyle", questionText: "How is your daily routine?", options: ["Irregular", "Organized", "Slow & steady"]),
  QuizQuestion(category: "Lifestyle", questionText: "What is your natural energy pattern?", options: ["Bursts then fatigue", "Consistent", "Gradual but sustained"]),
  QuizQuestion(category: "Lifestyle", questionText: "What is your typical sleep timing habit?", options: ["Sleeps late", "Regulated/Planned", "Sleeps early"]),
];