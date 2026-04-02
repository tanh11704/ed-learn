enum FlashcardDifficulty { easy, medium, hard }

class Flashcard {
  final String id;
  final String question;
  final String answer;
  final String lessonId;
  final String moduleName;
  final FlashcardDifficulty difficulty;
  final int reviewCount; // Số lần ôn tập
  final double? confidenceScore; // 0.0 to 1.0
  final DateTime? lastReviewedAt;
  final DateTime createdAt;
  final String? explanation; // Giải thích chi tiết
  final String? answerImageUrl; // Hình ảnh câu trả lời

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    required this.lessonId,
    required this.moduleName,
    required this.difficulty,
    this.reviewCount = 0,
    this.confidenceScore,
    this.lastReviewedAt,
    DateTime? createdAt,
    this.explanation,
    this.answerImageUrl,
  }) : createdAt = createdAt ?? DateTime.now();

  // Factory constructor from JSON
  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      lessonId: json['lessonId'] as String,
      moduleName: json['moduleName'] as String,
      difficulty: FlashcardDifficulty.values.firstWhere(
        (e) => e.toString().split('.').last == json['difficulty'],
        orElse: () => FlashcardDifficulty.medium,
      ),
      reviewCount: json['reviewCount'] as int? ?? 0,
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble(),
      lastReviewedAt: json['lastReviewedAt'] != null
          ? DateTime.parse(json['lastReviewedAt'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      explanation: json['explanation'] as String?,
      answerImageUrl: json['answerImageUrl'] as String?,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'lessonId': lessonId,
      'moduleName': moduleName,
      'difficulty': difficulty.toString().split('.').last,
      'reviewCount': reviewCount,
      'confidenceScore': confidenceScore,
      'lastReviewedAt': lastReviewedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'explanation': explanation,
      'answerImageUrl': answerImageUrl,
    };
  }

  // Copy with method
  Flashcard copyWith({
    String? id,
    String? question,
    String? answer,
    String? lessonId,
    String? moduleName,
    FlashcardDifficulty? difficulty,
    int? reviewCount,
    double? confidenceScore,
    DateTime? lastReviewedAt,
    DateTime? createdAt,
    String? explanation,
    String? answerImageUrl,
  }) {
    return Flashcard(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      lessonId: lessonId ?? this.lessonId,
      moduleName: moduleName ?? this.moduleName,
      difficulty: difficulty ?? this.difficulty,
      reviewCount: reviewCount ?? this.reviewCount,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      createdAt: createdAt ?? this.createdAt,
      explanation: explanation ?? this.explanation,
      answerImageUrl: answerImageUrl ?? this.answerImageUrl,
    );
  }

  // Helper getters
  bool get needsReview => confidenceScore == null || confidenceScore! < 0.7;
  bool get isEasy => difficulty == FlashcardDifficulty.easy;
  bool get isMedium => difficulty == FlashcardDifficulty.medium;
  bool get isHard => difficulty == FlashcardDifficulty.hard;
  bool get isRecentlyReviewed =>
      lastReviewedAt != null &&
      DateTime.now().difference(lastReviewedAt!).inDays < 1;
}

class FlashcardSet {
  final String id;
  final String name;
  final String lessonId;
  final String moduleName;
  final List<Flashcard> flashcards;
  final double masterScore; // 0.0 to 1.0
  final int totalReviews;
  final DateTime createdAt;
  final DateTime? completedAt;

  FlashcardSet({
    required this.id,
    required this.name,
    required this.lessonId,
    required this.moduleName,
    required this.flashcards,
    this.masterScore = 0.0,
    this.totalReviews = 0,
    DateTime? createdAt,
    this.completedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Factory constructor from JSON
  factory FlashcardSet.fromJson(Map<String, dynamic> json) {
    final flashcards = (json['flashcards'] as List<dynamic>?)
            ?.map((e) => Flashcard.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return FlashcardSet(
      id: json['id'] as String,
      name: json['name'] as String,
      lessonId: json['lessonId'] as String,
      moduleName: json['moduleName'] as String,
      flashcards: flashcards,
      masterScore: (json['masterScore'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['totalReviews'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lessonId': lessonId,
      'moduleName': moduleName,
      'flashcards': flashcards.map((e) => e.toJson()).toList(),
      'masterScore': masterScore,
      'totalReviews': totalReviews,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  // Copy with method
  FlashcardSet copyWith({
    String? id,
    String? name,
    String? lessonId,
    String? moduleName,
    List<Flashcard>? flashcards,
    double? masterScore,
    int? totalReviews,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return FlashcardSet(
      id: id ?? this.id,
      name: name ?? this.name,
      lessonId: lessonId ?? this.lessonId,
      moduleName: moduleName ?? this.moduleName,
      flashcards: flashcards ?? this.flashcards,
      masterScore: masterScore ?? this.masterScore,
      totalReviews: totalReviews ?? this.totalReviews,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  // Helper getters
  int get totalFlashcards => flashcards.length;
  int get masteredCount =>
      flashcards.where((f) => f.confidenceScore != null && f.confidenceScore! >= 0.9).length;
  int get reviewedCount =>
      flashcards.where((f) => f.lastReviewedAt != null).length;
  bool get isCompleted => masterScore >= 0.8;
  List<Flashcard> get needsReviewList =>
      flashcards.where((f) => f.needsReview).toList();
}
