import 'package:equatable/equatable.dart';

class SolutionStepEntity extends Equatable {
  final int stepNumber;
  final String title;
  final String description;
  final String? formula;

  const SolutionStepEntity({
    required this.stepNumber,
    required this.title,
    required this.description,
    this.formula,
  });

  @override
  List<Object?> get props => [stepNumber, title, description, formula];
}

class SolutionEntity extends Equatable {
  final String question;
  final String answer;
  final List<SolutionStepEntity> steps;

  const SolutionEntity({
    required this.question,
    required this.answer,
    required this.steps,
  });

  @override
  List<Object?> get props => [question, answer, steps];
}
