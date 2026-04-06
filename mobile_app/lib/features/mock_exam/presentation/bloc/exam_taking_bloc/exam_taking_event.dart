import 'package:equatable/equatable.dart';

abstract class ExamTakingEvent extends Equatable {
  const ExamTakingEvent();

  @override
  List<Object?> get props => [];
}

class LoadExamTaking extends ExamTakingEvent {
  const LoadExamTaking();
}

class SelectAnswer extends ExamTakingEvent {
  final int questionIndex;
  final String optionId;

  const SelectAnswer({required this.questionIndex, required this.optionId});

  @override
  List<Object?> get props => [questionIndex, optionId];
}

class GoToQuestion extends ExamTakingEvent {
  final int questionIndex;

  const GoToQuestion(this.questionIndex);

  @override
  List<Object?> get props => [questionIndex];
}

class TickTimer extends ExamTakingEvent {
  const TickTimer();
}
