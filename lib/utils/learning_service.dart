import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz/model/quiz_models.dart';

class LearningService {
  static const String _progressKey = 'user_progress';
  static const String _sessionsKey = 'sessions';
  static const String _sessionStateKey = 'session_state';
  static const String _sessionShownKey =
      'session_shown_questions'; // Legacy key for backward compatibility

  List<Topic> topics = [];
  List<Question> questions = [];
  Map<String, UserProgress> userProgress = {};
  List<SessionResult> sessions = [];

  LearningService() {
    _initializeData();
  }

  Future<void> initialize() async {
    await _loadProgress();
    await _loadSessionState();
  }

  /// Convert MIDI note number to Latvian note name
  static String midiToNoteName(int midiNumber) {
    const Map<int, String> noteNames = {
      60: 'Do',
      61: 'Do#',
      62: 'Re',
      63: 'Re#',
      64: 'Mi',
      65: 'Fa',
      66: 'Fa#',
      67: 'Sol',
      68: 'Sol#',
      69: 'La',
      70: 'La#',
      71: 'Si',
      72: 'Do',
      73: 'Do#',
      74: 'Re',
      75: 'Re#',
      76: 'Mi',
      77: 'Fa',
      78: 'Fa#',
      79: 'Sol',
      80: 'Sol#',
      81: 'La',
      82: 'La#',
      83: 'Si',
    };
    return noteNames[midiNumber] ?? 'Nezināma nots ($midiNumber)';
  }

  /// Convert list of MIDI numbers to note names
  static List<String> midiListToNoteNames(List<int> midiNumbers) {
    return midiNumbers.map((midi) => midiToNoteName(midi)).toList();
  }

