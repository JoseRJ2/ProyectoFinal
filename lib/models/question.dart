class Question {
  final String question;
  final Map<String, String> options;
  final String correctAnswer;
  String? userAnswer;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.userAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] ?? '',
      options: Map<String, String>.from(json['options'] ?? {}),
      correctAnswer: json['correct_answer'] ?? '',
    );
  }

  // Convertir las opciones a lista para mostrar en la UI
  List<String> get optionsList => options.values.toList();
  
  // Obtener la clave de la opción correcta
  String? get correctAnswerKey {
    return options.keys.firstWhere(
      (key) => options[key] == correctAnswer,
      orElse: () => '',
    );
  }
}