import 'package:equatable/equatable.dart';

import '../../../data/models/exam_session_models.dart';

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
  final String? imageUrl;
  final List<ExamAnswerOption> options;

  const ExamQuestion({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.options,
  });

  @override
  List<Object?> get props => [id, content, imageUrl, options];
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
  final String sessionId;
  final String examId;
  final String examTitle;
  final List<ExamQuestion> questions;
  final int currentIndex;
  final int remainingSeconds;
  final Map<int, String> selectedAnswers;
  final bool isSubmitting;
  final String? submitError;

  const ExamTakingLoaded({
    required this.sessionId,
    required this.examId,
    required this.examTitle,
    required this.questions,
    required this.currentIndex,
    required this.remainingSeconds,
    required this.selectedAnswers,
    this.isSubmitting = false,
    this.submitError,
  });

  ExamQuestion get currentQuestion => questions[currentIndex];

  ExamTakingLoaded copyWith({
    String? sessionId,
    String? examId,
    String? examTitle,
    List<ExamQuestion>? questions,
    int? currentIndex,
    int? remainingSeconds,
    Map<int, String>? selectedAnswers,
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
  }) {
    return ExamTakingLoaded(
      sessionId: sessionId ?? this.sessionId,
      examId: examId ?? this.examId,
      examTitle: examTitle ?? this.examTitle,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : submitError ?? this.submitError,
    );
  }

  @override
  List<Object?> get props => [
    sessionId,
    examId,
    examTitle,
    questions,
    currentIndex,
    remainingSeconds,
    selectedAnswers,
    isSubmitting,
    submitError,
  ];
}

class ExamTakingFinished extends ExamTakingState {
  final ExamSubmissionResult result;
  final String examTitle;

  const ExamTakingFinished({required this.result, required this.examTitle});

  @override
  List<Object?> get props => [result, examTitle];
}

class ExamTakingError extends ExamTakingState {
  final String message;

  const ExamTakingError(this.message);

  @override
  List<Object?> get props => [message];
}
