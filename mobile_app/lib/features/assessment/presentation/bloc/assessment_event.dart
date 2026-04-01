import 'package:equatable/equatable.dart';

abstract class AssessmentEvent extends Equatable {
  const AssessmentEvent();

  @override
  List<Object?> get props => [];
}

class AssessmentStarted extends AssessmentEvent {
  const AssessmentStarted();
}

class AnswerSelected extends AssessmentEvent {
  const AnswerSelected({required this.questionIndex, required this.optionIndex});

  final int questionIndex;
  final int optionIndex;

  @override
  List<Object?> get props => [questionIndex, optionIndex];
}

class AssessmentSubmitted extends AssessmentEvent {
  const AssessmentSubmitted();
}
