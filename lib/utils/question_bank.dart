import 'package:quiz/utils/quiz_card.dart';
import 'package:nb_utils/nb_utils.dart';

class QuestionProgress {
  String topicId;
  int currentLevel; // For bank 1
  int consecutiveCorrect;
  int consecutiveWrong;
  int bank1Score; // Points in current session from bank 1
  int bank2Score; // Points in current session from bank 2
  List<String>
      questionsShownInSession; // To avoid showing same question twice in one session
  bool hasStartedTopic; // Whether this is first time attempting topic

  QuestionProgress({
    required this.topicId,
    this.currentLevel = 1,
    this.consecutiveCorrect = 0,
    this.consecutiveWrong = 0,
    this.bank1Score = 0,
    this.bank2Score = 0,
    this.questionsShownInSession = const [],
    this.hasStartedTopic = false,
  });
}

class QuestionBank {
  // Tercas - Bank 1 (Consolidating new information)
  // Level 1: Understanding basic concepts from theory
  static Map<int, List<Quiz>> tercasBank1 = {
    1: [
      Quiz("Kāds ir tercas pamatdefinīcija?", "Intervāls, kura virsotne ir trešā pakāpe", "Intervāls starp diviem Do", "Trīs notis pēc kārtas", "Skaņas kombinācija", 1, 70.0),
      Quiz("Ar kādu ciparu mūzikā apzīmē tercu?", "3", "2", "4", "T", 1, 80.0),
      Quiz("Cik pustoņu ir lielā tercā?", "4 pustoņi", "3 pustoņi", "5 pustoņi", "6 pustoņi", 1, 90.0),
      Quiz("Cik pustoņu ir mazā tercā?", "3 pustoņi", "4 pustoņi", "2 pustoņi", "5 pustoņi", 1, 100.0),
      Quiz("Kā skaņ liela terca?", "Gaiša, priecīga", "Bēdīga, maiga", "Neitrāla", "Negodīga", 1, 110.0),
    ],
    2: [
      Quiz("Kā skaņ maza terca?", "Bēdīga, maiga", "Gaiša, priecīga", "Neitrāla", "Skaļa", 1, 70.0),
      Quiz("Kā mūzikā apzīmē lielu tercu?", "l3", "m3", "L3", "M3", 1, 80.0),
      Quiz("Kā mūzikā apzīmē mazu tercu?", "m3", "l3", "M3", "L3", 1, 90.0),
      Quiz("Kāds intervāls ir starp notīm Do un Mi?", "Liela terca", "Maza terca", "Kvarta", "Sekunda", 1, 100.0),
      Quiz("Kāds intervāls ir starp notīm Re un Fa?", "Maza terca", "Liela terca", "Kvinta", "Terca", 1, 110.0),
    ],
    3: [
      Quiz("Kāds intervāls ir starp notīm Mi un Sol?", "Maza terca", "Liela terca", "Kvarta", "Sekunda", 1, 70.0),
      Quiz("Kāds intervāls ir starp notīm Re un Fa diesis?", "Liela terca", "Maza terca", "Kvarta", "Sekunda", 1, 80.0),
      Quiz("Tercas pamatne ir:", "Apakšējā nots", "Augšējā nots", "Vidus nots", "Zemākā nots", 1, 90.0),
      Quiz("Tercas virsotne attiecībā pret pamatni ir:", "Trešā pakāpe", "Ceturtā pakāpe", "Otrā pakāpe", "Piektā pakāpe", 1, 100.0),
      Quiz("Kāds intervāls ir starp notīm Do un Mi bemols?", "Maza terca", "Liela terca", "Samazināta terca", "Palielināta terca", 1, 110.0),
    ],
  };

