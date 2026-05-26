import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz/model/quiz_models.dart';
import 'package:quiz/Screens/adaptive_quiz_screen.dart';
import 'package:quiz/utils/quiz_colors.dart';

class TheoryScreen extends StatelessWidget {
  final Topic topic;

  const TheoryScreen({super.key, required this.topic});

  Widget _buildImage(String imagePath) {
    if (imagePath.endsWith('.svg')) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: SvgPicture.asset(
          imagePath,
          width: double.infinity,
          fit: BoxFit.contain,
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Image.asset(imagePath),
      );
    }
  }

  List<Widget> _buildTheoryContent() {
    final normalStyle = const TextStyle(fontSize: 16, height: 1.8, color: Colors.black);
    final headingStyle = const TextStyle(
      fontSize: 16,
      height: 1.8,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    final widgets = <Widget>[];
    final parts = topic.theoryText.split('[IMAGE_HERE]');

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].trim().isNotEmpty) {
        final lines = parts[i].split('\n');
        final textSpans = <TextSpan>[];

        for (var line in lines) {
          if (line.trim().isEmpty) {
            textSpans.add(const TextSpan(text: '\n'));
            continue;
          }

          final trimmed = line.trim();
          final isHeading = trimmed.isNotEmpty && 
                            trimmed == trimmed.toUpperCase() && 
                            trimmed.contains(RegExp(r'[A-ZĀČĒĢĪĶĻŅŠŪŽ]'));
          textSpans.add(TextSpan(
            text: '$line\n',
            style: isHeading ? headingStyle : normalStyle,
          ));
        }

        if (textSpans.isNotEmpty) {
          widgets.add(RichText(text: TextSpan(children: textSpans, style: normalStyle)));
          widgets.add(const SizedBox(height: 2));
        }
      }

      // Insert image after each part except the last
      if (i < parts.length - 1 && topic.theoryImages.isNotEmpty) {
        widgets.add(
          Center(
            child: Column(
              children: [
                _buildImage(topic.theoryImages[0]),
                const SizedBox(height: 8),
                const Text(
                  'Liela terca: Do - Mi',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
        widgets.add(const SizedBox(height: 2));
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${topic.name}: teorija'),
        backgroundColor: quizcolorPrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Teorija',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ..._buildTheoryContent(),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdaptiveQuizScreen(topic: topic)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: quizcolorAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Sākt testu',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}