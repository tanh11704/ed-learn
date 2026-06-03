import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/mappers/exam_question_mapper.dart';
import '../../../data/repositories/exam_repository.dart';
import '../../../data/repositories/exam_repository_impl.dart';
import 'exam_taking_event.dart';
import 'exam_taking_state.dart';

class ExamTakingBloc extends Bloc<ExamTakingEvent, ExamTakingState> {
  ExamTakingBloc({ExamRepository? repository})
    : _repository = repository ?? ExamRepositoryImpl(),
      super(const ExamTakingLoading()) {
    on<LoadExamTaking>(_onLoadExamTaking);
    on<SelectAnswer>(_onSelectAnswer);
    on<GoToQuestion>(_onGoToQuestion);
    on<TickTimer>(_onTickTimer);
    on<SubmitExam>(_onSubmitExam);
  }

  final ExamRepository _repository;
  Timer? _timer;

  Future<void> _onLoadExamTaking(
    LoadExamTaking event,
    Emitter<ExamTakingState> emit,
  ) async {
    emit(const ExamTakingLoading());
    try {
      final session = await _repository.startExamSession(
        examId: event.examId,
        durationMinutes: event.durationMinutes,
        gradeLevel: event.gradeLevel,
        className: event.className,
      );

      final questions = mapSessionQuestions(session.questions);
      if (questions.isEmpty) {
        emit(const ExamTakingError('Đề thi chưa có câu hỏi'));
        return;
      }

      emit(
        ExamTakingLoaded(
          sessionId: session.sessionId,
          examId: session.examId,
          examTitle: event.examTitle,
          questions: questions,
          currentIndex: 0,
          remainingSeconds: session.durationMinutes * 60,
          selectedAnswers: const {},
        ),
      );

      _timer?.cancel();
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => add(const TickTimer()),
      );
    } catch (e) {
      emit(ExamTakingError(e.toString()));
    }
  }

  Future<void> _onSelectAnswer(
    SelectAnswer event,
    Emitter<ExamTakingState> emit,
  ) async {
    if (state is! ExamTakingLoaded) return;
    final currentState = state as ExamTakingLoaded;
    final updated = Map<int, String>.from(currentState.selectedAnswers);
    updated[event.questionIndex] = event.optionId;

    emit(
      currentState.copyWith(selectedAnswers: updated, clearSubmitError: true),
    );

    final question = currentState.questions[event.questionIndex];
    await _repository.saveDraftAnswer(
      sessionId: currentState.sessionId,
      questionId: question.id,
      optionId: event.optionId,
    );
  }

  void _onGoToQuestion(GoToQuestion event, Emitter<ExamTakingState> emit) {
    if (state is! ExamTakingLoaded) return;
    final currentState = state as ExamTakingLoaded;
    emit(
      currentState.copyWith(
        currentIndex: event.questionIndex,
        clearSubmitError: true,
      ),
    );
  }

  void _onTickTimer(TickTimer event, Emitter<ExamTakingState> emit) {
    if (state is! ExamTakingLoaded) return;
    final currentState = state as ExamTakingLoaded;
    if (currentState.isSubmitting) return;

    final remaining = currentState.remainingSeconds - 1;
    if (remaining <= 0) {
      emit(currentState.copyWith(remainingSeconds: 0));
      add(const SubmitExam());
    } else {
      emit(currentState.copyWith(remainingSeconds: remaining));
    }
  }

  Future<void> _onSubmitExam(
    SubmitExam event,
    Emitter<ExamTakingState> emit,
  ) async {
    if (state is! ExamTakingLoaded) return;
    final currentState = state as ExamTakingLoaded;
    if (currentState.isSubmitting) return;

    emit(currentState.copyWith(isSubmitting: true, clearSubmitError: true));
    _timer?.cancel();

    final answers = currentState.selectedAnswers.entries
        .map(
          (e) =>
              (questionId: currentState.questions[e.key].id, optionId: e.value),
        )
        .toList();

    try {
      final result = await _repository.submitExam(
        sessionId: currentState.sessionId,
        answers: answers,
      );
      emit(
        ExamTakingFinished(result: result, examTitle: currentState.examTitle),
      );
    } catch (e) {
      emit(
        currentState.copyWith(
          isSubmitting: false,
          submitError: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