  // Tercas - Bank 2 (Applying learned material and harmonic concepts)
  static Map<int, List<Quiz>> tercasBank2 = {
    1: [
      Quiz("Liela terca + maza terca veido:", "Mažora trijskani", "Minora trijskani", "Septītkolu akordu", "Nonam", 1, 70.0),
      Quiz("Maza terca + liela terca veido:", "Minora trijskani", "Mažora trijskani", "Septītkolu akordu", "Dimiņatīvu", 1, 80.0),
      Quiz("Kura no šīm ir liela terca?", "Do - Mi", "Do - Mi bemols", "Do - Re", "Do - Fa", 1, 90.0),
      Quiz("Kura no šīm ir maza terca?", "Do - Mi bemols", "Do - Mi", "Do - Re", "Do - Sol", 1, 100.0),
      Quiz("Tercā ir standarta izvietojums:", "Viena veselā tona + pusi tona", "Divi pustoņi", "Pusstona + veselais tonis", "Trīs pustoņi", 1, 110.0),
    ],
    2: [
      Quiz("Ja Do ir tercas pamatne, virsotne ir:", "Mi (lielā tercā)", "Mi bemols (mazā tercā)", "Fa (kvartā)", "Sol (kvintā)", 1, 70.0),
      Quiz("Kā izskatās tercas intervāla attālums uz klaviātueras?", "Trīs taustiņi starp notīm", "Divi taustiņi starp notīm", "Pieci taustiņi starp notīm", "Četri taustiņi starp notīm", 1, 80.0),
      Quiz("Tercas nozīme mūzikā ir:", "Pamats harmonijai", "Tikai dekoratīvs elements", "Melodijas pamats", "Ritma noteikšana", 1, 90.0),
      Quiz("Praktiska modeļa atsauce mazajai tercai ir:", "Dzeguzes kūkošana", "Happy Birthday", "Zinātnes himna", "Nacionālā himna", 1, 100.0),
      Quiz("Praktiska modeļa atsauce lielajai tercai ir:", "Happy Birthday - pīpju diena", "Dzeguzes kūkošana", "Nationālā himna", "Skalas meliorācija", 1, 110.0),
    ],
  };

  // Kvartas - Bank 1 (Consolidating new information)
  static Map<int, List<Quiz>> kvartasBank1 = {
    1: [
      Quiz("Cik pustoņu ir tīrā kvartā?", "5 pustoņi", "4 pustoņi", "6 pustoņi",
          "7 pustoņi", 1, 70.0),
      Quiz("Kāds intervāls veidojas starp notīm Do un Fa?", "Tīra kvarta",
          "Palielināta kvarta", "Tīra kvinta", "Samazināta kvarta", 1, 80.0),
      Quiz(
          "Kvartā ir notis apmēram",
          "4 pakāpes attālumā",
          "5 pakāpes attālumā",
          "3 pakāpes attālumā",
          "6 pakāpes attālumā",
          1,
          90.0),
      Quiz("Re un Sol intervāls ir:", "Tīra kvarta", "Liela tercā",
          "Maza tercā", "Sekunda", 2, 100.0),
      Quiz(
          "Kādu pakāpi attiecībā pret pamatni veido kvartas virsotne?",
          "Ceturto pakāpi",
          "Trešo pakāpi",
          "Piekto pakāpi",
          "Otro pakāpi",
          1,
          110.0),
    ],
    2: [
      Quiz("Kā mūzikā apzīmē tīro kvartu?", "P4", "q4", "k4", "K4", 1, 70.0),
      Quiz("Kā mūzikā apzīmē palieleināto kvartu?", "P4+", "A4", "+4", "aug4",
          2, 80.0),
      Quiz("Kura no šīm ir tīra kvarta?", "Do - Fa", "Do - Sol", "Re - Si",
          "Mi - La", 1, 90.0),
      Quiz("Kvarta starp notīm Fa un Si ir:", "Tīra", "Palielināta",
          "Samazināta", "Dubultā", 1, 100.0),
      Quiz("Tīrā kvartā starp notīm Do un Fa ir:", "2.5 toņi", "3 toņi",
          "2 toņi", "3.5 toņi", 2, 110.0),
    ],
    3: [
      Quiz("Starp notīm Sol un Do ir:", "Tīra kvarta", "Palielināta kvarta",
          "Tīra kvinta", "Secunda", 1, 70.0),
      Quiz("Paralēlās kvartas aprēķina no:", "Pirmās pakāpes", "Otrās pakāpes",
          "Ceturtās pakāpes", "Piektās pakāpes", 2, 80.0),
      Quiz("Kvartas pārvēršana paralēlajā ir:", "Tikai augšup", "Tikai lejup",
          "Abos virzienos", "Nav iespējama", 2, 90.0),
      Quiz("Tīra kvarta atbilst intervālam:", "5 pustoņi", "4 pustoņi",
          "6 pustoņi", "7 pustoņi", 1, 100.0),
      Quiz("Palielināta kvarta atbilst intervālam:", "6 pustoņi", "5 pustoņi",
          "7 pustoņi", "4 pustoņi", 2, 110.0),
    ],
  };

