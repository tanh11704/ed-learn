/// Tham số truyền qua route khi bắt đầu một đợt thi.
class ExamSessionArgs {
  final String examId;
  final String examTitle;
  final int durationMinutes;

  const ExamSessionArgs({
    required this.examId,
    required this.examTitle,
    this.durationMinutes = 45,
  });

  factory ExamSessionArgs.fromExtra(Object? extra) {
    if (extra is ExamSessionArgs) return extra;
    if (extra is Map) {
      return ExamSessionArgs(
        examId: (extra['examId'] ?? '').toString(),
        examTitle: (extra['examTitle'] ?? 'Đề thi').toString(),
        durationMinutes: (extra['durationMinutes'] as num?)?.toInt() ?? 45,
      );
    }
    return const ExamSessionArgs(
      examId: 'demo-exam',
      examTitle: 'Đề thi thử',
    );
  }
}
