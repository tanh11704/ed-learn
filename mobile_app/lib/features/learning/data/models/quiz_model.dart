import 'quiz_question_model.dart';

class Quiz {
  final String id;
  final String name;
  final String moduleId;
  final String moduleName;
  final List<QuizQuestion> questions;
  final int timeLimit; // minutes
  final double passingScore; // 0.0 to 1.0
  final String? description;
  final DateTime? createdAt;

  Quiz({
    required this.id,
    required this.name,
    required this.moduleId,
    required this.moduleName,
    required this.questions,
    required this.timeLimit,
    required this.passingScore,
    this.description,
    this.createdAt,
  });

  // Factory constructor from JSON
  factory Quiz.fromJson(Map<String, dynamic> json) {
    final questions = (json['questions'] as List<dynamic>?)
            ?.map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return Quiz(
      id: json['id'] as String,
      name: json['name'] as String,
      moduleId: json['moduleId'] as String,
      moduleName: json['moduleName'] as String,
      questions: questions,
      timeLimit: json['timeLimit'] as int? ?? 60,
      passingScore: (json['passingScore'] as num?)?.toDouble() ?? 0.7,
      description: json['description'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'moduleId': moduleId,
      'moduleName': moduleName,
      'questions': questions.map((e) => e.toJson()).toList(),
      'timeLimit': timeLimit,
      'passingScore': passingScore,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // Copy with method
  Quiz copyWith({
    String? id,
    String? name,
    String? moduleId,
    String? moduleName,
    List<QuizQuestion>? questions,
    int? timeLimit,
    double? passingScore,
    String? description,
    DateTime? createdAt,
  }) {
    return Quiz(
      id: id ?? this.id,
      name: name ?? this.name,
      moduleId: moduleId ?? this.moduleId,
      moduleName: moduleName ?? this.moduleName,
      questions: questions ?? this.questions,
      timeLimit: timeLimit ?? this.timeLimit,
      passingScore: passingScore ?? this.passingScore,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Helper getters
  int get questionCount => questions.length;
  bool get hasQuestions => questions.isNotEmpty;
}

class QuizResult {
  final String quizId;
  final String userId;
  final int correctCount;
  final int totalCount;
  final int timeSpentMinutes;
  final double scorePercentage;
  final bool passed;
  final Map<int, String> userAnswers; // {questionId: answer}
  final DateTime completedAt;

  QuizResult({
    required this.quizId,
    required this.userId,
    required this.correctCount,
    required this.totalCount,
    required this.timeSpentMinutes,
    required this.scorePercentage,
    required this.passed,
    required this.userAnswers,
    required this.completedAt,
  });

  // Factory constructor from JSON
  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      quizId: json['quizId'] as String,
      userId: json['userId'] as String,
      correctCount: json['correctCount'] as int,
      totalCount: json['totalCount'] as int,
      timeSpentMinutes: json['timeSpentMinutes'] as int,
      scorePercentage: (json['scorePercentage'] as num).toDouble(),
      passed: json['passed'] as bool,
      userAnswers: Map<int, String>.from(json['userAnswers'] as Map),
      completedAt: DateTime.parse(json['completedAt'] as String),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'userId': userId,
      'correctCount': correctCount,
      'totalCount': totalCount,
      'timeSpentMinutes': timeSpentMinutes,
      'scorePercentage': scorePercentage,
      'passed': passed,
      'userAnswers': userAnswers,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  // Copy with method
  QuizResult copyWith({
    String? quizId,
    String? userId,
    int? correctCount,
    int? totalCount,
    int? timeSpentMinutes,
    double? scorePercentage,
    bool? passed,
    Map<int, String>? userAnswers,
    DateTime? completedAt,
  }) {
    return QuizResult(
      quizId: quizId ?? this.quizId,
      userId: userId ?? this.userId,
      correctCount: correctCount ?? this.correctCount,
      totalCount: totalCount ?? this.totalCount,
      timeSpentMinutes: timeSpentMinutes ?? this.timeSpentMinutes,
      scorePercentage: scorePercentage ?? this.scorePercentage,
      passed: passed ?? this.passed,
      userAnswers: userAnswers ?? this.userAnswers,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
