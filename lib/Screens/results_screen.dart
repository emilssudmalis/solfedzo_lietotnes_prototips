import 'package:flutter/material.dart';
import 'package:quiz/model/quiz_models.dart';
import 'package:quiz/Screens/motivational_screen.dart';
import 'package:quiz/utils/learning_service.dart';
import 'package:quiz/utils/quiz_colors.dart';

class ResultsScreen extends StatelessWidget {
  final SessionResult session;
  final Topic topic;
  final bool didLevelUp;
  final bool isMastered;
  final bool justMastered;

  const ResultsScreen({
    super.key,
    required this.session,
    required this.topic,
    required this.didLevelUp,
    required this.isMastered,
    this.justMastered = false,
  });

  @override
  Widget build(BuildContext context) {
    LearningService service = LearningService();
    List<Question> questions = service.questions
        .where((q) => session.questionResults.any((r) => r.questionId == q.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rezultāti'),
        backgroundColor: quizcolorPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: quizviewcolor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Tavs rezultāts: ${session.score}/10',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (didLevelUp) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: quizcolorSecondary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '🎉 Esi sasniedzis nākamo līmeni!',
                          style: TextStyle(
                            color: quizcolorSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    if (isMastered) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: quizcolorAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '🏆 Tēma apgūta!',
                          style: TextStyle(
                            color: quizcolorAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: session.questionResults.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  QuestionResult result = session.questionResults[index];
                  Question question = questions.firstWhere((q) => q.id == result.questionId);
                  bool correct = result.correct;

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jautājums ${index + 1}: ${question.text}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          if (result.isValidation)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                               
                                const SizedBox(height: 8),
                                if (result.pressedNotes != null)
                                  Text(
                                    'Tavas izvēlētās notis: ${result.pressedNotes?.join(", ")}',
                                  ),
                              ],
                            )
                          else ...[
                            Text(
                              'Tava atbilde: ${question.options[result.selectedIndex]}',
                            ),
                          ],
                          if (!correct) ...[
                            const SizedBox(height: 8),
                            if (!result.isValidation) ...[
                              Text(
                                'Pareizā atbilde: ${question.options[question.correctIndex]}',
                                style: const TextStyle(
                                  color: quizcolorred,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                            Text(
                              'Izskaidrojums: ${question.explanation}',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              correct ? '✓ Pareizi!' : '✗ Nepareizi',
                              style: TextStyle(
                                color: correct ? quizcolorSecondary : quizcolorred,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MotivationalScreen(
                      topic: topic,
                      didLevelUp: didLevelUp,
                      isMastered: isMastered,
                      justMastered: justMastered,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: quizcolorPrimary,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Pabeigt'),
            ),
          ],
        ),
      ),
    );
  }
}