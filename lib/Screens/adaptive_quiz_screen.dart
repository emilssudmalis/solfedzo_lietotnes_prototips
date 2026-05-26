import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quiz/model/quiz_models.dart';
import 'package:quiz/Screens/evaluation_screen.dart';
import 'package:quiz/Screens/piano_validation_widget.dart';
import 'package:quiz/utils/learning_service.dart';
import 'package:quiz/utils/quiz_colors.dart';

class AdaptiveQuizScreen extends StatefulWidget {
  final Topic topic;

  const AdaptiveQuizScreen({
    super.key,
    required this.topic,
  });

  @override
  _AdaptiveQuizScreenState createState() => _AdaptiveQuizScreenState();
}

class _AdaptiveQuizScreenState extends State<AdaptiveQuizScreen> {
  late LearningService _service;
  Question? _currentQuestion;
  int _bank1TaskIndex = 0; // Total Bank 1 tasks shown, including validation
  int _bank2Index = 0; // Track position in Bank 2
  late List<QuestionResult> _results;
  DateTime _startTime = DateTime.now();
  
  bool _answeringQuestion = false;
  bool _offerValidationTaskNext = false; // Should offer validation task on next load
  
  @override
  void initState() {
    super.initState();
    _service = LearningService();
    _results = [];

    _service.initialize().then((_) {
      if (!mounted) return;
      UserProgress progress = _service.getProgress(widget.topic.id);
      if (progress.shownQuestionsInSession.isEmpty) {
        _service.initializeSession(widget.topic.id);
      }
      _loadNextQuestion();
    });
  }

  bool get _isBank1Phase => _bank1TaskIndex < 7;

  int get _displayedQuestionNumber => min(10, _bank1TaskIndex + _bank2Index + 1);

  double get _overallProgressValue => (_bank1TaskIndex + _bank2Index) / 10;

  void _loadNextQuestion() {
    Question? nextQuestion;
    
    if (_isBank1Phase) {
      // Bank 1: up to 7 tasks total, including validation
      if (_bank1TaskIndex < 7) {
        // Check if we should offer a validation task first
        if (_offerValidationTaskNext) {
          nextQuestion = _service.getBank1ValidationTask(widget.topic.id);
          if (nextQuestion != null) {
            _offerValidationTaskNext = false;
          } else {
            // No validation task available, load regular question instead
            _offerValidationTaskNext = false;
            nextQuestion = _service.getNextQuestion(widget.topic.id, 1);
          }
        } else {
          nextQuestion = _service.getNextQuestion(widget.topic.id, 1);
        }
      }
    } else {
      // Bank 2: up to 3 questions  
      if (_bank2Index < 3) {
        nextQuestion = _service.getNextQuestion(widget.topic.id, 2, bank2Index: _bank2Index);
      }
    }
    
    setState(() {
      _currentQuestion = nextQuestion;
      _startTime = DateTime.now();
      _answeringQuestion = false;
    });
    
    // If no more questions available
    if (_currentQuestion == null) {
      _advancePhase();
    }
  }

  void _answerQuestion(int selectedIndex) {
    if (_answeringQuestion || _currentQuestion == null) return;
    
    setState(() {
      _answeringQuestion = true;
    });
    
    Question question = _currentQuestion!;
    bool correct = selectedIndex == question.correctIndex;
    int timeTaken = DateTime.now().difference(_startTime).inSeconds;
    
    _results.add(QuestionResult(
      questionId: question.id,
      correct: correct,
      selectedIndex: selectedIndex,
      timeTaken: timeTaken,
      isValidation: false,
    ));
    
    _service.recordAnswer(widget.topic.id, _isBank1Phase ? 1 : 2, correct, bank2Index: _bank2Index);
    _service.saveSessionState(widget.topic.id);
    
    // Check if we should offer validation task next (Bank 1 only)
    UserProgress progress = _service.getProgress(widget.topic.id);
    if (_isBank1Phase && progress.sessionConsecutiveCorrect >= 3 && !_offerValidationTaskNext) {
      _offerValidationTaskNext = true;
    }
    
    // Increment appropriate counter based on phase
    if (_isBank1Phase) {
      _bank1TaskIndex++;
    } else {
      _bank2Index++;
    }
    
    Future.delayed(const Duration(milliseconds: 500), _loadNextQuestion);
  }

