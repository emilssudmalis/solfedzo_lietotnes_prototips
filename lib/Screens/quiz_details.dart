import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quiz/Screens/loading_screen.dart';
import 'package:quiz/model/quiz_models.dart';
import 'package:quiz/utils/app_widget.dart';
import 'package:quiz/utils/learning_service.dart';
import 'package:quiz/utils/quiz_colors.dart';
import 'package:quiz/utils/quiz_constant.dart';
import 'package:quiz/utils/quiz_strings.dart';
import 'package:quiz/utils/quiz_widget.dart';

class QuizDetails extends StatefulWidget {
  static String tag = '/QuizDetails';
  final Topic selectedTopic;

  const QuizDetails({super.key, required this.selectedTopic});

  @override
  _QuizDetailsState createState() => _QuizDetailsState();
}

class _QuizDetailsState extends State<QuizDetails> {
  late LearningService _service;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _service = LearningService();
    _service.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        _hasStarted = _service.hasStartedTopic(widget.selectedTopic.id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(quizappbackground);
    UserProgress progress = _service.getProgress(widget.selectedTopic.id);
    bool mastered = progress.mastered;

    return Scaffold(
      backgroundColor: quizappbackground,
      body: Column(
        children: <Widget>[
          const quizTopBar(quizlblbiologybasics),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  text(widget.selectedTopic.name,
                      isLongText: true,
                      fontFamily: fontBold,
                      isCentered: true,
                      fontSize: textSizeXLarge),
                  text(widget.selectedTopic.description, textColor: quiztextColorSecondary),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: boxDecoration(radius: 10, showShadow: true, bgColor: quizwhite),
                    padding: const EdgeInsets.all(16),
                    child: mastered
                        ? Column(
                            children: [
                              text('Šo tēmu esi apguvis!', fontFamily: fontBold),
                              const SizedBox(height: 10),
                              text('Tu vari atkārtot mācīšanos, lai nostiprinātu zināšanas.'),
                            ],
                          )
                        : Column(
                            children: [
                              text(_hasStarted ? 'Turpināt mācīšanos' : 'Sākt mācīšanos', fontFamily: fontBold),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoadingScreen(topic: widget.selectedTopic)),
                                  );
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: quizcolorSecondary),
                                child: text(_hasStarted ? 'Turpināt' : 'Sākt', textColor: white),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
