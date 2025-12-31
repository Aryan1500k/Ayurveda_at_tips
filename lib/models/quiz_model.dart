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
  // SECTION 1: PHYSICAL TRAITS
  QuizQuestion(
    category: "Physical Traits",
    questionText: "How would you describe your natural body frame?",
    options: [
      "Thin and light, with prominent joints", // Vata
      "Medium build with well-defined muscles", // Pitta
      "Solid and sturdy with a broader frame", // Kapha
    ],
  ),
  QuizQuestion(
    category: "Physical Traits",
    questionText: "How does your skin usually feel?",
    options: [
      "Dry, thin, and prone to coolness",
      "Warm, sensitive, and prone to redness",
      "Oily, smooth, and thick",
    ],
  ),
  QuizQuestion(
    category: "Physical Traits",
    questionText: "Describe your hair texture.",
    options: [
      "Dry, brittle, or curly",
      "Fine, soft, and prone to early greying",
      "Thick, oily, and lustrous",
    ],
  ),

  // SECTION 2: PHYSIOLOGICAL ATTRIBUTES
  QuizQuestion(
    category: "Physiology",
    questionText: "What is your typical sleep pattern?",
    options: [
      "Light sleep, easily disturbed",
      "Moderate sleeper, usually wakes energetic",
      "Deep, heavy sleeper; wakes up slowly",
    ],
  ),
  QuizQuestion(
    category: "Physiology",
    questionText: "How is your appetite and digestion?",
    options: [
      "Variable or irregular; gets bloated easily",
      "Strong and frequent; gets irritable if hungry",
      "Steady but slow; feels heavy after meals",
    ],
  ),
  QuizQuestion(
    category: "Physiology",
    questionText: "How do you react to different temperatures?",
    options: [
      "Prefers warmth; hands and feet often cold",
      "Prefers cold; feels hot regardless of season",
      "Adaptable, but prefers moderate/dry heat",
    ],
  ),

  // SECTION 3: EMOTIONAL & MENTAL
  QuizQuestion(
    category: "Emotional State",
    questionText: "How do you usually react to stress?",
    options: [
      "I get anxious, worried, or fearful",
      "I get irritable, angry, or impatient",
      "I remain calm and may become withdrawn",
    ],
  ),
  QuizQuestion(
    category: "Emotional State",
    questionText: "How would you describe your speech?",
    options: [
      "Fast, talkative, and sometimes scattered",
      "Precise, clear, and sharp",
      "Slow, thoughtful, and melodic",
    ],
  ),
  QuizQuestion(
    category: "Emotional State",
    questionText: "What is your memory style?",
    options: [
      "Learns quickly but forgets quickly",
      "Good medium-term memory; focused",
      "Slow to learn but never forgets",
    ],
  ),
];