  void _initializeData() {
    // Sample topics
    topics = [
      Topic(
        id: 'intervals_tercas',
        name: 'Tercas',
        description: 'Apgūsim lielas un mazas tercas!',
        image: 'assets/images/quiz/tercas.jpg',
        fact: 'Terces ir pamats harmonijai mūzikā.',
        goal: 'Pareizi identificēt lielo un mazo tercu intervālus.',
        theoryText:
            'Liela terca ir intervāls starp divām notīm, kas ir 4 pustoņus attālinātas. Mazā terca ir 3 pustoņi.',
        theoryImages: [
          'assets/images/theory/terca_large.png',
          'assets/images/theory/terca_small.png'
        ],
        categories: ['intervals'],
      ),
      Topic(
        id: 'intervals_kvartas',
        name: 'Kvartas',
        description: 'Apgūsim tīras un palielinātas kvartas!',
        image: 'assets/images/quiz/kvartas.jpg',
        fact:
            'Teksts.',
        goal: 'Pareizi identificēt tīru un palielinātu kvartu intervālus.',
        theoryText:
            'Teksts.',
        theoryImages: [],
        categories: ['intervals'],
      ),
      Topic(
        id: 'intervals_kvintas',
        name: 'Kvintas',
        description: 'Apgūsim tīras un pamazinātas kvintas!',
        image: 'assets/images/quiz/kvintas.jpg',
        fact:
            'Teksts.',
        goal: 'Pareizi identificēt tīru un pamazinātu kvintu intervālus.',
        theoryText:
            'Teksts.',
        theoryImages: [],
        categories: ['intervals'],
      ),
      Topic(
        id: 'intervals_sekstas',
        name: 'Sekstas',
        description: 'Apgūsim lielas un mazas sekstas!',
        image: 'assets/images/quiz/sekstas.jpg',
        fact:
            'Teksts.',
        goal: 'Pareizi identificēt lielu un mazu sekstu intervālus.',
        theoryText:
            'LTeksts.',
        theoryImages: [],
        categories: ['intervals'],
      ),
    ];

    // Bank 1 (Consolidating new information) - Difficulty 1
    questions.addAll([
      Question(
        id: 'tercas_b1_l1_q1',
        topicId: 'intervals_tercas',
        text: 'Cik pustoņu ir lielā tercā?',
        options: ['3 pustoņi', '4 pustoņi', '2 pustoņi', '5 pustoņi'],
        correctIndex: 1,
        difficulty: 1,
        explanation: 'Liela terca ir intervāls ar 4 pustoņiem.',
        category: 'bank1',
      ),
      Question(
        id: 'tercas_b1_l1_q2',
        topicId: 'intervals_tercas',
        text: 'Cik pustoņu ir mazā tercā?',
        options: ['2 pustoņi', '3 pustoņi', '1 pustonis', '4 pustoņi'],
        correctIndex: 1,
        difficulty: 1,
        explanation: 'Mazā terca ir intervāls ar 3 pustoņiem.',
        category: 'bank1',
      ),
      Question(
        id: 'tercas_b1_l1_q3',
        topicId: 'intervals_tercas',
        text: 'Kāds intervāls veidojas starp notīm Do un Mi?',
        options: [
          'Maza terca',
          'Liela terca',
          'Tīra kvarta',
          'Palielināta kvarta'
        ],
        correctIndex: 1,
        difficulty: 1,
        explanation: 'Starp Do un Mi ir liela terca (4 pustoņi).',
        category: 'bank1',
      ),
      Question(
        id: 'tercas_b1_l1_q4',
        topicId: 'intervals_tercas',
        text: 'Kāds intervāls veidojas starp notīm Re un Fa?',
        options: [
          'Maza terca',
          'Liela terca',
          'Tīra kvarta',
          'Palielināta kvarta'
        ],
        correctIndex: 0,
        difficulty: 1,
        explanation: 'Starp Re un Fa ir maza terca (3 pustoņi).',
        category: 'bank1',
      ),
      Question(
        id: 'tercas_b1_l1_q5',
        topicId: 'intervals_tercas',
        text: 'Kādu pakāpi attiecībā pret pamatni veido tercas virsotne?',
        options: [
          'Trešo pakāpi',
          'Ceturto pakāpi',
          'Piekto pakāpi',
          'Otro pakāpi'
        ],
        correctIndex: 0,
        difficulty: 1,
        explanation:
            'Tercas virsotne atrodas trešajā pakāpē attiecībā pret pamatni.',
        category: 'bank1',
      ),
    ]);

    // Bank 1 (Consolidating new information) - Difficulty 2
    questions.addAll([
      Question(
        id: 'tercas_b1_l2_q1',
        topicId: 'intervals_tercas',
        text: 'Kā mūzikā apzīmē mazu tercu?',
        options: ['m3', 'M3', 't3', 'T3'],
        correctIndex: 0,
        difficulty: 2,
        explanation: 'Maza terca mūzikā tiek apzīmēta ar m3.',
        category: 'bank1',
      ),
      Question(
        id: 'tercas_b1_l2_q2',
        topicId: 'intervals_tercas',
        text: 'Kā mūzikā apzīmē lielu tercu?',
        options: ['m3', 'L3', 't3', 'T3'],
        correctIndex: 1,
        difficulty: 2,
        explanation: 'Liela terca mūzikā tiek apzīmēta ar L3.',
        category: 'bank1',
      ),
      Question(
        id: 'tercas_b1_l2_q3',
        topicId: 'intervals_tercas',
        text: 'Kura no šīm ir maza terca?',
        options: ['Do - Mi', 'Do - Re', 'Re - Fa', 'La - Do#'],
        correctIndex: 2,
        difficulty: 2,
        explanation: 'Re - Fa ir maza terca (3 pustoņi).',
        category: 'bank1',
      ),
      Question(
        id: 'tercas_b1_l2_q4',
        topicId: 'intervals_tercas',
        text: 'Kura no šīm ir liela terca?',
        options: ['Do - Mi', 'Do - Re', 'Mi - Sol', 'Do - Fa'],
        correctIndex: 0,
        difficulty: 2,
        explanation: 'Do - Mi ir liela terca (4 pustoņi).',
        category: 'bank1',
      ),
      Question(
        id: 'tercas_b1_l2_q5',
        topicId: 'intervals_tercas',
        text: 'Mazā tercā starp notīm Do un Mib ir:',
        options: ['1.5 toņi', '2 toņi', '2.5 toņi', '3 toņi'],
        correctIndex: 0,
        difficulty: 2,
        explanation: 'Maza terca = 3 pustoņi = 1.5 toņi.',
        category: 'bank1',
      ),
    ]);

    // Bank 1 (Consolidating new information) - Difficulty 3
    questions.addAll([
      Question(
        id: 'tercas_b1_l3_q1',
        topicId: 'intervals_tercas',
        text: 'Starp notīm Mi un Sol ir:',
        options: ['Maza terca', 'Liela terca', 'Kvarta', 'Sekunda'],
        correctIndex: 0,
        difficulty: 3,
        explanation: 'Starp Mi un Sol ir maza terca (3 pustoņi).',
        category: 'bank1',
      ),
      Question(
        id: 'tercas_b1_l3_q2',
        topicId: 'intervals_tercas',
        text: 'Paralēlās tercas aprēķina no:',
        options: [
          'Pirmās pakāpes',
          'Otrās pakāpes',
          'Trešās pakāpes',
          'Ceturtās pakāpes'
        ],
        correctIndex: 2,
        difficulty: 3,
        explanation:
            'Paralēlā terca atrodas uz 6 pakāpēm augstāk, t.i., no trešās pakāpes.',
        category: 'bank1',
      ),
      Question(
        id: 'tercas_b1_l3_q3',
        topicId: 'intervals_tercas',
        text: 'Tercas pārvēršana paralēlajā ir iespējama:',
        options: [
          'Tikai augšup',
          'Tikai lejup',
          'Abos virzienos',
          'Nav iespējama'
        ],
        correctIndex: 2,
        difficulty: 3,
        explanation: 'Tercas var pārveidot paralēlajā gan augšup, gan lejup.',
        category: 'bank1',
      ),
      Question(
        id: 'tercas_b1_l3_q4',
        topicId: 'intervals_tercas',
        text: 'Mazā terca atbilst intervālam:',
        options: ['3 pustoņi', '4 pustoņi', '2 pustoņi', '5 pustoņi'],
        correctIndex: 0,
        difficulty: 3,
        explanation: 'Mazā terca = 3 pustoņi.',
        category: 'bank1',
      ),
      Question(
        id: 'tercas_b1_l3_q5',
        topicId: 'intervals_tercas',
        text: 'Liela terca atbilst intervālam:',
        options: ['3 pustoņi', '4 pustoņi', '5 pustoņi', '2 pustoņi'],
        correctIndex: 1,
        difficulty: 3,
        explanation: 'Liela terca = 4 pustoņi.',
        category: 'bank1',
      ),
    ]);

    // Bank 2 (Applying learned material) - Difficulty 1
    questions.addAll([
      Question(
        id: 'tercas_b2_l1_q1',
        topicId: 'intervals_tercas',
        text: 'Kurš no šiem intervāliem ir vislielākais?',
        options: ['Liela sekunda', 'Liela terca', 'Tīra kvarta', 'Tīra kvinta'],
        correctIndex: 3,
        difficulty: 4,
        explanation: 'Tīra kvinta (7 pustoņi) ir vislielākais intervāls. Liela sekunda ir 2 pustoņi, liela terca ir 4 pustoņi, tīra kvarta ir 5 pustoņi.',
        category: 'bank2',
      ),
      Question(
        id: 'tercas_b2_l1_q2',
        topicId: 'intervals_tercas',
        text: 'Mažora trijskaņa apakšā vienmēr ir:',
        options: ['Liela terca', 'Maza terca', 'Tīra kvarta', 'Tīra oktāva'],
        correctIndex: 0,
        difficulty: 4,
        explanation: 'Mažora trijskaņa apakšā vienmēr atrodas liela terca (Do mažorā: Do-Mi-Sol).',
        category: 'bank2',
      ),
      Question(
        id: 'tercas_b2_l1_q3',
        topicId: 'intervals_tercas',
        text: 'Minora trijskaņa apakšā vienmēr ir:',
        options: ['Maza terca', 'Liela terca', 'Maza septīma', 'Liela sekunda'],
        correctIndex: 0,
        difficulty: 4,
        explanation: 'Minora trijskaņa apakšā vienmēr atrodas maza terca (la minorā: la-do-mi).',
        category: 'bank2',
      ),
      Question(
        id: 'tercas_b2_l1_q4',
        topicId: 'intervals_tercas',
        text: 'Kurš no šiem intervāliem ir vismazākais?',
        options: ['Tīra kvinta', 'Palielināta kvarta', 'Maza terca', 'Liela sekunda'],
        correctIndex: 3,
        difficulty: 4,
        explanation: 'Liela sekunda (2 pustoņi) ir mazākais intervāls no piedāvātajiem. Maza terca ir 3 pustoņi, tīra kvarta ir 5 pustoņi, tīra kvinta ir 7 pustoņi.',
        category: 'bank2',
      ),
      Question(
        id: 'tercas_b2_l1_q5',
        topicId: 'intervals_tercas',
        text: 'Liela terca atšķiras no tīras kvartas par:',
        options: ['1 pustoni', '2 pustoņiem', 'oktāvu', '3 pustoņiem'],
        correctIndex: 0,
        difficulty: 4,
        explanation: 'Liela terca atšķiras no tīras kvartas par 1 pustoni. Liela terca ir 4 pustoņi, tīra kvarta ir 5 pustoņi.',
        category: 'bank2',
      ),
    ]);

    // Bank 2 (Applying learned material) - Difficulty 2
    questions.addAll([
      Question(
        id: 'tercas_b2_l2_q1',
        topicId: 'intervals_tercas',
        text: 'Kādi intervāli veido Do mažora trijskani?',
        options: [
          'Liela terca + tīra kvinta',
          'Liela terca + tīra kvarta',
          'Maza terca + liela terca',
          'Liela terca + maza terca'
        ],
        correctIndex: 3,
        difficulty: 5,
        explanation: 'Do mažora trijskaņa (Do-Mi-Sol) apakšā ir liela terca (Do-Mi), virs kuras ir maza terca (Mi-Sol).',
        category: 'bank2',
      ),
      Question(
        id: 'tercas_b2_l2_q2',
        topicId: 'intervals_tercas',
        text: 'Kādi intervāli veido la minora trijskani?',
        options: [
          'Maza terca + tīra kvinta',
          'Liela terca + maza terca',
          'Maza terca + liela terca',
          'Maza terca + maza terca'
        ],
        correctIndex: 2,
        difficulty: 5,
        explanation: 'La minora trijskaņa (la-do-mi) apakšā ir maza terca (la-do), virs kuras ir liela terca (do-mi).',
        category: 'bank2',
      ),
      Question(
        id: 'tercas_b2_l2_q3',
        topicId: 'intervals_tercas',
        text: 'Re mažora trijskaņa virsotne ir:',
        options: ['La', 'Fa#', 'Mi', 'Re'],
        correctIndex: 0,
        difficulty: 5,
        explanation: 'Re mažora trijskaņa (Re-Fa#-La) virsotne ir La.',
        category: 'bank2',
      ),
    ]);

    // Kvartas - Bank 1 (Consolidating new information) - Difficulty 1
    questions.addAll([
      Question(
        id: 'kvartas_b1_l1_q1',
        topicId: 'intervals_kvartas',
        text: 'Cik pustoņu ir tīrā kvartā?',
        options: ['5 pustoņi', '4 pustoņi', '6 pustoņi', '7 pustoņi'],
        correctIndex: 0,
        difficulty: 1,
        explanation: 'Tīra kvarta ir intervāls ar 5 pustoņiem.',
        category: 'bank1',
      ),
      Question(
        id: 'kvartas_b1_l1_q2',
        topicId: 'intervals_kvartas',
        text: 'Kāds intervāls veidojas starp notīm Do un Fa?',
        options: [
          'Tīra kvarta',
          'Palielināta kvarta',
          'Tīra kvinta',
          'Palielināta kvinta'
        ],
        correctIndex: 0,
        difficulty: 1,
        explanation: 'Starp Do un Fa ir tīra kvarta (5 pustoņi).',
        category: 'bank1',
      ),
      Question(
        id: 'kvartas_b1_l1_q3',
        topicId: 'intervals_kvartas',
        text: 'Kvartā ir notis apmēram:',
        options: [
          '4 pakāpes attālumā',
          '5 pakāpes attālumā',
          '3 pakāpes attālumā',
          '6 pakāpes attālumā'
        ],
        correctIndex: 0,
        difficulty: 1,
        explanation: 'Kvarta ir 4 pakāpes attālumā (no pirmās uz ceturto).',
        category: 'bank1',
      ),
      Question(
        id: 'kvartas_b1_l1_q4',
        topicId: 'intervals_kvartas',
        text: 'Re un Sol intervāls ir:',
        options: ['Tīra kvarta', 'Liela tercā', 'Maza tercā', 'Sekunda'],
        correctIndex: 0,
        difficulty: 1,
        explanation: 'Starp Re un Sol ir tīra kvarta.',
        category: 'bank1',
      ),
      Question(
        id: 'kvartas_b1_l1_q5',
        topicId: 'intervals_kvartas',
        text: 'Kādu pakāpi attiecībā pret pamatni veido kvartas virsotne?',
        options: [
          'Ceturto pakāpi',
          'Trešo pakāpi',
          'Piekto pakāpi',
          'Otro pakāpi'
        ],
        correctIndex: 0,
        difficulty: 1,
        explanation:
            'Kvartas virsotne atrodas ceturtajā pakāpē attiecībā pret pamatni.',
        category: 'bank1',
      ),
    ]);

    // Kvartas - Bank 1 (Consolidating new information) - Difficulty 2
    questions.addAll([
      Question(
        id: 'kvartas_b1_l2_q1',
        topicId: 'intervals_kvartas',
        text: 'Kā mūzikā apzīmē tīro kvartu?',
        options: ['P4', 'q4', 'k4', 'K4'],
        correctIndex: 0,
        difficulty: 2,
        explanation: 'Tīra kvarta mūzikā tiek apzīmēta ar P4.',
        category: 'bank1',
      ),
      Question(
        id: 'kvartas_b1_l2_q2',
        topicId: 'intervals_kvartas',
        text: 'Kā mūzikā apzīmē palieleināto kvartu?',
        options: ['P4+', 'A4', '+4', 'aug4'],
        correctIndex: 0,
        difficulty: 2,
        explanation: 'Palielināta kvarta mūzikā tiek apzīmēta ar P4+ vai aug4.',
        category: 'bank1',
      ),
      Question(
        id: 'kvartas_b1_l2_q3',
        topicId: 'intervals_kvartas',
        text: 'Kura no šīm ir tīra kvarta?',
        options: ['Do - Fa', 'Do - Sol', 'Re - Si', 'Mi - La'],
        correctIndex: 0,
        difficulty: 2,
        explanation: 'Do - Fa ir tīra kvarta (5 pustoņi).',
        category: 'bank1',
      ),
      Question(
        id: 'kvartas_b1_l2_q4',
        topicId: 'intervals_kvartas',
        text: 'Kvarta starp notīm Fa un Si ir:',
        options: ['Palielināta', 'Tīra', 'Samazināta', 'Dubultā'],
        correctIndex: 0,
        difficulty: 2,
        explanation: 'Fa-Si ir palielināta kvarta (6 pustoņi).',
        category: 'bank1',
      ),
      Question(
        id: 'kvartas_b1_l2_q5',
        topicId: 'intervals_kvartas',
        text: 'Tīrā kvartā starp notīm Do un Fa ir:',
        options: ['2.5 toņi', '3 toņi', '2 toņi', '3.5 toņi'],
        correctIndex: 0,
        difficulty: 2,
        explanation: 'Tīra kvarta = 5 pustoņi = 2.5 toņi.',
        category: 'bank1',
      ),
    ]);

    // Kvartas - Bank 1 (Consolidating new information) - Difficulty 3
    questions.addAll([
      Question(
        id: 'kvartas_b1_l3_q1',
        topicId: 'intervals_kvartas',
        text: 'Starp notīm Sol un Do ir:',
        options: [
          'Tīra kvarta',
          'Palielināta kvarta',
          'Tīra kvinta',
          'Secunda'
        ],
        correctIndex: 0,
        difficulty: 3,
        explanation: 'Starp Sol un Do ir tīra kvarta (5 pustoņi).',
        category: 'bank1',
      ),
      Question(
        id: 'kvartas_b1_l3_q2',
        topicId: 'intervals_kvartas',
        text: 'Paralēlās kvartas aprēķina no:',
        options: [
          'Pirmās pakāpes',
          'Otrās pakāpes',
          'Ceturtās pakāpes',
          'Piektās pakāpes'
        ],
        correctIndex: 2,
        difficulty: 3,
        explanation: 'Paralēlā kvarta atrodas uz 8 pakāpēm augstāk.',
        category: 'bank1',
      ),
      Question(
        id: 'kvartas_b1_l3_q3',
        topicId: 'intervals_kvartas',
        text: 'Kvartas pārvēršana paralēlajā ir:',
        options: [
          'Tikai augšup',
          'Tikai lejup',
          'Abos virzienos',
          'Nav iespējama'
        ],
        correctIndex: 2,
        difficulty: 3,
        explanation: 'Kvartas var pārveidot paralēlajā gan augšup, gan lejup.',
        category: 'bank1',
      ),
      Question(
        id: 'kvartas_b1_l3_q4',
        topicId: 'intervals_kvartas',
        text: 'Tīra kvarta atbilst intervālam:',
        options: ['5 pustoņi', '4 pustoņi', '6 pustoņi', '7 pustoņi'],
        correctIndex: 0,
        difficulty: 3,
        explanation: 'Tīra kvarta = 5 pustoņi.',
        category: 'bank1',
      ),
      Question(
        id: 'kvartas_b1_l3_q5',
        topicId: 'intervals_kvartas',
        text: 'Palielināta kvarta atbilst intervālam:',
        options: ['6 pustoņi', '5 pustoņi', '7 pustoņi', '4 pustoņi'],
        correctIndex: 0,
        difficulty: 3,
        explanation: 'Palielināta kvarta = 6 pustoņi.',
        category: 'bank1',
      ),
    ]);

    // Kvartas - Bank 2 (Applying learned material) - Difficulty 1
    questions.addAll([
      Question(
        id: 'kvartas_b2_l1_q1',
        topicId: 'intervals_kvartas',
        text: 'Kvartas un tercas atšķirība pustoņos ir:',
        options: ['1 pustonis', '2 pustoņi', '3 pustoņi', '4 pustoņi'],
        correctIndex: 0,
        difficulty: 4,
        explanation: 'Liela terca ir 4 pustoņi, tīra kvarta ir 5 pustoņi. Atšķirība ir 1 pustonis.',
        category: 'bank2',
      ),
      Question(
        id: 'kvartas_b2_l1_q2',
        topicId: 'intervals_kvartas',
        text: 'Kurš no šiem intervāliem ir jūtami lielāks par kvartu?',
        options: ['Terca', 'Sekunda', 'Kvinta', 'Seksta'],
        correctIndex: 2,
        difficulty: 4,
        explanation: 'Kvinta (7 pustoņi) ir lielāka par kvartu (5 pustoņi). Terca un sekunda ir mazākas, seksta ir daudz lielāka.',
        category: 'bank2',
      ),
      Question(
        id: 'kvartas_b2_l1_q3',
        topicId: 'intervals_kvartas',
        text: 'Fa tīrā kvarta augšā nots ir:',
        options: ['Si', 'Sol', 'La', 'Do'],
        correctIndex: 0,
        difficulty: 4,
        explanation: 'Tīra kvarta virs Fa (65) ir Si (71) - attālums 5 pustoņi.',
        category: 'bank2',
      ),
    ]);

    // Kvartas - Bank 2 (Applying learned material) - Difficulty 2
    questions.addAll([
      Question(
        id: 'kvartas_b2_l2_q1',
        topicId: 'intervals_kvartas',
        text: 'Akordā vienmēr ir:',
        options: [
          'Vismaz tīra kvinta virs saknes',
          'Vismaz tīra kvarta',
          'Vismaz liela terca',
          'Vismaz sekunda'
        ],
        correctIndex: 0,
        difficulty: 5,
        explanation: 'Klasiskajā tritonāli akordā (mažora vai mazora) vienmēr ir tīra kvinta virs saknes. Tas ir kopā ar tercu (liela vai maza).',
        category: 'bank2',
      ),
      Question(
        id: 'kvartas_b2_l2_q2',
        topicId: 'intervals_kvartas',
        text: 'Kvarta atšķiras no kvintas ar:',
        options: ['1 pustoņa', '2 pustoņiem', '3 pustoņiem', '4 pustoņiem'],
        correctIndex: 1,
        difficulty: 5,
        explanation: 'Tīra kvarta ir 5 pustoņi, tīra kvinta ir 7 pustoņi. Atšķirība ir 2 pustoņi.',
        category: 'bank2',
      ),
      Question(
        id: 'kvartas_b2_l2_q3',
        topicId: 'intervals_kvartas',
        text: 'Mažora trijskaņa apakšējo intervālu (starp sakni un kundzi) veido:',
        options: ['Liela terca', 'Tīra kvarta', 'Maza terca', 'Tīra kvinta'],
        correctIndex: 0,
        difficulty: 5,
        explanation: 'Mažora trijskaņu (Do-Mi-Sol) apakšējo intervālu starp Do un Mi veido liela terca.',
        category: 'bank2',
      ),
    ]);

    // Kvintas - Bank 1 (Consolidating new information) - Difficulty 1
    questions.addAll([
      Question(
        id: 'kvintas_b1_l1_q1',
        topicId: 'intervals_kvintas',
        text: 'Cik pustoņu ir tīrā kvintā?',
        options: ['7 pustoņi', '5 pustoņi', '6 pustoņi', '8 pustoņi'],
        correctIndex: 0,
        difficulty: 1,
        explanation: 'Tīra kvinta ir intervāls ar 7 pustoņiem.',
        category: 'bank1',
      ),
      Question(
        id: 'kvintas_b1_l1_q2',
        topicId: 'intervals_kvintas',
        text: 'Kāds intervāls veidojas starp notīm Do un Sol?',
        options: [
          'Tīra kvinta',
          'Samazināta kvinta',
          'Palielināta kvinta',
          'Tīra kvarta'
        ],
        correctIndex: 0,
        difficulty: 1,
        explanation: 'Starp Do un Sol ir tīra kvinta (7 pustoņi).',
        category: 'bank1',
      ),
      Question(
        id: 'kvintas_b1_l1_q3',
        topicId: 'intervals_kvintas',
        text: 'Kvintā ir notis apmēram:',
        options: [
          '5 pakāpes attālumā',
          '4 pakāpes attālumā',
          '6 pakāpes attālumā',
          '3 pakāpes attālumā'
        ],
        correctIndex: 0,
        difficulty: 1,
        explanation: 'Kvinta ir 5 pakāpes attālumā (no pirmās uz piekto).',
        category: 'bank1',
      ),
      Question(
        id: 'kvintas_b1_l1_q4',
        topicId: 'intervals_kvintas',
        text: 'Re un La intervāls ir:',
        options: ['Tīra kvinta', 'Tīra kvarta', 'Maza tercā', 'Liela tercā'],
        correctIndex: 0,
        difficulty: 1,
        explanation: 'Starp Re un La ir tīra kvinta.',
        category: 'bank1',
      ),
      Question(
        id: 'kvintas_b1_l1_q5',
        topicId: 'intervals_kvintas',
        text: 'Kādu pakāpi attiecībā pret pamatni veido kvintas virsotne?',
        options: [
          'Piekto pakāpi',
          'Ceturto pakāpi',
          'Trešo pakāpi',
          'Sesto pakāpi'
        ],
        correctIndex: 0,
        difficulty: 1,
        explanation:
            'Kvintas virsotne atrodas piektajā pakāpē attiecībā pret pamatni.',
        category: 'bank1',
      ),
    ]);

    // Kvintas - Bank 1 (Consolidating new information) - Difficulty 2
    questions.addAll([
      Question(
        id: 'kvintas_b1_l2_q1',
        topicId: 'intervals_kvintas',
        text: 'Kā mūzikā apzīmē tīro kvintu?',
        options: ['P5', 'q5', 'k5', 'K5'],
        correctIndex: 0,
        difficulty: 2,
        explanation: 'Tīra kvinta mūzikā tiek apzīmēta ar P5.',
        category: 'bank1',
      ),
      Question(
        id: 'kvintas_b1_l2_q2',
        topicId: 'intervals_kvintas',
        text: 'Kā mūzikā apzīmē samazināto kvintu?',
        options: ['P5-', 'D5', '-5', 'dim5'],
        correctIndex: 0,
        difficulty: 2,
        explanation: 'Samazināta kvinta mūzikā tiek apzīmēta ar P5- vai dim5.',
        category: 'bank1',
      ),
      Question(
        id: 'kvintas_b1_l2_q3',
        topicId: 'intervals_kvintas',
        text: 'Kura no šīm ir tīra kvinta?',
        options: ['Do - Sol', 'Do - Fa', 'Re - La', 'Do - Re'],
        correctIndex: 0,
        difficulty: 2,
        explanation: 'Do - Sol ir tīra kvinta (7 pustoņi).',
        category: 'bank1',
      ),
      Question(
        id: 'kvintas_b1_l2_q4',
        topicId: 'intervals_kvintas',
        text: 'Kvinta starp notīm Sol un Re ir:',
        options: ['Tīra', 'Samazināta', 'Palielināta', 'Dubultā'],
        correctIndex: 0,
        difficulty: 2,
        explanation: 'Sol-Re ir tīra kvinta (7 pustoņi).',
        category: 'bank1',
      ),
      Question(
        id: 'kvintas_b1_l2_q5',
        topicId: 'intervals_kvintas',
        text: 'Tīrā kvintā starp notīm Do un Sol ir:',
        options: ['3.5 toņi', '4 toņi', '3 toņi', '4.5 toņi'],
        correctIndex: 0,
        difficulty: 2,
        explanation: 'Tīra kvinta = 7 pustoņi = 3.5 toņi.',
        category: 'bank1',
      ),
    ]);

    // Kvintas - Bank 1 (Consolidating new information) - Difficulty 3
    questions.addAll([
      Question(
        id: 'kvintas_b1_l3_q1',
        topicId: 'intervals_kvintas',
        text: 'Starp notīm Fa un Do ir:',
        options: ['Tīra kvinta', 'Samazināta kvinta', 'Tīra kvarta', 'Sekunda'],
        correctIndex: 0,
        difficulty: 3,
        explanation: 'Starp Fa un Do ir tīra kvinta (7 pustoņi).',
        category: 'bank1',
      ),
      Question(
        id: 'kvintas_b1_l3_q2',
        topicId: 'intervals_kvintas',
        text: 'Paralēlās kvintas aprēķina no:',
        options: [
          'Pirmās pakāpes',
          'Piektās pakāpes',
          'Ceturtās pakāpes',
          'Otrās pakāpes'
        ],
        correctIndex: 1,
        difficulty: 3,
        explanation: 'Paralēlā kvinta atrodas uz 12 pakāpēm augstāk.',
        category: 'bank1',
      ),
      Question(
        id: 'kvintas_b1_l3_q3',
        topicId: 'intervals_kvintas',
        text: 'Kvintas pārvēršana paralēlajā ir:',
        options: [
          'Tikai augšup',
          'Tikai lejup',
          'Abos virzienos',
          'Nav iespējama'
        ],
        correctIndex: 2,
        difficulty: 3,
        explanation: 'Kvintas var pārveidot paralēlajā gan augšup, gan lejup.',
        category: 'bank1',
      ),
      Question(
        id: 'kvintas_b1_l3_q4',
        topicId: 'intervals_kvintas',
        text: 'Tīra kvinta atbilst intervālam:',
        options: ['7 pustoņi', '5 pustoņi', '6 pustoņi', '8 pustoņi'],
        correctIndex: 0,
        difficulty: 3,
        explanation: 'Tīra kvinta = 7 pustoņi.',
        category: 'bank1',
      ),
      Question(
        id: 'kvintas_b1_l3_q5',
        topicId: 'intervals_kvintas',
        text: 'Samazināta kvinta atbilst intervālam:',
        options: ['6 pustoņi', '7 pustoņi', '5 pustoņi', '8 pustoņi'],
        correctIndex: 0,
        difficulty: 3,
        explanation: 'Samazināta kvinta = 6 pustoņi.',
        category: 'bank1',
      ),
    ]);

    // Kvintas - Bank 2 (Applying learned material) - Difficulty 1
    questions.addAll([
      Question(
        id: 'kvintas_b2_l1_q1',
        topicId: 'intervals_kvintas',
        text: 'Kurš no šiem intervāliem ir stabilākais un skaidrākais?',
        options: ['Sekunda', 'Terca', 'Kvinta', 'Seksta'],
        correctIndex: 2,
        difficulty: 4,
        explanation: 'Tīra kvinta ir viens no stabilākajiem un skaidrākajiem intervāliem mūzikā. To izmanto harmonijā un akordos.',
        category: 'bank2',
      ),
      Question(
        id: 'kvintas_b2_l1_q2',
        topicId: 'intervals_kvintas',
        text: 'Mažora trijskaņa virsotne atrodas intervālā:',
        options: [
          'Tīra kvinta virs saknes',
          'Tīra kvarta virs saknes',
          'Liela terca virs saknes',
          'Tīra septima virs saknes'
        ],
        correctIndex: 0,
        difficulty: 4,
        explanation: 'Mažora trijskaņas virsotne (Do mažor: Sol) atrodas tīras kvintas attālumā (7 pustoņi) virs saknes (Do).',
        category: 'bank2',
      ),
      Question(
        id: 'kvintas_b2_l1_q3',
        topicId: 'intervals_kvintas',
        text: 'Kvinta ir lielāka par:',
        options: ['Oktāvu', 'Sekstu', 'Tercu', 'Devīto'],
        correctIndex: 2,
        difficulty: 4,
        explanation: 'Kvinta (7 pustoņi) ir lielāka par tercu (4 pustoņi), bet mazāka par sekstu (8-9 pustoņi) un devīto (13 pustoņi).',
        category: 'bank2',
      ),
    ]);

    // Kvintas - Bank 2 (Applying learned material) - Difficulty 2
    questions.addAll([
      Question(
        id: 'kvintas_b2_l2_q1',
        topicId: 'intervals_kvintas',
        text: 'Kādi divi intervāli kopā veido trijskaņu (3. likums)?',
        options: [
          'Terca un kvarta (no terces virsotnes)',
          'Sekunda un seksta',
          'Kvarta un terca',
          'Septima un prima'
        ],
        correctIndex: 0,
        difficulty: 5,
        explanation: 'Trijskaņu (Do-Mi-Sol) apakšā ir liela/maza terca, un virs terces virsotnes ir tīra kvarta līdz trijskaņas virsotei.',
        category: 'bank2',
      ),
      Question(
        id: 'kvintas_b2_l2_q2',
        topicId: 'intervals_kvintas',
        text: 'Tīra kvinta var būt savādi, ja to veido:',
        options: [
          'Fa un Si (tritons)',
          'Do un Sol',
          'Re un La',
          'Mi un Si'
        ],
        correctIndex: 0,
        difficulty: 5,
        explanation: 'Fa-Si nav tīra kvinta, bet paaugstināta kvinta jeb tritons (6 pustoņi). Tas ir reti izmantots intervāls.',
        category: 'bank2',
      ),
      Question(
        id: 'kvintas_b2_l2_q3',
        topicId: 'intervals_kvintas',
        text: 'Akorda virsotne (ne sakne) atrodas intervālā:',
        options: [
          'Tīra kvinta virs saknes',
          'Liela terca virs saknes',
          'Tīra kvarta virs saknes',
          'Maza terca virs saknes'
        ],
        correctIndex: 0,
        difficulty: 5,
        explanation: 'Trijskaņas virsotne atrodas tīras kvintas attālumā (7 pustoņi) virs akorda saknes (Do-Sol, Re-La u.t.t.).',
        category: 'bank2',
      ),
    ]);

    // Sekstas - Bank 1 (Consolidating new information) - Difficulty 1
    questions.addAll([
      Question(
        id: 'sekstas_b1_l1_q1',
        topicId: 'intervals_sekstas',
        text: 'Cik pustoņu ir lielajā sekstā?',
        options: ['9 pustoņi', '8 pustoņi', '7 pustoņi', '10 pustoņu'],
        correctIndex: 0,
        difficulty: 1,
        explanation: 'Liela seksta ir intervāls ar 9 pustoņiem.',
        category: 'bank1',
      ),
      Question(
        id: 'sekstas_b1_l1_q2',
        topicId: 'intervals_sekstas',
        text: 'Cik pustoņu ir mazajā sekstā?',
        options: ['8 pustoņi', '9 pustoņi', '7 pustoņi', '10 pustoņu'],
        correctIndex: 0,
        difficulty: 1,
        explanation: 'Maza seksta ir intervāls ar 8 pustoņiem.',
        category: 'bank1',
      ),
      Question(
        id: 'sekstas_b1_l1_q3',
        topicId: 'intervals_sekstas',
        text: 'Kāds intervāls veidojas starp notīm Do un La?',
        options: ['Liela seksta', 'Maza seksta', 'Tīra septima', 'Sekunda'],
        correctIndex: 0,
        difficulty: 1,
        explanation: 'Starp Do un La ir liela seksta (9 pustoņi).',
        category: 'bank1',
      ),
      Question(
        id: 'sekstas_b1_l1_q4',
        topicId: 'intervals_sekstas',
        text: 'Do un Ais intervāls ir:',
        options: [
          'Maza seksta',
          'Liela seksta',
          'Palielināta seksta',
          'Tīra septima'
        ],
        correctIndex: 0,
        difficulty: 1,
        explanation: 'Do-Ais ir maza seksta (8 pustoņi).',
        category: 'bank1',
      ),
      Question(
        id: 'sekstas_b1_l1_q5',
        topicId: 'intervals_sekstas',
        text: 'Kādu pakāpi attiecībā pret pamatni veido sekstas virsotne?',
        options: [
          'Sesto pakāpi',
          'Ceturto pakāpi',
          'Piekto pakāpi',
          'Septīto pakāpi'
        ],
        correctIndex: 0,
        difficulty: 1,
        explanation:
            'Sekstas virsotne atrodas sestajā pakāpē attiecībā pret pamatni.',
        category: 'bank1',
      ),
    ]);

    // Sekstas - Bank 1 (Consolidating new information) - Difficulty 2
    questions.addAll([
      Question(
        id: 'sekstas_b1_l2_q1',
        topicId: 'intervals_sekstas',
        text: 'Kā mūzikā apzīmē lielo sekstu?',
        options: ['M6', 'm6', 's6', 'S6'],
        correctIndex: 0,
        difficulty: 2,
        explanation: 'Liela seksta mūzikā tiek apzīmēta ar M6.',
        category: 'bank1',
      ),
      Question(
        id: 'sekstas_b1_l2_q2',
        topicId: 'intervals_sekstas',
        text: 'Kā mūzikā apzīmē mazo sekstu?',
        options: ['m6', 'M6', 's6', 'S6'],
        correctIndex: 0,
        difficulty: 2,
        explanation: 'Maza seksta mūzikā tiek apzīmēta ar m6.',
        category: 'bank1',
      ),
      Question(
        id: 'sekstas_b1_l2_q3',
        topicId: 'intervals_sekstas',
        text: 'Kura no šīm ir liela seksta?',
        options: ['Do - La', 'Do - Ais', 'Re - Si', 'Do - Re'],
        correctIndex: 0,
        difficulty: 2,
        explanation: 'Do - La ir liela seksta (9 pustoņi).',
        category: 'bank1',
      ),
      Question(
        id: 'sekstas_b1_l2_q4',
        topicId: 'intervals_sekstas',
        text: 'Seksta starp notīm Re un Si ir:',
        options: ['Liela', 'Maza', 'Palielināta', 'Samazināta'],
        correctIndex: 0,
        difficulty: 2,
        explanation: 'Re-Si ir liela seksta (9 pustoņi).',
        category: 'bank1',
      ),
      Question(
        id: 'sekstas_b1_l2_q5',
        topicId: 'intervals_sekstas',
        text: 'Lielajā sekstā starp notīm Do un La ir:',
        options: ['4.5 toņi', '4 toņi', '5 toņi', '3.5 toņi'],
        correctIndex: 0,
        difficulty: 2,
        explanation: 'Liela seksta = 9 pustoņi = 4.5 toņi.',
        category: 'bank1',
      ),
    ]);

    // Sekstas - Bank 1 (Consolidating new information) - Difficulty 3
    questions.addAll([
      Question(
        id: 'sekstas_b1_l3_q1',
        topicId: 'intervals_sekstas',
        text: 'Starp notīm La un Do ir:',
        options: ['Maza seksta', 'Liela seksta', 'Tīra kvinta', 'Sekunda'],
        correctIndex: 0,
        difficulty: 3,
        explanation: 'Starp La un Do ir maza seksta (8 pustoņi).',
        category: 'bank1',
      ),
      Question(
        id: 'sekstas_b1_l3_q2',
        topicId: 'intervals_sekstas',
        text: 'Paralēlās sekstas aprēķina no:',
        options: [
          'Pirmās pakāpes',
          'Sestās pakāpes',
          'Ceturtās pakāpes',
          'Otrās pakāpes'
        ],
        correctIndex: 1,
        difficulty: 3,
        explanation: 'Paralēlā seksta atrodas uz pakāpēm augstāk.',
        category: 'bank1',
      ),
      Question(
        id: 'sekstas_b1_l3_q3',
        topicId: 'intervals_sekstas',
        text: 'Sekstas pārvēršana paralēlajā ir:',
        options: [
          'Tikai augšup',
          'Tikai lejup',
          'Abos virzienos',
          'Nav iespējama'
        ],
        correctIndex: 2,
        difficulty: 3,
        explanation: 'Sekstas var pārveidot paralēlajā gan augšup, gan lejup.',
        category: 'bank1',
      ),
      Question(
        id: 'sekstas_b1_l3_q4',
        topicId: 'intervals_sekstas',
        text: 'Liela seksta atbilst intervālam:',
        options: ['9 pustoņi', '8 pustoņi', '7 pustoņi', '10 pustoņu'],
        correctIndex: 0,
        difficulty: 3,
        explanation: 'Liela seksta = 9 pustoņi.',
        category: 'bank1',
      ),
      Question(
        id: 'sekstas_b1_l3_q5',
        topicId: 'intervals_sekstas',
        text: 'Maza seksta atbilst intervālam:',
        options: ['8 pustoņi', '9 pustoņi', '7 pustoņi', '10 pustoņu'],
        correctIndex: 0,
        difficulty: 3,
        explanation: 'Maza seksta = 8 pustoņi.',
        category: 'bank1',
      ),
    ]);

    // Sekstas - Bank 2 (Applying learned material) - Difficulty 1
    questions.addAll([
      Question(
        id: 'sekstas_b2_l1_q1',
        topicId: 'intervals_sekstas',
        text: 'Kurš no šiem intervāliem ir vislielākais?',
        options: ['Seksta', 'Kvinta', 'Terca', 'Septima'],
        correctIndex: 3,
        difficulty: 4,
        explanation: 'Tīra septima (11 pustoņi) ir vislielākais intervāls no piedāvātajiem. Seksta ir 8-9 pustoņi, Kvinta ir 7 pustoņi, Terca ir 3-4 pustoņi.',
        category: 'bank2',
      ),
      Question(
        id: 'sekstas_b2_l1_q2',
        topicId: 'intervals_sekstas',
        text: 'Seksta atšķiras no kvintas ar:',
        options: ['1 pustoņa', '2 pustoņiem', '3 pustoņiem', '4 pustoņiem'],
        correctIndex: 1,
        difficulty: 4,
        explanation: 'Tīra kvinta ir 7 pustoņi, liela seksta ir 9 pustoņi, maza seksta ir 8 pustoņi. Atšķirība ir 1-2 pustoņi.',
        category: 'bank2',
      ),
      Question(
        id: 'sekstas_b2_l1_q3',
        topicId: 'intervals_sekstas',
        text: 'Liela seksta ir skarīga intervāla:',
        options: [
          'Mazā terca',
          'Lielajā tercā',
          'Tīrajā kvintā',
          'Tīrajā septimā'
        ],
        correctIndex: 0,
        difficulty: 4,
        explanation: 'Liela seksta (Do-La, 9 pustoņi) invertēta kļūst par mazo tercu (La-Do, 3 pustoņi). Intervāli ir savstarpēji inverti.',
        category: 'bank2',
      ),
    ]);

    // Sekstas - Bank 2 (Applying learned material) - Difficulty 2
    questions.addAll([
      Question(
        id: 'sekstas_b2_l2_q1',
        topicId: 'intervals_sekstas',
        text: 'Kādi intervāli kopā veido septīto akordu (7. akords)?',
        options: [
          'Trijskaņa (terca+kvinta) plus septima',
          'Trijskaņa (terca+kvarta) plus septima',
          'Tikai septima',
          'Divas terces un kvarta'
        ],
        correctIndex: 0,
        difficulty: 5,
        explanation: 'Septīto akordu (Do7: Do-Mi-Sol-Si) veido trijskaņa (Do-Mi-Sol) plus septima (Si), kas ir liela septima virs saknes.',
        category: 'bank2',
      ),
      Question(
        id: 'sekstas_b2_l2_q2',
        topicId: 'intervals_sekstas',
        text: 'Seksta ir piemērota harmonijai, jo skaņ:',
        options: [
          'Mīksta un svāriga, piemērota sakrālai mūzikai',
          'Griezīga un ass',
          'Negodīga un neskaidra',
          'Tukša un vienveidīga'
        ],
        correctIndex: 0,
        difficulty: 5,
        explanation: 'Liela seksta (īpaši) skaņ mīksta, svāriga un romantiška, padarot to piemērotu harmonijai.',
        category: 'bank2',
      ),
      Question(
        id: 'sekstas_b2_l2_q3',
        topicId: 'intervals_sekstas',
        text: 'La mažora trijskaņu spēle uz klaviatūras sākas ar:',
        options: ['La', 'Do', 'Cis', 'Fis'],
        correctIndex: 0,
        difficulty: 5,
        explanation: 'La mažora trijskaņa (La-Cis-Mi) sākas ar La. Trijskaņu veido La (69) + Cis (73) + Mi (76).',
        category: 'bank2',
      ),
    ]);

    // Add validation tasks (piano-based) for Bank 1 and Bank 2
    // MIDI notes: C=60, C#=61, D=62, D#=63, E=64, F=65, F#=66, G=67, G#=68, A=69, A#=70, B=71

    // Bank 1 Validation Tasks - Level 1 (Difficulty 1)
    questions.addAll([
      Question(
        id: 'tercas_b1_val_l1_q1',
        topicId: 'intervals_tercas',
        text: 'Izdomā un uz klaviatūras atrodi lielu tercu no nots Do!',
        options: [],
        correctIndex: -1,
        difficulty: 1,
        explanation:
            'Liela terca Do-Mi ir intervāls, kurā ietilpst 4 pustoņi. Tas skan gaiši un priecīgi.',
        category: 'bank1',
        isValidation: true,
        validationType: 'interval',
        expectedNotes: [60, 64], // C and E (4 semitones apart)
      ),
      Question(
        id: 'tercas_b1_val_l1_q2',
        topicId: 'intervals_tercas',
        text: 'Izdomā un uz klaviatūras atrodi mazu tercu, kuras augšējā nots ir Fa!',
        options: [],
        correctIndex: -1,
        difficulty: 1,
        explanation:
            'Maza terca Re-Fa ir intervāls, kurā ietilpst 3 pustoņi. Tas skan mazliet skumji.',
        category: 'bank1',
        isValidation: true,
        validationType: 'interval',
        expectedNotes: [62, 65], // D and F (3 semitones apart)
      ),
    ]);

    // Bank 1 Validation Tasks - Level 2 (Difficulty 2)
    questions.addAll([
      Question(
        id: 'tercas_b1_val_l2_q1',
        topicId: 'intervals_tercas',
        text: 'Izdomā un uz klaviatūras atrodi mazu tercu no nots Do!',
        options: [],
        correctIndex: -1,
        difficulty: 2,
        explanation:
            'Maza terca Do-Mib ir intervāls, kurā ietilpst 3 pustoņi. Tas skan mazliet skumji.',
        category: 'bank1',
        isValidation: true,
        validationType: 'interval',
        expectedNotes: [60, 63], // C and D# (3 semitones)
      ),
      Question(
        id: 'tercas_b1_val_l2_q2',
        topicId: 'intervals_tercas',
        text: 'Izdomā un uz klaviatūras atrodi lielu tercu, kuras augšējā nots ir Si!',
        options: [],
        correctIndex: -1,
        difficulty: 2,
        explanation:
            'Liela terca Sol-Si ir intervāls, kurā ietilpst 4 pustoņi. Tas skan gaiši un priecīgi.',
        category: 'bank1',
        isValidation: true,
        validationType: 'interval',
        expectedNotes: [67, 71], // G and B (4 semitones)
      ),
    ]);

    // Bank 1 Validation Tasks - Level 3 (Difficulty 3)
    questions.addAll([
      Question(
        id: 'tercas_b1_val_l3_q1',
        topicId: 'intervals_tercas',
        text: 'Izdomā un uz klaviatūras atrodi mazu tercu, kuras augšējā nots ir Sol!',
        options: [],
        correctIndex: -1,
        difficulty: 3,
        explanation:
            'Maza terca Mi-Sol ir intervāls, kurā ietilpst 3 pustoņi. Tas skan mazliet skumji.',
        category: 'bank1',
        isValidation: true,
        validationType: 'interval',
        expectedNotes: [64, 67], // E and G (3 semitones)
      ),
      Question(
        id: 'tercas_b1_val_l3_q2',
        topicId: 'intervals_tercas',
        text: 'Izdomā un uz klaviatūras atrodi lielu tercu no nots Fa!',
        options: [],
        correctIndex: -1,
        difficulty: 3,
        explanation:
            'Liela terca Fa-La ir intervāls, kurā ietilpst 4 pustoņi. Tas skan gaiši un priecīgi.',
        category: 'bank1',
        isValidation: true,
        validationType: 'interval',
        expectedNotes: [65, 69], // F and A (4 semitones)
      ),
    ]);

    // Bank 2 Validation Tasks - Chord Theory (Difficulty 5)
    questions.addAll([
      Question(
        id: 'tercas_b2_val_q1',
        topicId: 'intervals_tercas',
        text: 'Izdomā un uz klaviatūras atrodi Do mažora trijskaņa divas augšējās notis!',
        options: [],
        correctIndex: -1,
        difficulty: 5,
        explanation:
            'Do mažora trijskaņa (Do-Mi-Sol) divas augšējās notis ir Mi un Sol. Akords ir veidots no lielas tercas (Do-Mi) un mazas tercas (Mi-Sol).',
        category: 'bank2',
        isValidation: true,
        validationType: 'interval',
        expectedNotes: [64, 67], // E and G (two upper notes of C major)
      ),
      Question(
        id: 'kvartas_b2_val_q1',
        topicId: 'intervals_tercas',
        text: 'Izdomā un uz klaviatūras atrodi Re mažora trijskaņa divas augšējās notis!',
        options: [],
        correctIndex: -1,
        difficulty: 5,
        explanation:
            'Re mažora trijskaņa (Re-Fa#-La) divas augšējās notis ir Fa# un La. Akords ir veidots no lielas tercas (Re-Fa#) un mazas tercas (Fa#-La).',
        category: 'bank2',
        isValidation: true,
        validationType: 'interval',
        expectedNotes: [66, 69], // F# and A (two upper notes of D major)
      ),
      Question(
        id: 'kvintas_b2_val_q1',
        topicId: 'intervals_kvintas',
        text: 'Izdomā un uz klaviatūras atrodi Do mazora trijskaņa visas notis!',
        options: [],
        correctIndex: -1,
        difficulty: 5,
        explanation:
            'Do mazora trijskaņa (Do-Mib-Sol) notis ir Do (60), Mib (63) un Sol (67). Akords ir veidots no Do, mazas tercas (Do-Mib) un tīras kvintas (Do-Sol).',
        category: 'bank2',
        isValidation: true,
        validationType: 'interval',
        expectedNotes: [60, 63, 67], // C, Eb, G (all notes of C minor)
      ),
      Question(
        id: 'sekstas_b2_val_q1',
        topicId: 'intervals_sekstas',
        text: 'Izdomā un uz klaviatūras atrodi Mi mažora trijskaņu!',
        options: [],
        correctIndex: -1,
        difficulty: 5,
        explanation:
            'Mi mažora trijskaņa (Mi-Gis-Si) notis ir Mi (64), Gis (68) un Si (71). Akords satur lielu tercu (Mi-Gis) un tīru kvintu (Mi-Si).',
        category: 'bank2',
        isValidation: true,
        validationType: 'interval',
        expectedNotes: [64, 68, 71], // E, G#, B (all notes of E major)
      ),
      Question(
        id: 'tercas_b2_val_q2',
        topicId: 'intervals_kvintas',
        text: 'Izdomā un uz klaviatūras atrodi Re mazora trijskaņa visas notis!',
        options: [],
        correctIndex: -1,
        difficulty: 5,
        explanation:
            'Re mazora trijskaņa (Re-Fa-La) notis ir Re (62), Fa (65) un La (69). Akords ir veidots no Re, mazas tercas (Re-Fa) un tīras kvintas (Re-La).',
        category: 'bank2',
        isValidation: true,
        validationType: 'interval',
        expectedNotes: [62, 65, 69], // D, F, A (all notes of D minor)
      ),
      Question(
        id: 'kvartas_b2_val_q2',
        topicId: 'intervals_kvartas',
        text: 'Izdomā un uz klaviatūras atrodi Fa mažora trijskaņu!',
        options: [],
        correctIndex: -1,
        difficulty: 5,
        explanation:
            'Fa mažora trijskaņa (Fa-La-Do) notis ir Fa (65), La (69) un Do (72). Akords satur lielu tercu (Fa-La) un tīru kvintu (Fa-Do).',
        category: 'bank2',
        isValidation: true,
        validationType: 'interval',
        expectedNotes: [65, 69, 72], // F, A, C (all notes of F major)
      ),
    ]);
  }

