import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/question.dart';

class QuizProvider extends ChangeNotifier {
  List<Question> _questions = [];
  String _topic = '';
  bool _isLoading = false;
  String _error = '';
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;

  List<Question> get questions => _questions;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get topic => _topic;
  int get currentQuestionIndex => _currentQuestionIndex;
  int? get selectedAnswer => _selectedAnswerIndex;
  
  Question get currentQuestion {
    if (_currentQuestionIndex >= 0 && _currentQuestionIndex < _questions.length) {
      return _questions[_currentQuestionIndex];
    }
    return Question(
      question: "No hay preguntas disponibles",
      options: {},
      correctAnswer: "",
    );
  }

  bool isCorrect(int optionIndex) {
    if (_selectedAnswerIndex == null) return false;
    
    final selectedOption = currentQuestion.optionsList[optionIndex];
    return selectedOption == currentQuestion.correctAnswer;
  }

  bool get isLastQuestion => _currentQuestionIndex == _questions.length - 1;

  Future<void> fetchQuestions(String topic) async {
    _isLoading = true;
    _topic = topic;
    _error = '';
    _currentQuestionIndex = 0;
    _selectedAnswerIndex = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('https://07bwpv2s-3000.usw3.devtunnels.ms/generate-questions'), 
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'topic': topic}),
      );

      print('Respuesta del servidor: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _questions = data.map<Question>((q) => Question.fromJson(q)).toList();
        _error = '';
      } else {
        _error = 'Error al cargar preguntas: ${response.statusCode}\n${response.body}';
      }
    } catch (e) {
      _error = 'Error de conexión: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectAnswer(int index) {
    _selectedAnswerIndex = index;
    if (_currentQuestionIndex < _questions.length) {
      final selectedOption = currentQuestion.optionsList[index];
      _questions[_currentQuestionIndex].userAnswer = selectedOption;
    }
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _selectedAnswerIndex = null;
      notifyListeners();
    }
  }

  int calculateScore() {
    return _questions.where((q) => q.userAnswer == q.correctAnswer).length;
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _selectedAnswerIndex = null;
    notifyListeners();
  }

  void reset() {
    _questions = [];
    _topic = '';
    _error = '';
    _currentQuestionIndex = 0;
    _selectedAnswerIndex = null;
    notifyListeners();
  }
}