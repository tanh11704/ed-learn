class ExamSessionArgs {
  final String examId;
  final String examTitle;
  final int durationMinutes;
  final int gradeLevel;
  final String? className;

  const ExamSessionArgs({
    required this.examId,
    required this.examTitle,
    this.durationMinutes = 45,
    this.gradeLevel = 12,
    this.className,
  });

  bool get hasValidExamId => RegExp(
        r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
      ).hasMatch(examId);

  factory ExamSessionArgs.fromExtra(Object? extra) {
    if (extra is ExamSessionArgs) return extra;
    if (extra is Map) {
      return ExamSessionArgs(
        examId: (extra['examId'] ?? '').toString(),
        examTitle: (extra['examTitle'] ?? 'Đề thi').toString(),
        durationMinutes: (extra['durationMinutes'] as num?)?.toInt() ?? 45,
        gradeLevel: (extra['gradeLevel'] as num?)?.toInt() ?? 12,
        className: extra['className']?.toString(),
      );
    }
    return const ExamSessionArgs(
      examId: '',
      examTitle: 'Đề thi',
    );
  }
}
