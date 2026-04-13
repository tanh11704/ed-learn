import 'package:equatable/equatable.dart';

class PerformanceState extends Equatable {
  final bool isLoading;
  final CapabilityStats capability;
  final LearningProgress progress;
  final TimeManagementStats timeManagement;

  const PerformanceState({
    required this.isLoading,
    required this.capability,
    required this.progress,
    required this.timeManagement,
  });

  @override
  List<Object?> get props => [isLoading, capability, progress, timeManagement];
}

class CapabilityStats extends Equatable {
  final double overallScore;
  final double improvementPercent;
  final List<RadarSkill> skills;
  final List<SkillInsight> strengths;
  final List<SkillInsight> weaknesses;

  const CapabilityStats({
    required this.overallScore,
    required this.improvementPercent,
    required this.skills,
    required this.strengths,
    required this.weaknesses,
  });

  @override
  List<Object?> get props => [overallScore, improvementPercent, skills, strengths, weaknesses];
}

class RadarSkill extends Equatable {
  final String label;
  final double value;

  const RadarSkill({
    required this.label,
    required this.value,
  });

  @override
  List<Object?> get props => [label, value];
}

class SkillInsight extends Equatable {
  final String title;
  final String subtitle;
  final double progressPercent;

  const SkillInsight({
    required this.title,
    required this.subtitle,
    required this.progressPercent,
  });

  @override
  List<Object?> get props => [title, subtitle, progressPercent];
}

class LearningProgress extends Equatable {
  final double averageScore;
  final double growthPercent;
  final double weeklyScore;
  final double weeklyGrowth;
  final List<ChartPoint> chartPoints;
  final List<TestHistoryItem> history;

  const LearningProgress({
    required this.averageScore,
    required this.growthPercent,
    required this.weeklyScore,
    required this.weeklyGrowth,
    required this.chartPoints,
    required this.history,
  });

  @override
  List<Object?> get props => [averageScore, growthPercent, weeklyScore, weeklyGrowth, chartPoints, history];
}

class ChartPoint extends Equatable {
  final String label;
  final double value;

  const ChartPoint({
    required this.label,
    required this.value,
  });

  @override
  List<Object?> get props => [label, value];
}

class TestHistoryItem extends Equatable {
  final String title;
  final String dateLabel;
  final double score;
  final String status;

  const TestHistoryItem({
    required this.title,
    required this.dateLabel,
    required this.score,
    required this.status,
  });

  @override
  List<Object?> get props => [title, dateLabel, score, status];
}

class TimeManagementStats extends Equatable {
  final double weeklyMinutes;
  final double deltaPercent;
  final List<TimeCategory> categories;

  const TimeManagementStats({
    required this.weeklyMinutes,
    required this.deltaPercent,
    required this.categories,
  });

  @override
  List<Object?> get props => [weeklyMinutes, deltaPercent, categories];
}

class TimeCategory extends Equatable {
  final String label;
  final double average;
  final double userValue;

  const TimeCategory({
    required this.label,
    required this.average,
    required this.userValue,
  });

  @override
  List<Object?> get props => [label, average, userValue];
}
