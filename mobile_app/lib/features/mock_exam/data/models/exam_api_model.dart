/// Model map từ ExamResponse (OpenAPI).
class ExamApiModel {
  final String id;
  final String title;
  final String subject;
  final int? schoolYear;
  final int durationMinutes;
  final int totalQuestions;
  final String? description;
  final String? status;

  const ExamApiModel({
    required this.id,
    required this.title,
    required this.subject,
    this.schoolYear,
    required this.durationMinutes,
    required this.totalQuestions,
    this.description,
    this.status,
  });

  factory ExamApiModel.fromJson(Map<String, dynamic> json) {
    return ExamApiModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      subject: (json['subject'] ?? 'Khác').toString(),
      schoolYear: (json['schoolYear'] as num?)?.toInt(),
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      totalQuestions: (json['totalQuestions'] as num?)?.toInt() ?? 0,
      description: json['description']?.toString(),
      status: json['status']?.toString(),
    );
  }
}
