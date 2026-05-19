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
    final sessionId = (json['sessionId'] ??
            json['id'] ??
            json['examSessionId'] ??
            '')
        .toString();

    final duration = (json['durationMinutes'] as num?)?.toInt() ??
        (json['remainingMinutes'] as num?)?.toInt() ??
        fallbackDurationMinutes;

    final questionsJson = json['questions'] as List? ??
        json['examQuestions'] as List? ??
        [];

    return ExamSessionModel(
      sessionId: sessionId,
      examId: (json['examId'] ?? examId).toString(),
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
  final List<ExamOptionDto> options;

  const ExamQuestionDto({
    required this.id,
    required this.content,
    required this.options,
  });

  factory ExamQuestionDto.fromJson(Map<String, dynamic> json) {
    final optionsJson = json['options'] as List? ?? [];
    return ExamQuestionDto(
      id: (json['id'] ?? json['questionId'] ?? '').toString(),
      content: (json['content'] ?? json['questionContent'] ?? '').toString(),
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

  const ExamOptionDto({
    required this.id,
    required this.content,
    required this.orderIndex,
  });

  factory ExamOptionDto.fromJson(Map<String, dynamic> json) {
    return ExamOptionDto(
      id: (json['id'] ?? json['optionId'] ?? '').toString(),
      content: (json['content'] ?? json['text'] ?? '').toString(),
      orderIndex: (json['orderIndex'] as num?)?.toInt() ?? 0,
    );
  }
}

class ExamSubmissionResult {
  final String? submissionId;
  final double? score;
  final double? maxScore;
  final String? status;
  final String? message;

  const ExamSubmissionResult({
    this.submissionId,
    this.score,
    this.maxScore,
    this.status,
    this.message,
  });

  factory ExamSubmissionResult.fromJson(Map<String, dynamic> json) {
    return ExamSubmissionResult(
      submissionId: json['submissionId']?.toString() ?? json['id']?.toString(),
      score: (json['score'] as num?)?.toDouble() ??
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
