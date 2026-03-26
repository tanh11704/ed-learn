class AssessmentQuestion {
  const AssessmentQuestion({
    required this.id,
    required this.content,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  final int id;
  final String content;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
}
