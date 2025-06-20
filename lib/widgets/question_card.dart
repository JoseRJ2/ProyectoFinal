import 'package:flutter/material.dart';
import '../models/question.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final int index;
  final Function(String) onAnswerSelected;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.index,
    required this.onAnswerSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pregunta ${index + 1}: ${question.question}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            ...question.options.entries.map((entry) {
              final optionKey = entry.key;
              final optionText = entry.value;
              final isSelected = question.userAnswer == optionText;
              final isCorrect = question.correctAnswer == optionText;
              
              return RadioListTile<String>(
                title: Text(optionText),
                value: optionText,
                groupValue: question.userAnswer,
                onChanged: (value) => onAnswerSelected(value!),
                tileColor: isSelected
                    ? (isCorrect ? Colors.green[50] : Colors.red[50])
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                secondary: isSelected
                    ? Icon(
                        isCorrect ? Icons.check_circle : Icons.error,
                        color: isCorrect ? Colors.green : Colors.red,
                      )
                    : null,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}