import 'package:equatable/equatable.dart';

class SolutionStep extends Equatable {
  final int stepNumber;
  final String title;
  final String description;
  final String? formula;

  const SolutionStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    this.formula,
  });

  @override
  List<Object?> get props => [stepNumber, title, description, formula];
}

abstract class SolutionState extends Equatable {
  const SolutionState();

  @override
  List<Object?> get props => [];
}

class SolutionInitial extends SolutionState {
  const SolutionInitial();
}

class SolutionLoaded extends SolutionState {
  final String question;
  final String answer;
  final List<SolutionStep> steps;

  const SolutionLoaded({
    required this.question,
    required this.answer,
    required this.steps,
  });

  @override
  List<Object?> get props => [question, answer, steps];
}

class SolutionError extends SolutionState {
  final String message;

  const SolutionError(this.message);

  @override
  List<Object?> get props => [message];
}
