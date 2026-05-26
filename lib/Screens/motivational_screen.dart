import 'package:flutter/material.dart';
import 'package:quiz/model/quiz_models.dart';
import 'package:quiz/Screens/quiz_dashboard.dart';
import 'package:quiz/utils/quiz_colors.dart';

class MotivationalScreen extends StatefulWidget {
  final Topic? topic;
  final bool didLevelUp;
  final bool isMastered;
  final bool justMastered;

  const MotivationalScreen({
    super.key,
    this.topic,
    this.didLevelUp = false,
    this.isMastered = false,
    this.justMastered = false,
  });

  @override
  _MotivationalScreenState createState() => _MotivationalScreenState();
}

class _MotivationalScreenState extends State<MotivationalScreen> {
  bool _popupShown = false;

  @override
  void initState() {
    super.initState();
    if (widget.justMastered) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showMasteryPopup();
      });
    }
  }

  Future<void> _showMasteryPopup() async {
    if (_popupShown || !mounted) return;
    _popupShown = true;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('🏆 Apsveicam!'),
          content: const Text('Esi ieguvis sasniegumu "Tercu meistars"!'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Labi'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String mainMessage = 'Lieliski paveikts!';
    String subMessage =
        'Izmantojiet iegūtās zināšanas ikdienas dzīvē un mūzikā.';

    if (widget.isMastered) {
      mainMessage = '🏆 Tēma apgūta!';
      subMessage =
          'Esi apguvis "${widget.topic?.name}". Tā tik turpini!';
    } else if (widget.didLevelUp) {
      mainMessage = '🎉 Esi sasniedzis nākamo līmeni!';
      subMessage = 'Tā tik turpini!';
    }

    return Scaffold(
      body: Container(
        color: quizcolorPrimary,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                mainMessage,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  subMessage,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuizDashboard(),
                    ),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: quizcolorPrimary,
                  minimumSize: const Size(200, 50),
                ),
                child: const Text('Atgriezties uz sākumu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}