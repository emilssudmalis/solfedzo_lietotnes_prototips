import 'package:flutter/material.dart';
import 'package:quiz/utils/quiz_colors.dart';
import 'package:quiz/services/piano_sound_service.dart';

/// Widget for validācijas uzdevums (validation task) using piano input
/// Students must press the correct notes to form an interval or chord
class PianoValidationWidget extends StatefulWidget {
  final String taskDescription; // e.g., "Nospiediet lielo tercu Do-Mi"
  final List<int> expectedNotes; // MIDI notes that should be pressed
  final int maxNotes; // How many notes should be pressed (e.g., 2 for interval)
  final Function(bool isCorrect, List<int> pressedNotes) onValidationComplete;
  final String? explanation;

  const PianoValidationWidget({
    Key? key,
    required this.taskDescription,
    required this.expectedNotes,
    required this.maxNotes,
    required this.onValidationComplete,
    this.explanation,
  }) : super(key: key);

  @override
  State<PianoValidationWidget> createState() => _PianoValidationWidgetState();
}

class _PianoValidationWidgetState extends State<PianoValidationWidget> {
  List<int> pressedNotes = [];
  bool isCorrect = false;
  bool submitted = false;
  late PianoSoundService _soundService;

  // Piano key layout: C3 to C5 (36 notes)
  static const List<String> noteNames = [
    'Do', 'Do#', 'Re', 'Mib', 'Mi', 'Fa', 'Fa#', 'Sol', 'Sol#', 'La', 'Sib', 'Si'
  ];

  @override
  void initState() {
    super.initState();
    _soundService = PianoSoundService();
    _soundService.initialize();
  }

  @override
  void dispose() {
    // Don't dispose the shared singleton service - it needs to persist for the lifetime of the app
    super.dispose();
  }

  String _getMidiNoteName(int midiNote) {
    int noteIndex = midiNote % 12;
    return noteNames[noteIndex];
  }

  // Generate piano keys for one octave (C to B)
  List<Map<String, dynamic>> _generatePianoKeys() {
    List<Map<String, dynamic>> keys = [];
    for (int i = 60; i <= 71; i++) {
      int noteIndex = i % 12;
      bool isBlackKey = [1, 3, 6, 8, 10].contains(noteIndex); // C#, D#, F#, G#, A#
      keys.add({
        'midiNote': i,
        'name': _getMidiNoteName(i),
        'isBlack': isBlackKey,
      });
    }
    return keys;
  }

  void _selectNote(int midiNote) {
    if (!submitted) {
      if (pressedNotes.contains(midiNote)) {
        // Remove the note if it's already selected (deselection)
        setState(() {
          pressedNotes.remove(midiNote);
        });
      } else if (pressedNotes.length < widget.maxNotes) {
        // Add the note if we haven't reached max
        setState(() {
          pressedNotes.add(midiNote);
        });
        // Play the corresponding piano note sound
        _soundService.playNote(midiNote);
      }
    }
  }

  void _clearSelection() {
    setState(() {
      pressedNotes.clear();
      submitted = false;
      isCorrect = false;
    });
  }