  void _answerValidationTask(bool correct, List<int> pressedNotes) {
    if (_currentQuestion == null) return;
    
    Question question = _currentQuestion!;
    int timeTaken = DateTime.now().difference(_startTime).inSeconds;
    
    _results.add(QuestionResult(
      questionId: question.id,
      correct: correct,
      selectedIndex: -1,
      timeTaken: timeTaken,
      isValidation: true,
      pressedNotes: pressedNotes,
    ));
    
    // Record answer with isValidation flag
    _service.recordAnswer(widget.topic.id, _isBank1Phase ? 1 : 2, correct, bank2Index: _bank2Index, isValidation: true);
    _service.saveSessionState(widget.topic.id);
    
    // After validation task, reset flag and check if we got 3 correct in a row again
    _offerValidationTaskNext = false;
    
    if (_isBank1Phase) {
      _bank1TaskIndex++;
    } else {
      _bank2Index++;
    }
    // Note: For Bank 1, validation tasks count as part of the 7 tasks total
    
    setState(() {}); // update level badge immediately
    Future.delayed(const Duration(milliseconds: 500), _loadNextQuestion);
  }

  void _advancePhase() {
    UserProgress progress = _service.getProgress(widget.topic.id);
    bool didLevelUp = progress.sessionLevel > progress.currentLevel;

    // Check for level up in session
    if (didLevelUp) {
      _showLevelUpDialog();
    }

    // Check for mastery
    if (_service.isMastered(widget.topic.id)) {
      _showMasteredDialog();
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EvaluationScreen(
          topic: widget.topic,
          results: _results,
          sessionScore: progress.sessionScore,
          sessionLevel: progress.sessionLevel,
          didLevelUp: didLevelUp,
          isMastered: _service.isMastered(widget.topic.id),
        ),
      ),
    );
  }

  void _showLevelUpDialog() {
    UserProgress progress = _service.getProgress(widget.topic.id);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Esi sasniedzis nākamo līmeni!'),
        content: Text('Esi sasniedzis ${progress.currentLevel}. līmeni!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Turpināt'),
          ),
        ],
      ),
    );
  }

  void _showMasteredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🏆 Tēma apgūta!'),
        content: Text('Esi apguvis tēmu "${widget.topic.name}"!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Labi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestion == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.topic.name),
          backgroundColor: quizcolorPrimary,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    Question question = _currentQuestion!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.topic.name}: tests'),
        backgroundColor: quizcolorPrimary,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress indicator
                  LinearProgressIndicator(
                    value: _overallProgressValue,
                    minHeight: 6,
                  ),
                  const SizedBox(height: 16),
                  
                  // Question counter
                  Text(
                    'Jautājums $_displayedQuestionNumber no 10',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Question text (not shown for validation tasks as they display it in PianoValidationWidget)
                  if (!question.isValidation)
                    Text(
                      question.text,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  if (!question.isValidation)
                    const SizedBox(height: 24),
                  
                  // Show validation task or test options
                  if (question.isValidation)
                    PianoValidationWidget(
                      taskDescription: question.text,
                      expectedNotes: question.expectedNotes ?? [],
                      maxNotes: question.expectedNotes?.length ?? 2,
                      explanation: question.explanation,
                      onValidationComplete: _answerValidationTask,
                    )
                  else
                    Column(
                      children: question.options.asMap().entries.map((entry) {
                        int index = entry.key;
                        String option = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ElevatedButton(
                            onPressed: _answeringQuestion
                                ? null
                                : () => _answerQuestion(index),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: quizcolorPrimary,
                            ),
                            child: Text(
                              option,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 84),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: quizcolorPrimary,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.15 * 255).round()),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bar_chart, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Līmenis ${_service.getProgress(widget.topic.id).sessionLevel}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}