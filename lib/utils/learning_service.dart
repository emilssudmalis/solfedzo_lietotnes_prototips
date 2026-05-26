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
        text: 'Kuras vietas tercā ir svarīgākās?',
        options: [
          'Pamatne un virsotne',
          'Pamatne un vidus',
          'Vidus un virsotne',
          'Tikai pamatne'
        ],
        correctIndex: 0,
        difficulty: 4,
        explanation: 'Tercas pamatne un virsotne ir svarīgākās vietas.',
        category: 'bank2',
      ),
      Question(
        id: 'tercas_b2_l1_q2',
        topicId: 'intervals_tercas',
        text: 'Tercas pamatne mūzikā ir:',
        options: [
          'Pirmā pakāpe',
          'Otrā pakāpe',
          'Trešā pakāpe',
          'Ceturtā pakāpe'
        ],
        correctIndex: 0,
        difficulty: 4,
        explanation: 'Tercas pamatne ir pirmā pakāpe.',
        category: 'bank2',
      ),
      Question(
        id: 'tercas_b2_l1_q3',
        topicId: 'intervals_tercas',
        text: 'Tercas virsotne atrodas:',
        options: [
          'Trešajā pakāpē',
          'Ceturtajā pakāpē',
          'Otrajā pakāpē',
          'Piektajā pakāpē'
        ],
        correctIndex: 0,
        difficulty: 4,
        explanation: 'Tercas virsotne atrodas trešajā pakāpē.',
        category: 'bank2',
      ),
    ]);

    // Bank 2 (Applying learned material) - Difficulty 2
    questions.addAll([
      Question(
        id: 'tercas_b2_l2_q1',
        topicId: 'intervals_tercas',
        text: 'Ja Do ir tercas pamatne, tad virsotne ir:',
        options: ['Mi', 'Re', 'Fa', 'Sol'],
        correctIndex: 0,
        difficulty: 5,
        explanation: 'Ja Do ir pamatne, tad Do-Mi ir terca, un virsotne ir Mi.',
        category: 'bank2',
      ),
      Question(
        id: 'tercas_b2_l2_q2',
        topicId: 'intervals_tercas',
        text: 'Harmoniski tercas skaņas ir:',
        options: [
          'Patīkamas ausis',
          'Nepatīkamas ausis',
          'Neitrālas',
          'Atkarīgs no konteksta'
        ],
        correctIndex: 0,
        difficulty: 5,
        explanation: 'Harmoniskas tercas skaņas ir patīkamas ausis.',
        category: 'bank2',
      ),
      Question(
        id: 'tercas_b2_l2_q3',
        topicId: 'intervals_tercas',
        text: 'Tercā Do-Mi ir:',
        options: [
          'Liela terca',
          'Maza terca',
          'Palielināta terca',
          'Samazināta terca'
        ],
        correctIndex: 0,
        difficulty: 5,
        explanation: 'Do-Mi ir liela terca (4 pustoņi).',
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
        text: 'Kuras vietas kvartā ir svarīgākās?',
        options: [
          'Pamatne un virsotne',
          'Pamatne un vidus',
          'Vidus un virsotne',
          'Tikai pamatne'
        ],
        correctIndex: 0,
        difficulty: 4,
        explanation: 'Kvartas pamatne un virsotne ir svarīgākās vietas.',
        category: 'bank2',
      ),
      Question(
        id: 'kvartas_b2_l1_q2',
        topicId: 'intervals_kvartas',
        text: 'Kvartas pamatne ir:',
        options: [
          'Pirmā pakāpe',
          'Otrā pakāpe',
          'Ceturtā pakāpe',
          'Trešā pakāpe'
        ],
        correctIndex: 0,
        difficulty: 4,
        explanation: 'Kvartas pamatne ir pirmā pakāpe.',
        category: 'bank2',
      ),
      Question(
        id: 'kvartas_b2_l1_q3',
        topicId: 'intervals_kvartas',
        text: 'Kvartas virsotne atrodas:',
        options: [
          'Ceturtajā pakāpē',
          'Trešajā pakāpē',
          'Piektajā pakāpē',
          'Otrajā pakāpē'
        ],
        correctIndex: 0,
        difficulty: 4,
        explanation: 'Kvartas virsotne atrodas ceturtajā pakāpē.',
        category: 'bank2',
      ),
    ]);

    // Kvartas - Bank 2 (Applying learned material) - Difficulty 2
    questions.addAll([
      Question(
        id: 'kvartas_b2_l2_q1',
        topicId: 'intervals_kvartas',
        text: 'Ja Do ir kvartas pamatne, tad virsotne ir:',
        options: ['Fa', 'Re', 'Sol', 'Mi'],
        correctIndex: 0,
        difficulty: 5,
        explanation:
            'Ja Do ir pamatne, tad Do-Fa ir kvarta, un virsotne ir Fa.',
        category: 'bank2',
      ),
      Question(
        id: 'kvartas_b2_l2_q2',
        topicId: 'intervals_kvartas',
        text: 'Tīrā kvarta skaņ:',
        options: [
          'Neitrāla, nedaudz tukša',
          'Ļoti skaista',
          'Negodīga',
          'Griezīga'
        ],
        correctIndex: 0,
        difficulty: 5,
        explanation: 'Tīra kvarta skaņ neitrāla un nedaudz tukša.',
        category: 'bank2',
      ),
      Question(
        id: 'kvartas_b2_l2_q3',
        topicId: 'intervals_kvartas',
        text: 'Intervālā Do-Fa ir:',
        options: [
          'Tīra kvarta',
          'Liela tercā',
          'Palielināta kvarta',
          'Tīra kvinta'
        ],
        correctIndex: 0,
        difficulty: 5,
        explanation: 'Do-Fa ir tīra kvarta (5 pustoņi).',
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
        text: 'Kuras vietas kvintā ir svarīgākās?',
        options: [
          'Pamatne un virsotne',
          'Pamatne un vidus',
          'Vidus un virsotne',
          'Tikai pamatne'
        ],
        correctIndex: 0,
        difficulty: 4,
        explanation: 'Kvintas pamatne un virsotne ir svarīgākās vietas.',
        category: 'bank2',
      ),
      Question(
        id: 'kvintas_b2_l1_q2',
        topicId: 'intervals_kvintas',
        text: 'Kvintas pamatne ir:',
        options: [
          'Pirmā pakāpe',
          'Otrā pakāpe',
          'Piektā pakāpe',
          'Ceturtā pakāpe'
        ],
        correctIndex: 0,
        difficulty: 4,
        explanation: 'Kvintas pamatne ir pirmā pakāpe.',
        category: 'bank2',
      ),
      Question(
        id: 'kvintas_b2_l1_q3',
        topicId: 'intervals_kvintas',
        text: 'Kvintas virsotne atrodas:',
        options: [
          'Piektajā pakāpē',
          'Ceturtajā pakāpē',
          'Trešajā pakāpē',
          'Sestajā pakāpē'
        ],
        correctIndex: 0,
        difficulty: 4,
        explanation: 'Kvintas virsotne atrodas piektajā pakāpē.',
        category: 'bank2',
      ),
    ]);

    // Kvintas - Bank 2 (Applying learned material) - Difficulty 2
    questions.addAll([
      Question(
        id: 'kvintas_b2_l2_q1',
        topicId: 'intervals_kvintas',
        text: 'Ja Do ir kvintas pamatne, tad virsotne ir:',
        options: ['Sol', 'Fa', 'La', 'Mi'],
        correctIndex: 0,
        difficulty: 5,
        explanation:
            'Ja Do ir pamatne, tad Do-Sol ir kvinta, un virsotne ir Sol.',
        category: 'bank2',
      ),
      Question(
        id: 'kvintas_b2_l2_q2',
        topicId: 'intervals_kvintas',
        text: 'Tīrā kvinta skaņ:',
        options: ['Spēcīga, konsonate', 'Griezīga', 'Negodīga', 'Ļoti skumta'],
        correctIndex: 0,
        difficulty: 5,
        explanation: 'Tīra kvinta skaņ spēcīga un konsonate.',
        category: 'bank2',
      ),
      Question(
        id: 'kvintas_b2_l2_q3',
        topicId: 'intervals_kvintas',
        text: 'Intervālā Do-Sol ir:',
        options: [
          'Tīra kvinta',
          'Samazināta kvinta',
          'Tīra kvarta',
          'Liela tercā'
        ],
        correctIndex: 0,
        difficulty: 5,
        explanation: 'Do-Sol ir tīra kvinta (7 pustoņi).',
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
        text: 'Kuras vietas sekstā ir svarīgākās?',
        options: [
          'Pamatne un virsotne',
          'Pamatne un vidus',
          'Vidus un virsotne',
          'Tikai pamatne'
        ],
        correctIndex: 0,
        difficulty: 4,
        explanation: 'Sekstas pamatne un virsotne ir svarīgākās vietas.',
        category: 'bank2',
      ),
      Question(
        id: 'sekstas_b2_l1_q2',
        topicId: 'intervals_sekstas',
        text: 'Sekstas pamatne ir:',
        options: [
          'Pirmā pakāpe',
          'Otrā pakāpe',
          'Sestā pakāpe',
          'Ceturtā pakāpe'
        ],
        correctIndex: 0,
        difficulty: 4,
        explanation: 'Sekstas pamatne ir pirmā pakāpe.',
        category: 'bank2',
      ),
      Question(
        id: 'sekstas_b2_l1_q3',
        topicId: 'intervals_sekstas',
        text: 'Sekstas virsotne atrodas:',
        options: [
          'Sestajā pakāpē',
          'Ceturtajā pakāpē',
          'Piektajā pakāpē',
          'Septīto pakāpē'
        ],
        correctIndex: 0,
        difficulty: 4,
        explanation: 'Sekstas virsotne atrodas sestajā pakāpē.',
        category: 'bank2',
      ),
    ]);

    // Sekstas - Bank 2 (Applying learned material) - Difficulty 2
    questions.addAll([
      Question(
        id: 'sekstas_b2_l2_q1',
        topicId: 'intervals_sekstas',
        text: 'Ja Do ir sekstas pamatne, tad virsotne ir:',
        options: ['La', 'Sol', 'Si', 'Mi'],
        correctIndex: 0,
        difficulty: 5,
        explanation:
            'Ja Do ir pamatne, tad Do-La ir seksta, un virsotne ir La.',
        category: 'bank2',
      ),
      Question(
        id: 'sekstas_b2_l2_q2',
        topicId: 'intervals_sekstas',
        text: 'Liela seksta skaņ:',
        options: ['Skaista, romantiška', 'Griezīga', 'Negodīga', 'Ļoti skumta'],
        correctIndex: 0,
        difficulty: 5,
        explanation: 'Liela seksta skaņ skaista un romantiška.',
        category: 'bank2',
      ),
      Question(
        id: 'sekstas_b2_l2_q3',
        topicId: 'intervals_sekstas',
        text: 'Intervālā Do-La ir:',
        options: ['Liela seksta', 'Maza seksta', 'Tīra kvinta', 'Tīra septima'],
        correctIndex: 0,
        difficulty: 5,
        explanation: 'Do-La ir liela seksta (9 pustoņi).',
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

    // Bank 2 Validation Tasks (Difficulty 5)
    questions.addAll([
      Question(
        id: 'tercas_b2_val_q1',
        topicId: 'intervals_tercas',
        text: 'Izdomā un uz klaviatūras atrodi lielu tercu, kuras augšējā nots ir Mi!',
        options: [],
        correctIndex: -1,
        difficulty: 5,
        explanation:
            'Liela terca Do-Mi ir intervāls, kurā ietilpst 4 pustoņi. Tas skan gaiši un priecīgi.',
        category: 'bank2',
        isValidation: true,
        validationType: 'interval',
        expectedNotes: [60, 64], // C and E
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
