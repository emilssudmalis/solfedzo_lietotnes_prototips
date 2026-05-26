import 'package:flutter/material.dart';
import 'package:quiz/model/quiz_models.dart';
import 'package:quiz/Screens/results_screen.dart';
import 'package:quiz/utils/learning_service.dart';
import 'package:quiz/utils/quiz_colors.dart';

class EvaluationScreen extends StatefulWidget {
  final Topic topic;
  final List<QuestionResult> results;
  final int sessionScore;
  final int sessionLevel;
  final bool didLevelUp;
  final bool isMastered;

  const EvaluationScreen({
    super.key,
    required this.topic,
    required this.results,
    required this.sessionScore,
    required this.sessionLevel,
    required this.didLevelUp,
    required this.isMastered,
  });

  @override
  _EvaluationScreenState createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  int _rating = 0;

  Future<void> _submitRating() async {
    // Finalize session in learning service
    LearningService service = LearningService();
    await service.initialize();
    bool wasMastered = service.isMastered(widget.topic.id);
    service.finalizeSession(widget.topic.id, widget.sessionLevel, _rating);
    bool nowMastered = service.isMastered(widget.topic.id);
    bool justMastered = !wasMastered && nowMastered;
    await service.clearSessionState(widget.topic.id);
    
    int correctCount = widget.results.where((r) => r.correct).length;
    int totalCount = widget.results.length;
    int score = totalCount > 0 ? ((correctCount / totalCount) * 10).round() : 0;
    SessionResult session = SessionResult(
      topicId: widget.topic.id,
      startTime: DateTime.now().subtract(const Duration(minutes: 10)), // Approximate
      questionResults: widget.results,
      rating: _rating,
      score: score,
    );
    
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          session: session,
          topic: widget.topic,
          didLevelUp: widget.didLevelUp,
          isMastered: widget.isMastered,
          justMastered: justMastered,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novērtē savu veikumu'),
        backgroundColor: quizcolorPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show session summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Rezultāts:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${widget.results.where((r) => r.correct).length} / ${widget.results.length} punkti',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: quizcolorPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    const SizedBox(height: 12),
                    if (widget.didLevelUp)
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
                    if (widget.isMastered)
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
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Kā Tev veicās šajā mācību sesijā?',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    size: 40,
                    color: Colors.yellow.shade700,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _rating > 0 ? _submitRating : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: quizcolorPrimary,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Turpināt'),
            ),
          ],
        ),
      ),
    );
  }
}