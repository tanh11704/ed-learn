import 'package:equatable/equatable.dart';

class AssessmentState extends Equatable {
  const AssessmentState({
    this.currentQuestion = 0,
    this.answers = const {},
    this.isSubmitting = false,
  });

  final int currentQuestion;
  final Map<int, int> answers;
  final bool isSubmitting;

  AssessmentState copyWith({
    int? currentQuestion,
    Map<int, int>? answers,
    bool? isSubmitting,
  }) {
    return AssessmentState(
      currentQuestion: currentQuestion ?? this.currentQuestion,
      answers: answers ?? this.answers,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [currentQuestion, answers, isSubmitting];
}
