import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quiz/utils/app_widget.dart';
import 'package:quiz/utils/quiz_card.dart';
import 'package:quiz/utils/quiz_colors.dart';
import 'package:quiz/utils/quiz_constant.dart';
import 'package:quiz/utils/question_bank.dart';

class QuizCards extends StatefulWidget {
  static String tag = '/QuizCards';
  final String quizType;

  const QuizCards({super.key, required this.quizType});

  @override
  _QuizCardsState createState() => _QuizCardsState();
}

class _QuizCardsState extends State<QuizCards> {
  final List<Quiz> _questions = [];
  int _answeredQuestions = 0;
  int _correctAnswers = 0;
  late final int _totalQuestions;
  bool _isLoading = true;
  
  // Two-bank system
  bool _isBank1Active = true; // Start with bank 1
  int _bank1QuestionsAsked = 0;
  int _bank2QuestionsAsked = 0;
  late QuestionProgress _progress;
  int _currentBank2Difficulty = 1;

  @override
  void initState() {
    super.initState();
    _initializeQuestions();
  }

  Future<void> _initializeQuestions() async {
    _progress = await QuestionBank.loadProgress(widget.quizType);
    _progress.hasStartedTopic = true;
    
    // Load first question from Bank 1
    Quiz? nextQuestion = await QuestionBank.getNextBank1Question(
      widget.quizType,
      _progress.currentLevel,
      _progress.questionsShownInSession,
    );

    if (nextQuestion != null) {
      setState(() {
        _questions.add(nextQuestion);
        _totalQuestions = 10; // 7 from bank 1 + 3 from bank 2
        _isLoading = false;
      });
    }
  }

