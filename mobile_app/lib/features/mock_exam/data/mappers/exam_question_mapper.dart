import '../../presentation/bloc/exam_taking_bloc/exam_taking_state.dart';
import '../models/exam_session_models.dart';

List<ExamQuestion> mapSessionQuestions(List<ExamQuestionDto> dtos) {
  const labels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
  return dtos.map((dto) {
    final sorted = List<ExamOptionDto>.from(dto.options)
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return ExamQuestion(
      id: dto.id,
      content: dto.content,
      imageUrl: dto.imageUrl,
      options: sorted.asMap().entries.map((entry) {
        final label = labels[entry.key % labels.length];
        return ExamAnswerOption(
          id: entry.value.id,
          label: '$label.',
          text: entry.value.content,
        );
      }).toList(),
    );
  }).toList();
}
