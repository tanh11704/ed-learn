import 'package:equatable/equatable.dart';

abstract class ExamTakingEvent extends Equatable {
  const ExamTakingEvent();

  @override
  List<Object?> get props => [];
}

class LoadExamTaking extends ExamTakingEvent {
  final String examId;
  final String examTitle;
  final int durationMinutes;
  final int gradeLevel;
  final String? className;

  const LoadExamTaking({
    required this.examId,
    required this.examTitle,
    this.durationMinutes = 45,
    this.gradeLevel = 12,
    this.className,
  });

  @override
  List<Object?> get props =>
      [examId, examTitle, durationMinutes, gradeLevel, className];
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

class SubmitExam extends ExamTakingEvent {
  const SubmitExam();
}