  // Kvartas - Bank 2 (Applying learned material)
  static Map<int, List<Quiz>> kvartasBank2 = {
    1: [
      Quiz("Kuras vietas kvartā ir svarīgākās?", "Pamatne un virsotne",
          "Pamatne un vidus", "Vidus un virsotne", "Tikai pamatne", 1, 70.0),
      Quiz("Kvartas pamatne ir:", "Pirmā pakāpe", "Otrā pakāpe",
          "Ceturtā pakāpe", "Trešā pakāpe", 1, 80.0),
      Quiz("Kvartas virsotne atrodas:", "Ceturtajā pakāpē", "Trešajā pakāpē",
          "Piektajā pakāpē", "Otrajā pakāpē", 1, 90.0),
    ],
    2: [
      Quiz("Ja Do ir kvartas pamatne, tad virsotne ir:", "Fa", "Re", "Sol",
          "Mi", 1, 70.0),
      Quiz("Tīrā kvarta skaņ:", "Neitrāla, nedaudz tukša", "Ļoti skaista",
          "Negodīga", "Griezīga", 1, 80.0),
      Quiz("Intervālā Do-Fa ir:", "Tīra kvarta", "Liela tercā",
          "Palielināta kvarta", "Tīra kvinta", 1, 90.0),
    ],
  };

  // Kvintas - Bank 1 (Consolidating new information)
  static Map<int, List<Quiz>> kvintasBank1 = {
    1: [
      Quiz("Cik pustoņu ir tīrā kvintā?", "7 pustoņi", "5 pustoņi", "6 pustoņi",
          "8 pustoņi", 1, 70.0),
      Quiz("Kāds intervāls veidojas starp notīm Do un Sol?", "Tīra kvinta",
          "Samazināta kvinta", "Palielināta kvinta", "Tīra kvarta", 1, 80.0),
      Quiz(
          "Kvintā ir notis apmēram",
          "5 pakāpes attālumā",
          "4 pakāpes attālumā",
          "6 pakāpes attālumā",
          "3 pakāpes attālumā",
          1,
          90.0),
      Quiz("Re un La intervāls ir:", "Tīra kvinta", "Tīra kvarta", "Maza tercā",
          "Liela tercā", 1, 100.0),
      Quiz(
          "Kādu pakāpi attiecībā pret pamatni veido kvintas virsotne?",
          "Piekto pakāpi",
          "Ceturto pakāpi",
          "Trešo pakāpi",
          "Sesto pakāpi",
          1,
          110.0),
    ],
    2: [
      Quiz("Kā mūzikā apzīmē tīro kvintu?", "P5", "q5", "k5", "K5", 1, 70.0),
      Quiz("Kā mūzikā apzīmē sažemināto kvintu?", "P5-", "D5", "-5", "dim5", 2,
          80.0),
      Quiz("Kura no šīm ir tīra kvinta?", "Do - Sol", "Do - Fa", "Re - La",
          "Do - Re", 1, 90.0),
      Quiz("Kvinta starp notīm Sol un Re ir:", "Tīra", "Samazināta",
          "Palielināta", "Dubultā", 1, 100.0),
      Quiz("Tīrā kvintā starp notīm Do un Sol ir:", "3.5 toņi", "4 toņi",
          "3 toņi", "4.5 toņi", 2, 110.0),
    ],
    3: [
      Quiz("Starp notīm Fa un Do ir:", "Tīra kvinta", "Samazināta kvinta",
          "Tīra kvarta", "Sekunda", 1, 70.0),
      Quiz("Paralēlās kvintas aprēķina no:", "Pirmās pakāpes",
          "Piektās pakāpes", "Ceturtās pakāpes", "Otrās pakāpes", 2, 80.0),
      Quiz("Kvintas pārvēršana paralēlajā ir:", "Tikai augšup", "Tikai lejup",
          "Abos virzienos", "Nav iespējama", 2, 90.0),
      Quiz("Tīra kvinta atbilst intervālam:", "7 pustoņi", "5 pustoņi",
          "6 pustoņi", "8 pustoņi", 1, 100.0),
      Quiz("Samazināta kvinta atbilst intervālam:", "6 pustoņi", "7 pustoņi",
          "5 pustoņi", "8 pustoņi", 2, 110.0),
    ],
  };

