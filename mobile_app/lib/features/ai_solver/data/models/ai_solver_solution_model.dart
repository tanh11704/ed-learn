class AiSolverSolution {
  final String detectedQuestion;
  final String answer;
  final List<AiSolverStep> steps;
  final List<String> topicTags;
  final double confidence;
  final bool needsClarification;
  final List<String> warnings;
  final String model;

  const AiSolverSolution({
    required this.detectedQuestion,
    required this.answer,
    required this.steps,
    required this.topicTags,
    required this.confidence,
    required this.needsClarification,
    required this.warnings,
    required this.model,
  });

  factory AiSolverSolution.fromJson(Map<String, dynamic> json) {
    final stepsJson = json['steps'] as List? ?? [];
    return AiSolverSolution(
      detectedQuestion: (json['detected_question'] ?? '').toString(),
      answer: (json['answer'] ?? '').toString(),
      steps: stepsJson
          .map((step) => AiSolverStep.fromJson(step as Map<String, dynamic>))
          .toList(),
      topicTags: (json['topic_tags'] as List? ?? [])
          .map((tag) => tag.toString())
          .toList(),
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
      needsClarification: json['needs_clarification'] as bool? ?? false,
      warnings: (json['warnings'] as List? ?? [])
          .map((warning) => warning.toString())
          .toList(),
      model: (json['model'] ?? '').toString(),
    );
  }
}

class AiSolverStep {
  final String title;
  final String explanation;
  final String? latex;

  const AiSolverStep({
    required this.title,
    required this.explanation,
    this.latex,
  });

  factory AiSolverStep.fromJson(Map<String, dynamic> json) {
    return AiSolverStep(
      title: (json['title'] ?? '').toString(),
      explanation: (json['explanation'] ?? '').toString(),
      latex: json['latex']?.toString(),
    );
  }
}
