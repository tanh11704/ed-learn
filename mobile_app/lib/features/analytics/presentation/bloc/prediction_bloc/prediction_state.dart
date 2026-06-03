import 'package:equatable/equatable.dart';

class PredictionState extends Equatable {
  final bool isLoading;
  final ScorePrediction prediction;
  final List<LearningStage> stages;

  const PredictionState({
    required this.isLoading,
    required this.prediction,
    required this.stages,
  });

  @override
  List<Object?> get props => [isLoading, prediction, stages];
}

class ScorePrediction extends Equatable {
  final double score;
  final double accuracy;
  final String targetLabel;
  final String targetDescription;
  final double remainingScore;

  const ScorePrediction({
    required this.score,
    required this.accuracy,
    required this.targetLabel,
    required this.targetDescription,
    required this.remainingScore,
  });

  @override
  List<Object?> get props => [
    score,
    accuracy,
    targetLabel,
    targetDescription,
    remainingScore,
  ];
}

class LearningStage extends Equatable {
  final int index;
  final String title;
  final String description;
  final bool isLocked;
  final String actionLabel;

  const LearningStage({
    required this.index,
    required this.title,
    required this.description,
    required this.isLocked,
    required this.actionLabel,
  });

  @override
  List<Object?> get props => [index, title, description, isLocked, actionLabel];
}
