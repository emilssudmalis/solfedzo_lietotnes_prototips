class NewQuizModel {
  var quizName = "";
  var shortDescription = "";
  var quizImage = "";
  var totalQuiz = "";
}

class QuizTestModel {
  var heading = "";
  var image = "";
  var description = "";
  var type = "";
  var status = "";
}

class QuizRecentSearchDataModel {
  var name = "";
}

class QuizBadgesModel {
  var title = "";
  var subtitle = "";
  var img = "";
}

class QuizScoresModel {
  var title = "";
  var shortDescription = "";
  var img = "";
  var scores = "";
  var totalQuiz = "";
}

class QuizContactUsModel {
  var title = "";
  var subtitle = "";
}

// New models for Solfego learning algorithm

class Topic {
  String id;
  String name;
  String description;
  String image;
  String fact; // Interesting fact for loading screen (main fact)
  List<String>? facts; // Multiple facts for randomization
  String goal; // Achievable result
  String theoryText;
  List<String> theoryImages;
  List<String> categories; // e.g., ['intervals', 'chords']

  Topic({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.fact,
    this.facts,
    required this.goal,
    required this.theoryText,
    required this.theoryImages,
    required this.categories,
  });
}

class Question {
  String id;
  String topicId;
  String text;
  List<String> options;
  int correctIndex;
  int difficulty; // 1-5
  String explanation;
  String category; // 'bank1' or 'bank2'
  bool isValidation; // Is this a validation task (piano input)?
  String? validationType; // Type of validation: 'interval', 'chord', etc.
  List<int>? expectedNotes; // For validation: which notes should be played

  Question({
    required this.id,
    required this.topicId,
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.difficulty,
    required this.explanation,
    required this.category,
    this.isValidation = false,
    this.validationType,
    this.expectedNotes,
  });
}

class UserProgress {
  String topicId;
  int currentLevel; // 1-5 (persistent)
  int consecutiveCorrect; // Persistent
  int consecutiveWrong; // Persistent
  int totalScore; // Persistent session score
  DateTime lastAttempt;
  bool mastered; // Topic mastered?
  bool hasStarted; // Persistent: whether the user has already started this topic
  
  // Session tracking (not persistent)
  int sessionConsecutiveCorrect = 0; // Within current session
  int sessionConsecutiveWrong = 0; // Within current session
  int sessionLevel = 1; // Level for current session
  int sessionScore = 0; // Points in current session
  int levelUpInSession = 0; // Did level increase in this session? (0 = no, 1 = yes)
  Set<String> shownQuestionsInSession = {}; // Questions already shown
  int initialSessionLevel = 1; // Level at start of session

  UserProgress({
    required this.topicId,
    required this.currentLevel,
    required this.consecutiveCorrect,
    required this.consecutiveWrong,
    required this.totalScore,
    required this.lastAttempt,
    required this.mastered,
    this.hasStarted = false,
  });

  Map<String, dynamic> toJson() => {
    'topicId': topicId,
    'currentLevel': currentLevel,
    'consecutiveCorrect': consecutiveCorrect,
    'consecutiveWrong': consecutiveWrong,
    'totalScore': totalScore,
    'lastAttempt': lastAttempt.toIso8601String(),
    'mastered': mastered,
    'hasStarted': hasStarted,
    'initialSessionLevel': initialSessionLevel,
  };

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    final bool inferredStarted = (json['totalScore'] is int && json['totalScore'] as int > 0) ||
        (json['currentLevel'] is int && json['currentLevel'] as int > 1);

    final progress = UserProgress(
      topicId: json['topicId'],
      currentLevel: json['currentLevel'],
      consecutiveCorrect: json['consecutiveCorrect'],
      consecutiveWrong: json['consecutiveWrong'],
      totalScore: json['totalScore'],
      lastAttempt: DateTime.parse(json['lastAttempt']),
      mastered: json['mastered'],
      hasStarted: json['hasStarted'] is bool ? json['hasStarted'] as bool : inferredStarted,
    );
    progress.initialSessionLevel = json['initialSessionLevel'] is int ? json['initialSessionLevel'] as int : 1;
    return progress;
  }
}

class SessionResult {
  String topicId;
  DateTime startTime;
  List<QuestionResult> questionResults;
  int rating; // 1-5 stars
  int score; // 0-10

  SessionResult({
    required this.topicId,
    required this.startTime,
    required this.questionResults,
    required this.rating,
    required this.score,
  });

  Map<String, dynamic> toJson() => {
    'topicId': topicId,
    'startTime': startTime.toIso8601String(),
    'questionResults': questionResults.map((e) => e.toJson()).toList(),
    'rating': rating,
    'score': score,
  };

  factory SessionResult.fromJson(Map<String, dynamic> json) => SessionResult(
    topicId: json['topicId'],
    startTime: DateTime.parse(json['startTime']),
    questionResults: (json['questionResults'] as List).map((e) => QuestionResult.fromJson(e)).toList(),
    rating: json['rating'],
    score: json['score'],
  );
}

class QuestionResult {
  String questionId;
  bool correct;
  int selectedIndex; // For test questions
  int timeTaken; // seconds
  bool isValidation; // Is this a validation task?
  List<int>? pressedNotes; // For validation tasks: which notes were pressed

  QuestionResult({
    required this.questionId,
    required this.correct,
    required this.selectedIndex,
    required this.timeTaken,
    this.isValidation = false,
    this.pressedNotes,
  });

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'correct': correct,
    'selectedIndex': selectedIndex,
    'timeTaken': timeTaken,
    'isValidation': isValidation,
    'pressedNotes': pressedNotes,
  };

  factory QuestionResult.fromJson(Map<String, dynamic> json) => QuestionResult(
    questionId: json['questionId'],
    correct: json['correct'],
    selectedIndex: json['selectedIndex'],
    timeTaken: json['timeTaken'],
    isValidation: json['isValidation'] ?? false,
    pressedNotes: (json['pressedNotes'] as List<dynamic>?)?.map((e) => e as int).toList(),
  );
}
