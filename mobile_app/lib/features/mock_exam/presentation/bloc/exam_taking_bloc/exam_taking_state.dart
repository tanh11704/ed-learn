import 'package:equatable/equatable.dart';

class ExamAnswerOption extends Equatable {
  final String id;
  final String label;
  final String text;

  const ExamAnswerOption({
    required this.id,
    required this.label,
    required this.text,
  });

  @override
  List<Object?> get props => [id, label, text];
}

class ExamQuestion extends Equatable {
  final String id;
  final String content;
  final List<ExamAnswerOption> options;

  const ExamQuestion({
    required this.id,
    required this.content,
    required this.options,
  });

  @override
  List<Object?> get props => [id, content, options];
}

abstract class ExamTakingState extends Equatable {
  const ExamTakingState();

  @override
  List<Object?> get props => [];
}

class ExamTakingLoading extends ExamTakingState {
  const ExamTakingLoading();
}

class ExamTakingLoaded extends ExamTakingState {
  final List<ExamQuestion> questions;
  final int currentIndex;
  final int remainingSeconds;
  final Map<int, String> selectedAnswers;

  const ExamTakingLoaded({
    required this.questions,
    required this.currentIndex,
    required this.remainingSeconds,
    required this.selectedAnswers,
  });

  ExamQuestion get currentQuestion => questions[currentIndex];

  ExamTakingLoaded copyWith({
    List<ExamQuestion>? questions,
    int? currentIndex,
    int? remainingSeconds,
    Map<int, String>? selectedAnswers,
  }) {
    return ExamTakingLoaded(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
    );
  }

  @override
  List<Object?> get props => [questions, currentIndex, remainingSeconds, selectedAnswers];
}

class ExamTakingFinished extends ExamTakingState {
  const ExamTakingFinished();
}