  // Kvintas - Bank 2 (Applying learned material)
  static Map<int, List<Quiz>> kvintasBank2 = {
    1: [
      Quiz("Kuras vietas kvintā ir svarīgākās?", "Pamatne un virsotne",
          "Pamatne un vidus", "Vidus un virsotne", "Tikai pamatne", 1, 70.0),
      Quiz("Kvintas pamatne ir:", "Pirmā pakāpe", "Otrā pakāpe",
          "Piektā pakāpe", "Ceturtā pakāpe", 1, 80.0),
      Quiz("Kvintas virsotne atrodas:", "Piektajā pakāpē", "Ceturtajā pakāpē",
          "Trešajā pakāpē", "Sestajā pakāpē", 1, 90.0),
    ],
    2: [
      Quiz("Ja Do ir kvintas pamatne, tad virsotne ir:", "Sol", "Fa", "La",
          "Mi", 1, 70.0),
      Quiz("Tīrā kvinta skaņ:", "Spēcīga, konsonate", "Griezīga", "Negodīga",
          "Ļoti skumta", 1, 80.0),
      Quiz("Intervālā Do-Sol ir:", "Tīra kvinta", "Samazināta kvinta",
          "Tīra kvarta", "Liela tercā", 1, 90.0),
    ],
  };