  Future<void> _loadProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? progressJson = prefs.getString(_progressKey);
    if (progressJson != null) {
      Map<String, dynamic> progressMap = json.decode(progressJson);
      userProgress = progressMap
          .map((key, value) => MapEntry(key, UserProgress.fromJson(value)));
    }
    String? sessionsJson = prefs.getString(_sessionsKey);
    if (sessionsJson != null) {
      List<dynamic> sessionsList = json.decode(sessionsJson);
      sessions = sessionsList.map((e) => SessionResult.fromJson(e)).toList();
    }
  }

  Future<void> _saveProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> progressMap =
        userProgress.map((key, value) => MapEntry(key, value.toJson()));
    await prefs.setString(_progressKey, json.encode(progressMap));
  }

  Future<void> _saveSessions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> sessionsList =
        sessions.map((e) => e.toJson()).toList();
    await prefs.setString(_sessionsKey, json.encode(sessionsList));
  }

  /// Save session state to persistent storage for cross-phase tracking
  Future<void> saveSessionState(String topicId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserProgress progress = getProgress(topicId);

    Map<String, dynamic> sessionState = {
      'sessionLevel': progress.sessionLevel,
      'sessionScore': progress.sessionScore,
      'sessionConsecutiveCorrect': progress.sessionConsecutiveCorrect,
      'sessionConsecutiveWrong': progress.sessionConsecutiveWrong,
      'shownQuestions': progress.shownQuestionsInSession.toList(),
      'initialSessionLevel': progress.initialSessionLevel,
    };

    Map<String, dynamic> allSessionStates = {};
    String? sessionStateJson = prefs.getString(_sessionStateKey);
    if (sessionStateJson != null) {
      final decoded = json.decode(sessionStateJson);
      if (decoded is Map<String, dynamic>) {
        allSessionStates = decoded;
      }
    }

    allSessionStates[topicId] = sessionState;
    await prefs.setString(_sessionStateKey, json.encode(allSessionStates));
  }

  /// Load session state from persistent storage
  Future<void> _loadSessionState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? sessionStateJson = prefs.getString(_sessionStateKey);
    if (sessionStateJson != null) {
      final decoded = json.decode(sessionStateJson);
      if (decoded is Map<String, dynamic>) {
        decoded.forEach((topicId, value) {
          if (value is Map<String, dynamic>) {
            UserProgress progress = getProgress(topicId);
            progress.sessionLevel = value['sessionLevel'] is int
                ? value['sessionLevel'] as int
                : progress.currentLevel;
            progress.sessionScore =
                value['sessionScore'] is int ? value['sessionScore'] as int : 0;
            progress.sessionConsecutiveCorrect =
                value['sessionConsecutiveCorrect'] is int
                    ? value['sessionConsecutiveCorrect'] as int
                    : 0;
            progress.sessionConsecutiveWrong =
                value['sessionConsecutiveWrong'] is int
                    ? value['sessionConsecutiveWrong'] as int
                    : 0;
            progress.initialSessionLevel = value['initialSessionLevel'] is int
                ? value['initialSessionLevel'] as int
                : progress.currentLevel;
            if (value['shownQuestions'] is List) {
              progress.shownQuestionsInSession.addAll(
                  (value['shownQuestions'] as List).whereType<String>());
            }
          }
        });
      }
    }

    // Legacy fallback: load shown questions from old string-list storage
    for (String key in prefs.getKeys()) {
      if (key.startsWith('${_sessionShownKey}_')) {
        String topicId = key.replaceFirst('${_sessionShownKey}_', '');
        List<String>? shownQuestions = prefs.getStringList(key);
        if (shownQuestions != null) {
          UserProgress progress = getProgress(topicId);
          progress.shownQuestionsInSession.addAll(shownQuestions);
        }
      }
    }
  }

  /// Clear session state when session finishes
  Future<void> clearSessionState(String topicId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? sessionStateJson = prefs.getString(_sessionStateKey);
    if (sessionStateJson != null) {
      final decoded = json.decode(sessionStateJson);
      if (decoded is Map<String, dynamic>) {
        decoded.remove(topicId);
        if (decoded.isEmpty) {
          await prefs.remove(_sessionStateKey);
        } else {
          await prefs.setString(_sessionStateKey, json.encode(decoded));
        }
      }
    }

    // Legacy cleanup
    await prefs.remove('${_sessionShownKey}_$topicId');
  }

  UserProgress getProgress(String topicId) {
    return userProgress.putIfAbsent(
        topicId,
        () => UserProgress(
              topicId: topicId,
              currentLevel: 1,
              consecutiveCorrect: 0,
              consecutiveWrong: 0,
              totalScore: 0,
              lastAttempt: DateTime.now(),
              mastered: false,
              hasStarted: false,
            ));
  }

  bool hasStartedTopic(String topicId) {
    return getProgress(topicId).hasStarted;
  }

  /// Initialize session state for a topic
  void initializeSession(String topicId) {
    UserProgress progress = getProgress(topicId);
    progress.initialSessionLevel = progress.currentLevel;
    progress.sessionLevel = progress.currentLevel;
    progress.sessionScore = 0;
    progress.sessionConsecutiveCorrect = 0;
    progress.sessionConsecutiveWrong = 0;
    progress.levelUpInSession = 0;
    progress.shownQuestionsInSession.clear();
  }

  /// Get next question for session, avoiding repeats
  Question? getNextQuestion(String topicId, int phase, {int? bank2Index}) {
    UserProgress progress = getProgress(topicId);

    // Initialize session only in phase 1
    if (phase == 1 && progress.shownQuestionsInSession.isEmpty) {
      initializeSession(topicId);
    }

    List<Question> available;

    if (phase == 1) {
      // Bank 1: Prefer unseen questions at or below the current session level.
      available = questions
          .where((q) =>
              q.topicId == topicId &&
              q.category == 'bank1' &&
              q.difficulty <= progress.sessionLevel &&
              !q.isValidation &&
              !progress.shownQuestionsInSession.contains(q.id))
          .toList();

      // If no unseen questions remain at the current level or below,
      // allow repeats from the same level range rather than jumping ahead.
      if (available.isEmpty) {
        available = questions
            .where((q) =>
                q.topicId == topicId &&
                q.category == 'bank1' &&
                q.difficulty <= progress.sessionLevel &&
                !q.isValidation)
            .toList();
      }
    } else {
      // Bank 2: Difficulty depends on Bank 1 score
      int bank2Difficulty = progress.sessionScore < 5 ? 4 : 5;

      // For last task (3rd): check if it should be validation
      if (bank2Index == 2 && progress.sessionScore > 0) {
        // Last task is validation if at least 1 correct in Bank 2
        available = questions
            .where((q) =>
                q.topicId == topicId &&
                q.category == 'bank2' &&
                q.difficulty == bank2Difficulty &&
                q.isValidation == true &&
                !progress.shownQuestionsInSession.contains(q.id))
            .toList();

        if (available.isEmpty) {
          // Fallback to regular question if no validation available
          available = questions
              .where((q) =>
                  q.topicId == topicId &&
                  q.category == 'bank2' &&
                  q.difficulty == bank2Difficulty &&
                  !q.isValidation &&
                  !progress.shownQuestionsInSession.contains(q.id))
              .toList();
        }
      } else {
        available = questions
            .where((q) =>
                q.topicId == topicId &&
                q.category == 'bank2' &&
                q.difficulty == bank2Difficulty &&
                !q.isValidation &&
                !progress.shownQuestionsInSession.contains(q.id))
            .toList();
      }

      // Fallback: if no questions at current difficulty, get any Bank 2 question not shown
      if (available.isEmpty) {
        available = questions
            .where((q) =>
                q.topicId == topicId &&
                q.category == 'bank2' &&
                !q.isValidation &&
                !progress.shownQuestionsInSession.contains(q.id))
            .toList();
      }
    }

    if (available.isEmpty) return null;

    available.shuffle();
    Question question = available.first;
    progress.shownQuestionsInSession.add(question.id);
    saveSessionState(topicId);
    return question;
  }

  /// Get validation task for Bank 1 after 3 consecutive correct answers
  Question? getBank1ValidationTask(String topicId) {
    UserProgress progress = getProgress(topicId);

    // Get validation questions at current level
    List<Question> available = questions
        .where((q) =>
            q.topicId == topicId &&
            q.category == 'bank1' &&
            q.difficulty == progress.sessionLevel &&
            q.isValidation == true &&
            !progress.shownQuestionsInSession.contains(q.id))
        .toList();

    if (available.isEmpty) return null;

    available.shuffle();
    Question question = available.first;
    progress.shownQuestionsInSession.add(question.id);
    saveSessionState(topicId);
    return question;
  }

  /// Record answer for current question and update progress
  void recordAnswer(String topicId, int phase, bool correct,
      {int bank2Index = -1, bool isValidation = false}) {
    UserProgress progress = getProgress(topicId);

    if (correct) {
      progress.sessionConsecutiveCorrect++;
      progress.sessionConsecutiveWrong = 0;
      progress.sessionScore++;

      // Handle validation task success - level up in Bank 1
      if (isValidation && phase == 1) {
        if (progress.sessionLevel < 3) {
          progress.sessionLevel = min(progress.sessionLevel + 1, 3);
        }
        progress.sessionConsecutiveCorrect =
            0; // Reset after validation success
      }

      // In Bank 1: Check if we should offer validation task
      if (phase == 1 &&
          progress.sessionConsecutiveCorrect >= 3 &&
          !isValidation) {
        // Offer validation task next (handled in UI)
      }

      // In Bank 2: do not change Bank 1 session level here.
      // Bank 2 difficulty is driven by the Bank 1 score only.
    } else {
      progress.sessionConsecutiveWrong++;

      // For validation tasks, don't reset consecutive correct if it fails
      if (!isValidation) {
        progress.sessionConsecutiveCorrect = 0;
      }

      // In Bank 2: Bank 1 session level should remain unchanged.
    }
  }

  /// Finalize session and update persistent progress
  void finalizeSession(String topicId, int sessionLevel, int rating) {
    UserProgress progress = getProgress(topicId);

    // Update persistent level if improved during session
    if (sessionLevel > progress.currentLevel) {
      progress.levelUpInSession = 1;
      progress.currentLevel = sessionLevel;
    }

    progress.hasStarted = true;

    // Update consecutive tracking for next session
    // Use session data to inform next session's level
    progress.totalScore = progress.sessionScore;
    progress.lastAttempt = DateTime.now();

    // Check for mastery: started at level 3 and achieved perfect 10/10 score
    if (progress.initialSessionLevel == 3 && progress.sessionScore == 10) {
      progress.mastered = true;
    }

    userProgress[topicId] = progress;
    _saveProgress();
  }

  /// Check if topic is fully mastered
  bool isMastered(String topicId) {
    UserProgress progress = getProgress(topicId);
    return progress.mastered;
  }

  /// Get easier question from previous level (Step 3 fallback)
  Question? getEasierQuestionFromPreviousLevel(
      String topicId, int currentDifficulty) {
    UserProgress progress = getProgress(topicId);

    int easierDifficulty = max(1, currentDifficulty - 1);
    List<Question> available = questions
        .where((q) =>
            q.topicId == topicId &&
            q.category == 'bank1' &&
            q.difficulty == easierDifficulty &&
            !progress.shownQuestionsInSession.contains(q.id))
        .toList();

    if (available.isEmpty) return null;
    available.shuffle();
    Question question = available.first;
    progress.shownQuestionsInSession.add(question.id);
    return question;
  }

  List<Question> getQuestionsForSession(String topicId, int phase) {
    // Legacy method for compatibility
    // Returns initial 7/3 questions based on current level
    UserProgress progress = getProgress(topicId);
    initializeSession(topicId);

    List<Question> available;
    if (phase == 1) {
      available = questions
          .where((q) =>
              q.topicId == topicId &&
              q.category == 'bank1' &&
              q.difficulty <= progress.currentLevel &&
              !q.isValidation)
          .toList();
    } else {
      int bank2Difficulty = progress.sessionScore < 5 ? 4 : 5;
      available = questions
          .where((q) =>
              q.topicId == topicId &&
              q.category == 'bank2' &&
              q.difficulty == bank2Difficulty &&
              !q.isValidation)
          .toList();
    }

    available.shuffle();
    int count = phase == 1 ? 7 : 3;
    List<Question> selected = available.take(count).toList();

    // Mark as shown
    for (var q in selected) {
      progress.shownQuestionsInSession.add(q.id);
    }

    return selected;
  }

  void completeSession(SessionResult result) {
    sessions.add(result);
    _saveSessions();
    // Update total score
    UserProgress progress = getProgress(result.topicId);
    progress.totalScore += result.score;
    // Check if mastered (e.g., score > 8 in multiple sessions or high level)
    if (progress.totalScore >= 50 || progress.currentLevel >= 5) {
      // Arbitrary threshold
      progress.mastered = true;
    }
    userProgress[result.topicId] = progress;
    _saveProgress();
  }

  /// Reset all progress to initial state (first-time user state)
  Future<void> resetAllProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Clear progress and session states
    await prefs.remove(_progressKey);
    await prefs.remove(_sessionsKey);
    await prefs.remove(_sessionStateKey);

    // Legacy cleanup
    for (String key in prefs.getKeys()) {
      if (key.startsWith('${_sessionShownKey}_')) {
        await prefs.remove(key);
      }
    }

    // Reset in-memory data
    userProgress.clear();
    sessions.clear();

    // Re-initialize all topics with default progress
    for (Topic topic in topics) {
      userProgress[topic.id] = UserProgress(
        topicId: topic.id,
        currentLevel: 1,
        consecutiveCorrect: 0,
        consecutiveWrong: 0,
        totalScore: 0,
        lastAttempt: DateTime.now(),
        mastered: false,
        hasStarted: false,
      );
    }
  }
}
