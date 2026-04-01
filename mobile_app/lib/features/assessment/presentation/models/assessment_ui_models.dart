class UniversityUi {
  final int id;
  final String name;
  final String location;

  const UniversityUi({
    required this.id,
    required this.name,
    required this.location,
  });
}

class AssessmentQuestionUi {
  final int id;
  final String content;
  final List<String> options;

  const AssessmentQuestionUi({
    required this.id,
    required this.content,
    required this.options,
  });
}
