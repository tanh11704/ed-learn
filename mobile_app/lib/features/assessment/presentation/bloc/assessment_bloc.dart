import 'package:flutter_bloc/flutter_bloc.dart';

import 'assessment_event.dart';
import 'assessment_state.dart';

class AssessmentBloc extends Bloc<AssessmentEvent, AssessmentState> {
  AssessmentBloc() : super(const AssessmentState()) {
    on<AssessmentStarted>(_onStarted);
    on<AnswerSelected>(_onAnswerSelected);
    on<AssessmentSubmitted>(_onSubmitted);
  }

  void _onStarted(AssessmentStarted event, Emitter<AssessmentState> emit) {
    emit(const AssessmentState());
  }

  void _onAnswerSelected(AnswerSelected event, Emitter<AssessmentState> emit) {
    final updatedAnswers = Map<int, int>.from(state.answers);
    updatedAnswers[event.questionIndex] = event.optionIndex;
    emit(state.copyWith(answers: updatedAnswers, currentQuestion: event.questionIndex));
  }

  Future<void> _onSubmitted(AssessmentSubmitted event, Emitter<AssessmentState> emit) async {
    emit(state.copyWith(isSubmitting: true));
    await Future<void>.delayed(const Duration(milliseconds: 800));
    emit(state.copyWith(isSubmitting: false));
  }
}
