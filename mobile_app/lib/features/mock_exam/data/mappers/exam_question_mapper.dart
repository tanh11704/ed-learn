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

List<ExamQuestionDto> fallbackQuestionDtos() {
  return const [
    ExamQuestionDto(
      id: 'q1',
      content:
          'Trong các đặc điểm sau đây, đặc điểm nào là quan trọng nhất để phân biệt một hợp chất hữu cơ với một hợp chất vô cơ?',
      options: [
        ExamOptionDto(id: 'opt-a1', content: 'Khả năng tan trong nước', orderIndex: 0),
        ExamOptionDto(
            id: 'opt-b1',
            content: 'Sự hiện diện của nguyên tố Carbon',
            orderIndex: 1),
        ExamOptionDto(
            id: 'opt-c1',
            content: 'Trạng thái vật lý ở nhiệt độ thường',
            orderIndex: 2),
        ExamOptionDto(
            id: 'opt-d1', content: 'Màu sắc đặc trưng của hợp chất', orderIndex: 3),
      ],
    ),
    ExamQuestionDto(
      id: 'q2',
      content: 'Hợp chất nào sau đây là hợp chất hữu cơ?',
      options: [
        ExamOptionDto(id: 'opt-a2', content: 'CO2', orderIndex: 0),
        ExamOptionDto(id: 'opt-b2', content: 'NaCl', orderIndex: 1),
        ExamOptionDto(id: 'opt-c2', content: 'CH4', orderIndex: 2),
        ExamOptionDto(id: 'opt-d2', content: 'H2SO4', orderIndex: 3),
      ],
    ),
    ExamQuestionDto(
      id: 'q3',
      content: 'Đặc trưng của liên kết trong hợp chất hữu cơ là gì?',
      options: [
        ExamOptionDto(id: 'opt-a3', content: 'Liên kết ion', orderIndex: 0),
        ExamOptionDto(id: 'opt-b3', content: 'Liên kết cộng hoá trị', orderIndex: 1),
        ExamOptionDto(id: 'opt-c3', content: 'Liên kết kim loại', orderIndex: 2),
        ExamOptionDto(id: 'opt-d3', content: 'Liên kết hidro', orderIndex: 3),
      ],
    ),
  ];
}
