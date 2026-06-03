class ExamSessionModel {
  final String sessionId;
  final String examId;
  final int durationMinutes;
  final List<ExamQuestionDto> questions;

  const ExamSessionModel({
    required this.sessionId,
    required this.examId,
    required this.durationMinutes,
    required this.questions,
  });

  factory ExamSessionModel.fromJson(
    Map<String, dynamic> json, {
    required String examId,
    int fallbackDurationMinutes = 45,
  }) {
    final attemptJson = json['attempt'] is Map
        ? json['attempt'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final examJson = json['exam'] is Map
        ? json['exam'] as Map<String, dynamic>
        : const <String, dynamic>{};

    final sessionId =
        (json['sessionId'] ??
                json['id'] ??
                json['examSessionId'] ??
                attemptJson['id'] ??
                '')
            .toString();

    final duration =
        (json['durationMinutes'] as num?)?.toInt() ??
        (examJson['durationMinutes'] as num?)?.toInt() ??
        (json['remainingMinutes'] as num?)?.toInt() ??
        fallbackDurationMinutes;

    final questionsJson =
        json['questions'] as List? ?? json['examQuestions'] as List? ?? [];

    return ExamSessionModel(
      sessionId: sessionId,
      examId:
          (json['examId'] ?? attemptJson['examId'] ?? examJson['id'] ?? examId)
              .toString(),
      durationMinutes: duration,
      questions: questionsJson
          .map((q) => ExamQuestionDto.fromJson(q as Map<String, dynamic>))
          .where((q) => q.id.isNotEmpty)
          .toList(),
    );
  }
}

class ExamQuestionDto {
  final String id;
  final String content;
  final String questionType;
  final String? paperPart;
  final String? imageUrl;
  final double? score;
  final List<ExamOptionDto> options;

  const ExamQuestionDto({
    required this.id,
    required this.content,
    required this.questionType,
    this.paperPart,
    this.imageUrl,
    this.score,
    required this.options,
  });

  factory ExamQuestionDto.fromJson(Map<String, dynamic> json) {
    final optionsJson = json['options'] as List? ?? [];
    return ExamQuestionDto(
      id: (json['id'] ?? json['questionId'] ?? '').toString(),
      content: (json['content'] ?? json['questionContent'] ?? '').toString(),
      questionType: (json['questionType'] ?? 'MULTIPLE_CHOICE').toString(),
      paperPart: json['paperPart']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      score: (json['score'] as num?)?.toDouble(),
      options: optionsJson
          .map((o) => ExamOptionDto.fromJson(o as Map<String, dynamic>))
          .where((o) => o.id.isNotEmpty)
          .toList(),
    );
  }
}

class ExamOptionDto {
  final String id;
  final String content;
  final int orderIndex;
  final bool? isCorrect;

  const ExamOptionDto({
    required this.id,
    required this.content,
    required this.orderIndex,
    this.isCorrect,
  });

  factory ExamOptionDto.fromJson(Map<String, dynamic> json) {
    return ExamOptionDto(
      id: (json['id'] ?? json['optionId'] ?? '').toString(),
      content: (json['content'] ?? json['text'] ?? '').toString(),
      orderIndex: (json['orderIndex'] as num?)?.toInt() ?? 0,
      isCorrect: _boolValue(
        json['isCorrect'] ??
            json['correct'] ??
            json['is_correct'] ??
            json['isAnswer'] ??
            json['is_answer'] ??
            json['correctOption'] ??
            json['correct_option'],
      ),
    );
  }

  static bool? _boolValue(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.toLowerCase().trim();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    return null;
  }
}

class ExamSubmissionResult {
  final String? submissionId;
  final String? examId;
  final double? score;
  final double? maxScore;
  final String? status;
  final String? message;

  const ExamSubmissionResult({
    this.submissionId,
    this.examId,
    this.score,
    this.maxScore,
    this.status,
    this.message,
  });

  factory ExamSubmissionResult.fromJson(Map<String, dynamic> json) {
    return ExamSubmissionResult(
      submissionId: json['submissionId']?.toString() ?? json['id']?.toString(),
      examId: json['examId']?.toString(),
      score:
          (json['score'] as num?)?.toDouble() ??
          (json['totalScore'] as num?)?.toDouble(),
      maxScore: (json['maxScore'] as num?)?.toDouble(),
      status: json['status']?.toString(),
      message: json['message']?.toString(),
    );
  }

  String get scoreLabel {
    if (score == null) return '—';
    if (maxScore != null && maxScore! > 0) {
      return '${score!.toStringAsFixed(1)}/${maxScore!.toStringAsFixed(0)}';
    }
    return score!.toStringAsFixed(1);
  }
}

class ExamAttemptSummary {
  final String id;
  final String examId;
  final String status;
  final double? score;
  final double? maxScore;
  final DateTime? startedAt;
  final DateTime? submittedAt;

  const ExamAttemptSummary({
    required this.id,
    required this.examId,
    required this.status,
    this.score,
    this.maxScore,
    this.startedAt,
    this.submittedAt,
  });

  factory ExamAttemptSummary.fromJson(Map<String, dynamic> json) {
    return ExamAttemptSummary(
      id: (json['id'] ?? '').toString(),
      examId: (json['examId'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      score: (json['score'] as num?)?.toDouble(),
      maxScore: (json['maxScore'] as num?)?.toDouble(),
      startedAt: DateTime.tryParse((json['startedAt'] ?? '').toString()),
      submittedAt: DateTime.tryParse((json['submittedAt'] ?? '').toString()),
    );
  }
}

class ExamAttemptReview {
  final ExamSessionModel session;

  const ExamAttemptReview({required this.session});

  factory ExamAttemptReview.fromJson(Map<String, dynamic> json) {
    return ExamAttemptReview(
      session: ExamSessionModel.fromJson(
        json,
        examId: (json['examId'] ?? '').toString(),
      ),
    );
  }
}