  void _submitSelection() {
    if (pressedNotes.length == widget.maxNotes) {
      // Compare note names (ignore octave) - just the note class (C, C#, D, etc.)
      List<int> sortedPressed = List.from(pressedNotes)..sort();
      List<int> sortedExpected = List.from(widget.expectedNotes)..sort();

      // Extract just the note class (0-11) for each note, ignoring octave
      List<int> pressedNoteClasses = sortedPressed.map((n) => n % 12).toList();
      List<int> expectedNoteClasses = sortedExpected.map((n) => n % 12).toList();

      // Check if pressed note classes match expected note classes
      bool correct = pressedNoteClasses.length == expectedNoteClasses.length &&
          pressedNoteClasses.asMap().entries.every((entry) => entry.value == expectedNoteClasses[entry.key]);

      // Debug print
      print('Pressed notes: $sortedPressed (note classes: $pressedNoteClasses)');
      print('Expected notes: $sortedExpected (note classes: $expectedNoteClasses)');
      print('Correct: $correct');

      setState(() {
        isCorrect = correct;
        submitted = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        widget.onValidationComplete(correct, pressedNotes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> pianoKeys = _generatePianoKeys();
    List<Map<String, dynamic>> whiteKeys = pianoKeys.where((k) => !k['isBlack']).toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task description
            Text(
              widget.taskDescription,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Instruction text
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: quizviewcolor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Izvēlies ${widget.maxNotes} taustiņus, bet spied tos pa vienam!',
                style: const TextStyle(
                  fontSize: 14,
                  color: quizcolorPrimary,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Display pressed notes
            if (pressedNotes.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tavas izvēlētās notis:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: pressedNotes.map((note) {
                      return Chip(
                        label: Text(_getMidiNoteName(note)),
                        backgroundColor: quizviewcolor,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),

            // Piano keyboard visualization with white and black keys
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: quiztextColorSecondary.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
                color: quiztextColorPrimary,
              ),
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: 164,
                  child: Stack(
                    children: [
                      // White keys row - centered vertically
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: whiteKeys.map((key) {
                          bool isPressed = pressedNotes.contains(key['midiNote']);
                          return GestureDetector(
                            onTap: () => _selectNote(key['midiNote']),
                            child: Container(
                              width: 45,
                              height: 140,
                              margin: const EdgeInsets.only(right: 1),
                              decoration: BoxDecoration(
                                color: isPressed ? quizcolorAccent.withOpacity(0.3) : quizwhite,
                                border: Border.all(color: quiztextColorPrimary.withOpacity(0.7), width: 1.5),
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: quizShadowColor,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (isPressed)
                                    Text(
                                      '${key['midiNote']}',
                                      style: TextStyle(
                                        fontSize: 7,
                                        color: quizcolorSecondary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        ),
                      ),
                      // Black keys overlay
                      ...pianoKeys.asMap().entries.where((e) => e.value['isBlack']).map((entry) {
                        int index = entry.key;
                        var key = entry.value;
                        bool isPressed = pressedNotes.contains(key['midiNote']);
                        
                        // Calculate position based on white key layout
                        // Black keys are positioned between white keys
                        int whiteKeysBefore = pianoKeys.take(index).where((k) => !k['isBlack']).length;
                        double leftOffset = (whiteKeysBefore * 46) - 8;
                        
                        return Positioned(
                          left: leftOffset,
                          top: 12,
                          child: GestureDetector(
                            onTap: () => _selectNote(key['midiNote']),
                            child: Container(
                              width: 32,
                              height: 90,
                              decoration: BoxDecoration(
                                color: isPressed ? quizcolorAccent.withOpacity(0.3) : quiztextColorPrimary,
                                border: Border.all(color: quiztextColorPrimary, width: 1),
                                borderRadius: BorderRadius.circular(3),
                                boxShadow: [
                                  BoxShadow(
                                    color: quizShadowColor,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Result message
            if (submitted)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isCorrect ? quizcolorSecondary.withOpacity(0.15) : quizcolorred.withOpacity(0.15),
                  border: Border.all(
                    color: isCorrect ? quizcolorSecondary : quizcolorred,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCorrect ? '✓ Pareizi!' : '✗ Nepareizi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isCorrect ? quizcolorSecondary : quizcolorred,
                      ),
                    ),
                    if (widget.explanation != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.explanation!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: pressedNotes.isEmpty
                      ? null
                      : () {
                          _clearSelection();
                        },
                  icon: const Icon(Icons.close),
                  label: const Text('Notīrīt'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: quizcolorAccent,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: pressedNotes.length == widget.maxNotes && !submitted
                      ? () {
                          _submitSelection();
                        }
                      : null,
                  icon: const Icon(Icons.check),
                  label: const Text('Iesniegt'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: quizcolorPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
