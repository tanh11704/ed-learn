import '../../domain/entities/assessment_question.dart';

class AssessmentQuestionModel extends AssessmentQuestion {
  const AssessmentQuestionModel({
    required super.id,
    required super.content,
    required super.options,
    required super.correctAnswer,
    required super.explanation,
  });

  factory AssessmentQuestionModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final parsedId = rawId is num ? rawId.toInt() : int.tryParse(rawId?.toString() ?? '') ?? 0;
    return AssessmentQuestionModel(
      id: parsedId,
      content: json['content']?.toString() ?? '',
      options: [
        json['option_a']?.toString() ?? '',
        json['option_b']?.toString() ?? '',
        json['option_c']?.toString() ?? '',
        json['option_d']?.toString() ?? '',
      ],
      correctAnswer: json['correct_answer']?.toString() ?? '',
      explanation: json['ai_explanation']?.toString() ?? '',
    );
  }
}