  // Sekstas - Bank 1 (Consolidating new information)
  static Map<int, List<Quiz>> seksasBank1 = {
    1: [
      Quiz("Cik pustoņu ir lielajā sekstā?", "9 pustoņi", "8 pustoņi",
          "7 pustoņi", "10 pustoņu", 1, 70.0),
      Quiz("Cik pustoņu ir mazajā sekstā?", "8 pustoņi", "9 pustoņi",
          "7 pustoņi", "10 pustoņu", 1, 80.0),
      Quiz("Kāds intervāls veidojas starp notīm Do un La?", "Liela seksta",
          "Maza seksta", "Tīra septima", "Sekunda", 1, 90.0),
      Quiz("Do un Ais intervāls ir:", "Maza seksta", "Liela seksta",
          "Palielināta seksta", "Tīra septima", 2, 100.0),
      Quiz(
          "Kādu pakāpi attiecībā pret pamatni veido sekstas virsotne?",
          "Sesto pakāpi",
          "Ceturto pakāpi",
          "Piekto pakāpi",
          "Septīto pakāpi",
          1,
          110.0),
    ],
    2: [
      Quiz("Kā mūzikā apzīmē lielo sekstu?", "M6", "m6", "s6", "S6", 1, 70.0),
      Quiz("Kā mūzikā apzīmē mazo sekstu?", "m6", "M6", "s6", "S6", 2, 80.0),
      Quiz("Kura no šīm ir liela seksta?", "Do - La", "Do - Ais", "Re - Si",
          "Do - Re", 1, 90.0),
      Quiz("Seksta starp notīm Re un Si ir:", "Liela", "Maza", "Palielināta",
          "Samazināta", 1, 100.0),
      Quiz("Lielajā sekstā starp notīm Do un La ir:", "4.5 toņi", "4 toņi",
          "5 toņi", "3.5 toņi", 2, 110.0),
    ],
    3: [
      Quiz("Starp notīm La un Do ir:", "Maza seksta", "Liela seksta",
          "Tīra kvinta", "Sekunda", 1, 70.0),
      Quiz("Paralēlās sekstas aprēķina no:", "Pirmās pakāpes", "Sestās pakāpes",
          "Ceturtās pakāpes", "Otrās pakāpes", 2, 80.0),
      Quiz("Sekstas pārvēršana paralēlajā ir:", "Tikai augšup", "Tikai lejup",
          "Abos virzienos", "Nav iespējama", 2, 90.0),
      Quiz("Liela seksta atbilst intervālam:", "9 pustoņi", "8 pustoņi",
          "7 pustoņi", "10 pustoņu", 1, 100.0),
      Quiz("Maza seksta atbilst intervālam:", "8 pustoņi", "9 pustoņi",
          "7 pustoņi", "10 pustoņu", 2, 110.0),
    ],
  };

  // Sekstas - Bank 2 (Applying learned material)
  static Map<int, List<Quiz>> seksasBank2 = {
    1: [
      Quiz("Kuras vietas sekstā ir svarīgākās?", "Pamatne un virsotne",
          "Pamatne un vidus", "Vidus un virsotne", "Tikai pamatne", 1, 70.0),
      Quiz("Sekstas pamatne ir:", "Pirmā pakāpe", "Otrā pakāpe", "Sestā pakāpe",
          "Ceturtā pakāpe", 1, 80.0),
      Quiz("Sekstas virsotne atrodas:", "Sestajā pakāpē", "Ceturtajā pakāpē",
          "Piektajā pakāpē", "Septīto pakāpē", 1, 90.0),
    ],
    2: [
      Quiz("Ja Do ir sekstas pamatne, tad virsotne ir:", "La", "Sol", "Si",
          "Mi", 1, 70.0),
      Quiz("Liela seksta skaņ:", "Skaista, romantiška", "Griezīga", "Negodīga",
          "Ļoti skumta", 1, 80.0),
      Quiz("Intervālā Do-La ir:", "Liela seksta", "Maza seksta", "Tīra kvinta",
          "Tīra septima", 1, 90.0),
    ],
  };

  // Get next question from bank 1 based on current level
  static Future<Quiz?> getNextBank1Question(
    String topicId,
    int currentLevel,
    List<String> alreadyShown,
  ) async {
    final bank = _getBank1ForTopic(topicId);
    if (bank == null || !bank.containsKey(currentLevel)) {
      return null;
    }

    List<Quiz> questionsAtLevel = bank[currentLevel]!;
    List<Quiz> available = questionsAtLevel
        .where((q) => !alreadyShown.contains(q.cardImage))
        .toList();

    if (available.isEmpty) {
      return null;
    }

    available.shuffle();
    return available.first;
  }

  // Get next question from bank 2 based on level
  static Future<Quiz?> getNextBank2Question(
    String topicId,
    int difficultyLevel,
    List<String> alreadyShown,
  ) async {
    final bank = _getBank2ForTopic(topicId);
    if (bank == null || !bank.containsKey(difficultyLevel)) {
      return null;
    }

    List<Quiz> questionsAtLevel = bank[difficultyLevel]!;
    List<Quiz> available = questionsAtLevel
        .where((q) => !alreadyShown.contains(q.cardImage))
        .toList();

    if (available.isEmpty) {
      return null;
    }

    available.shuffle();
    return available.first;
  }

