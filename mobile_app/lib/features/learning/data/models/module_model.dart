import 'lesson_model.dart';

class Module {
  final String id;
  final String name;
  final String description;
  final List<Lesson> lessons;
  final double progress; // 0.0 to 1.0
  final int completedLessons;
  final String? imageUrl;
  final String? instructor;
  final int durationMinutes;
  final double? rating;

  Module({
    required this.id,
    required this.name,
    required this.description,
    required this.lessons,
    required this.progress,
    required this.completedLessons,
    this.imageUrl,
    this.instructor,
    required this.durationMinutes,
    this.rating,
  });

  // Factory constructor from JSON
  factory Module.fromJson(Map<String, dynamic> json) {
    final lessons = (json['lessons'] as List<dynamic>?)
            ?.map((e) => Lesson.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return Module(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      lessons: lessons,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      completedLessons: json['completedLessons'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String?,
      instructor: json['instructor'] as String?,
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble(),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'lessons': lessons.map((e) => e.toJson()).toList(),
      'progress': progress,
      'completedLessons': completedLessons,
      'imageUrl': imageUrl,
      'instructor': instructor,
      'durationMinutes': durationMinutes,
      'rating': rating,
    };
  }

  // Copy with method
  Module copyWith({
    String? id,
    String? name,
    String? description,
    List<Lesson>? lessons,
    double? progress,
    int? completedLessons,
    String? imageUrl,
    String? instructor,
    int? durationMinutes,
    double? rating,
  }) {
    return Module(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      lessons: lessons ?? this.lessons,
      progress: progress ?? this.progress,
      completedLessons: completedLessons ?? this.completedLessons,
      imageUrl: imageUrl ?? this.imageUrl,
      instructor: instructor ?? this.instructor,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      rating: rating ?? this.rating,
    );
  }

  // Helper getters
  int get totalLessons => lessons.length;
  bool get isCompleted => progress >= 1.0;
  String get progressPercentage => '${(progress * 100).toStringAsFixed(0)}%';
}
