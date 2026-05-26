import 'package:flutter/material.dart';
import 'package:quiz/model/quiz_models.dart';
import 'package:quiz/Screens/theory_screen.dart';
import 'package:quiz/utils/quiz_colors.dart';
import 'dart:math';

class LoadingScreen extends StatefulWidget {
  final Topic topic;

  const LoadingScreen({super.key, required this.topic});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late String displayedFact;

  @override
  void initState() {
    super.initState();
    // Select random fact if multiple facts are available
    if (widget.topic.facts != null && widget.topic.facts!.isNotEmpty) {
      displayedFact = widget.topic.facts![Random().nextInt(widget.topic.facts!.length)];
    } else {
      displayedFact = widget.topic.fact;
    }
    // Simulate loading, then navigate to theory
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TheoryScreen(topic: widget.topic)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: quizcolorPrimary,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Interesants fakts:',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              SizedBox(height: 20),
              Text(
                displayedFact,
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              Text(
                'Sasniedzamais rezultāts:',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              SizedBox(height: 20),
              Text(
                widget.topic.goal,
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}