  // Update progress based on answer
  static QuestionProgress updateProgress(
    QuestionProgress progress,
    bool isCorrect,
    String questionImage,
    bool isBank1,
  ) {
    progress.questionsShownInSession.add(questionImage);

    if (isCorrect) {
      progress.consecutiveCorrect += 1;
      progress.consecutiveWrong = 0;

      if (isBank1) {
        progress.bank1Score += 1;
        // If 3+ correct in a row, increase level
        if (progress.consecutiveCorrect >= 3) {
          progress.currentLevel = (progress.currentLevel + 1);
          progress.consecutiveCorrect = 0;
        }
      } else {
        progress.bank2Score += 1;
      }
    } else {
      progress.consecutiveWrong += 1;
      progress.consecutiveCorrect = 0;

      // If 2 wrong in a row, decrease level by 1 (only for bank 1)
      if (isBank1 && progress.consecutiveWrong >= 2) {
        progress.currentLevel = (progress.currentLevel - 1).clamp(1, 999);
        progress.consecutiveWrong = 0;
      }
    }

    return progress;
  }

  // Determine bank 2 difficulty based on bank 1 score
  static int getBank2DifficultyFromBank1Score(int bank1Score) {
    // If less than 5 points from 7 questions, offer difficulty 1
    if (bank1Score < 5) {
      return 1;
    }
    // Otherwise offer difficulty 2
    return 2;
  }

  // Get next bank 2 difficulty after correct answer
  static int getNextBank2Difficulty(int currentDifficulty, int maxDifficulty) {
    if (currentDifficulty < maxDifficulty) {
      return currentDifficulty + 1;
    }
    // Stay at max difficulty if already there
    return currentDifficulty;
  }

  // Helper to get bank 1 for a topic
  static Map<int, List<Quiz>>? _getBank1ForTopic(String topicId) {
    switch (topicId) {
      case 'Tercas':
        return tercasBank1;
      case 'Kvartas':
        return kvartasBank1;
      case 'Kvintas':
        return kvintasBank1;
      case 'Sekstas':
        return seksasBank1;
      default:
        return null;
    }
  }

  // Helper to get bank 2 for a topic
  static Map<int, List<Quiz>>? _getBank2ForTopic(String topicId) {
    switch (topicId) {
      case 'Tercas':
        return tercasBank2;
      case 'Kvartas':
        return kvartasBank2;
      case 'Kvintas':
        return kvintasBank2;
      case 'Sekstas':
        return seksasBank2;
      default:
        return null;
    }
  }

  // Save progress to persistent storage
  static Future<void> saveProgress(QuestionProgress progress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${progress.topicId}_level', progress.currentLevel);
    await prefs.setInt(
        '${progress.topicId}_consec_correct', progress.consecutiveCorrect);
    await prefs.setInt(
        '${progress.topicId}_consec_wrong', progress.consecutiveWrong);
    await prefs.setBool(
        '${progress.topicId}_started', progress.hasStartedTopic);
  }

  // Load progress from persistent storage
  static Future<QuestionProgress> loadProgress(String topicId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return QuestionProgress(
      topicId: topicId,
      currentLevel: prefs.getInt('${topicId}_level') ?? 1,
      consecutiveCorrect: prefs.getInt('${topicId}_consec_correct') ?? 0,
      consecutiveWrong: prefs.getInt('${topicId}_consec_wrong') ?? 0,
      hasStartedTopic: prefs.getBool('${topicId}_started') ?? false,
    );
  }

  // Reset all progress
  static Future<void> resetAllProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    for (String key in keys) {
      if (key.contains('_level') ||
          key.contains('_consec') ||
          key.contains('_started') ||
          key.contains('_correct_answers')) {
        await prefs.remove(key);
      }
    }
  }
}