  Future<void> _loadNextQuestion() async {
    // Determine if we should load from bank 1 or bank 2
    if (_bank1QuestionsAsked < 7) {
      // Still loading from Bank 1
      Quiz? nextQuestion = await QuestionBank.getNextBank1Question(
        widget.quizType,
        _progress.currentLevel,
        _progress.questionsShownInSession,
      );

      if (nextQuestion != null) {
        setState(() {
          _questions.add(nextQuestion);
        });
      }
    } else if (_bank2QuestionsAsked < 3) {
      // Switch to Bank 2 if just finished Bank 1
      if (_isBank1Active) {
        setState(() {
          _isBank1Active = false;
          // Determine bank 2 difficulty based on bank 1 score
          _currentBank2Difficulty =
              QuestionBank.getBank2DifficultyFromBank1Score(_progress.bank1Score);
        });
      }

      // Load from Bank 2
      Quiz? nextQuestion = await QuestionBank.getNextBank2Question(
        widget.quizType,
        _currentBank2Difficulty,
        _progress.questionsShownInSession,
      );

      if (nextQuestion != null) {
        setState(() {
          _questions.add(nextQuestion);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: quizappbackground,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final progress = _totalQuestions == 0 ? 1.0 : _answeredQuestions / _totalQuestions;

    return Scaffold(
      backgroundColor: quizappbackground,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            if (_questions.isNotEmpty) ..._buildQuestions(context),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          finish(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: quizcolorPrimary,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            LinearProgressIndicator(
                              value: progress,
                              backgroundColor: textSecondaryColor.withAlpha(51),
                              valueColor: const AlwaysStoppedAnimation<Color>(quizgreen),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Text(
                                '$_answeredQuestions / $_totalQuestions answered',
                                style: const TextStyle(color: quiztextColorSecondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildQuestions(BuildContext context) {
    return List.generate(_questions.length, (index) {
      final question = _questions[index];
      return Positioned(
        top: question.topMargin ?? 0,
        child: Container(
          decoration: boxDecoration(radius: 20, bgColor: quizwhite, showShadow: true),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 200.0,
                width: 320.0,
                child: Container(
                  margin: const EdgeInsets.only(top: 50),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: text(question.cardImage, fontSize: textSizeLarge, fontFamily: fontBold, isLongText: true),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Column(
                  children: <Widget>[
                    quizCardSelection("A.", question.option1, () => _selectAnswer(index, 1)),
                    quizCardSelection("B.", question.option2, () => _selectAnswer(index, 2)),
                    quizCardSelection("C.", question.option3, () => _selectAnswer(index, 3)),
                    quizCardSelection("D.", question.option4, () => _selectAnswer(index, 4)),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  void _selectAnswer(int questionIndex, int selectedOption) async {
    final isCorrect = _questions[questionIndex].correctOption == selectedOption;
    final currentQuestion = _questions[questionIndex];

    // Update progress
    _progress = QuestionBank.updateProgress(
      _progress,
      isCorrect,
      currentQuestion.cardImage,
      _isBank1Active,
    );

    setState(() {
      _answeredQuestions += 1;
      if (isCorrect) {
        _correctAnswers += 1;
      }
      
      // Track which bank we're in
      if (_isBank1Active) {
        _bank1QuestionsAsked += 1;
      } else {
        _bank2QuestionsAsked += 1;
        // If correct in bank 2, try to increase difficulty
        if (isCorrect) {
          _currentBank2Difficulty = QuestionBank.getNextBank2Difficulty(
            _currentBank2Difficulty,
            2, // Max difficulty is 2 for now
          );
        }
      }
      
      _questions.removeAt(questionIndex);
    });

    // Save progress
    await QuestionBank.saveProgress(_progress);

    // Check if quiz is complete
    if (_bank1QuestionsAsked >= 7 && _bank2QuestionsAsked >= 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResult(
            score: _correctAnswers,
            total: _totalQuestions,
            bank1Score: _progress.bank1Score,
            bank2Score: _progress.bank2Score,
          ),
        ),
      );
    } else {
      // Load next question
      await _loadNextQuestion();
    }
  }

  List<Quiz> _createQuestions(String quizType) {
    // This method is no longer used, questions come from banks
    return [];
  }
}

class QuizResult extends StatelessWidget {
  final int score;
  final int total;
  final int bank1Score;
  final int bank2Score;

  const QuizResult({
    super.key,
    required this.score,
    required this.total,
    required this.bank1Score,
    required this.bank2Score,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total == 0 ? 0 : (score * 100 / total).round();
    return Scaffold(
      backgroundColor: quizappbackground,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: boxDecoration(radius: 20, bgColor: quizwhite, showShadow: true),
                  child: Column(
                    children: <Widget>[
                      text('Quiz Completed!', fontSize: 24, fontFamily: fontBold, textColor: quizcolorPrimary),
                      const SizedBox(height: 16),
                      text('You scored $score out of $total.', textColor: quiztextColorSecondary, fontSize: 18, isCentered: true),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: total == 0 ? 1.0 : score / total,
                        backgroundColor: textSecondaryColor.withAlpha(51),
                        valueColor: const AlwaysStoppedAnimation<Color>(quizgreen),
                      ),
                      const SizedBox(height: 12),
                      text('$percentage% Correct', textColor: quiztextColorPrimary, fontSize: 18, isCentered: true),
                      const SizedBox(height: 20),
                      // Bank scores breakdown
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: quizappbackground,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text(
                              'Rezultātu sadalījums:',
                              fontSize: 16,
                              fontFamily: fontBold,
                              textColor: quiztextColorPrimary,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text('Vieta 1 (Jaunā viela):', textColor: quiztextColorSecondary),
                                text('$bank1Score/7', fontFamily: fontBold, textColor: quizcolorPrimary),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text('Vieta 2 (Pielietojums):', textColor: quiztextColorSecondary),
                                text('$bank2Score/3', fontFamily: fontBold, textColor: quizcolorPrimary),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(
                  text: 'Back to Quiz List',
                  color: quizcolorPrimary,
                  textStyle: boldTextStyle(color: quizwhite),
                  onTap: () {
                    finish(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget quizCardSelection(var option, var option1, VoidCallback onPressed) {
  return InkWell(
    onTap: onPressed,
    child: Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: boxDecoration(showShadow: false, bgColor: quizeditbackground, radius: 10, color: quizviewcolor),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      width: 320,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Center(
            child: text(option1, textColor: quiztextColorSecondary),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: text(option, textColor: quiztextColorSecondary),
          )
        ],
      ),
    ),
  );
}
