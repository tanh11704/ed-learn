import 'module_model.dart';

class LearningPath {
  final String id;
  final String name;
  final String description;
  final List<Module> modules;
  final double overallProgress; // 0.0 to 1.0
  final int completedModules;
  final int estimatedHours;
  final String? imageUrl;
  final String? targetExam;
  final List<String> topics;
  final DateTime? startDate;
  final DateTime? endDate;

  LearningPath({
    required this.id,
    required this.name,
    required this.description,
    required this.modules,
    required this.overallProgress,
    required this.completedModules,
    required this.estimatedHours,
    this.imageUrl,
    this.targetExam,
    required this.topics,
    this.startDate,
    this.endDate,
  });

  // Factory constructor from JSON
  factory LearningPath.fromJson(Map<String, dynamic> json) {
    final modules = (json['modules'] as List<dynamic>?)
            ?.map((e) => Module.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return LearningPath(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      modules: modules,
      overallProgress: (json['overallProgress'] as num?)?.toDouble() ?? 0.0,
      completedModules: json['completedModules'] as int? ?? 0,
      estimatedHours: json['estimatedHours'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String?,
      targetExam: json['targetExam'] as String?,
      topics: List<String>.from(json['topics'] as List? ?? []),
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'modules': modules.map((e) => e.toJson()).toList(),
      'overallProgress': overallProgress,
      'completedModules': completedModules,
      'estimatedHours': estimatedHours,
      'imageUrl': imageUrl,
      'targetExam': targetExam,
      'topics': topics,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  // Copy with method
  LearningPath copyWith({
    String? id,
    String? name,
    String? description,
    List<Module>? modules,
    double? overallProgress,
    int? completedModules,
    int? estimatedHours,
    String? imageUrl,
    String? targetExam,
    List<String>? topics,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return LearningPath(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      modules: modules ?? this.modules,
      overallProgress: overallProgress ?? this.overallProgress,
      completedModules: completedModules ?? this.completedModules,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      imageUrl: imageUrl ?? this.imageUrl,
      targetExam: targetExam ?? this.targetExam,
      topics: topics ?? this.topics,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  // Helper getters
  int get totalModules => modules.length;
  bool get isCompleted => overallProgress >= 1.0;
  String get progressPercentage => '${(overallProgress * 100).toStringAsFixed(0)}%';
  bool get isStarted => overallProgress > 0;
}
