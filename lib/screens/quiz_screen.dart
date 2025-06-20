import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../routes/app_routes.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final currentQuestion = quizProvider.currentQuestion;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pregunta ${quizProvider.currentQuestionIndex + 1} de ${quizProvider.questions.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  currentQuestion.question,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion.optionsList.length,
                itemBuilder: (context, index) {
                  final option = currentQuestion.optionsList[index];
                  final isSelected = quizProvider.selectedAnswer == index;
                  final isCorrect = option == currentQuestion.correctAnswer;
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: isSelected
                        ? (isCorrect ? Colors.green.shade50 : Colors.red.shade50)
                        : null,
                    child: ListTile(
                      title: Text(option),
                      onTap: () {
                        if (quizProvider.selectedAnswer == null) {
                          quizProvider.selectAnswer(index);
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      trailing: isSelected
                          ? Icon(
                              isCorrect ? Icons.check_circle : Icons.cancel,
                              color: isCorrect ? Colors.green : Colors.red,
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: quizProvider.selectedAnswer != null
                  ? () {
                      if (quizProvider.isLastQuestion) {
                        Navigator.pushNamed(context, AppRoutes.results);
                      } else {
                        quizProvider.nextQuestion();
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                quizProvider.isLastQuestion ? 'Ver Resultados' : 'Siguiente Pregunta',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}