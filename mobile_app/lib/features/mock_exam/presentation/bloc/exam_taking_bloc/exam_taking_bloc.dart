import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'exam_taking_event.dart';
import 'exam_taking_state.dart';

class ExamTakingBloc extends Bloc<ExamTakingEvent, ExamTakingState> {
  Timer? _timer;

  ExamTakingBloc() : super(const ExamTakingLoading()) {
    on<LoadExamTaking>(_onLoadExamTaking);
    on<SelectAnswer>(_onSelectAnswer);
    on<GoToQuestion>(_onGoToQuestion);
    on<TickTimer>(_onTickTimer);
  }

  void _onLoadExamTaking(LoadExamTaking event, Emitter<ExamTakingState> emit) {
    final questions = _mockQuestions();
    emit(
      ExamTakingLoaded(
        questions: questions,
        currentIndex: 0,
        remainingSeconds: 45 * 60,
        selectedAnswers: const {},
      ),
    );

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => add(const TickTimer()));
  }

  void _onSelectAnswer(SelectAnswer event, Emitter<ExamTakingState> emit) {
    if (state is! ExamTakingLoaded) return;
    final currentState = state as ExamTakingLoaded;
    final updated = Map<int, String>.from(currentState.selectedAnswers);
    updated[event.questionIndex] = event.optionId;
    emit(currentState.copyWith(selectedAnswers: updated));
  }

  void _onGoToQuestion(GoToQuestion event, Emitter<ExamTakingState> emit) {
    if (state is! ExamTakingLoaded) return;
    final currentState = state as ExamTakingLoaded;
    emit(currentState.copyWith(currentIndex: event.questionIndex));
  }

  void _onTickTimer(TickTimer event, Emitter<ExamTakingState> emit) {
    if (state is! ExamTakingLoaded) return;
    final currentState = state as ExamTakingLoaded;
    final remaining = currentState.remainingSeconds - 1;
    if (remaining <= 0) {
      _timer?.cancel();
      emit(const ExamTakingFinished());
    } else {
      emit(currentState.copyWith(remainingSeconds: remaining));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  List<ExamQuestion> _mockQuestions() {
    return const [
      ExamQuestion(
        id: 'q1',
        content:
            'Trong các đặc điểm sau đây, đặc điểm nào là quan trọng nhất để phân biệt một hợp chất hữu cơ với một hợp chất vô cơ?',
        options: [
          ExamAnswerOption(id: 'A', label: 'A.', text: 'Khả năng tan trong nước'),
          ExamAnswerOption(id: 'B', label: 'B.', text: 'Sự hiện diện của nguyên tố Carbon'),
          ExamAnswerOption(id: 'C', label: 'C.', text: 'Trạng thái vật lý ở nhiệt độ thường'),
          ExamAnswerOption(id: 'D', label: 'D.', text: 'Màu sắc đặc trưng của hợp chất'),
        ],
      ),
      ExamQuestion(
        id: 'q2',
        content: 'Hợp chất nào sau đây là hợp chất hữu cơ?',
        options: [
          ExamAnswerOption(id: 'A', label: 'A.', text: 'CO2'),
          ExamAnswerOption(id: 'B', label: 'B.', text: 'NaCl'),
          ExamAnswerOption(id: 'C', label: 'C.', text: 'CH4'),
          ExamAnswerOption(id: 'D', label: 'D.', text: 'H2SO4'),
        ],
      ),
      ExamQuestion(
        id: 'q3',
        content: 'Đặc trưng của liên kết trong hợp chất hữu cơ là gì?',
        options: [
          ExamAnswerOption(id: 'A', label: 'A.', text: 'Liên kết ion'),
          ExamAnswerOption(id: 'B', label: 'B.', text: 'Liên kết cộng hoá trị'),
          ExamAnswerOption(id: 'C', label: 'C.', text: 'Liên kết kim loại'),
          ExamAnswerOption(id: 'D', label: 'D.', text: 'Liên kết hidro'),
        ],
      ),
    ];
  }
}
