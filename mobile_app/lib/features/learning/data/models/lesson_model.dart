enum LessonStatus { completed, available, locked }

enum LessonType { video, exercise, flashcard }

class Lesson {
  final String id;
  final String name;
  final String duration;
  final LessonStatus status;
  final String? progress; // Percentage string like "30%"
  final LessonType type;
  final String? description;
  final String? videoUrl;
  final String? instructorName;
  final double? difficulty; // 1.0 to 5.0
  final String title;

  Lesson({
    required this.id,
    required this.name,
    required this.duration,
    required this.status,
    this.progress,
    required this.type,
    this.description,
    this.videoUrl,
    this.instructorName,
    this.difficulty,
    this.title = '',
  });

  // Factory constructor from JSON
  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      name: json['name'] as String,
      duration: json['duration'] as String,
      status: LessonStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => LessonStatus.locked,
      ),
      progress: json['progress'] as String?,
      type: LessonType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => LessonType.video,
      ),
      description: json['description'] as String?,
      videoUrl: json['videoUrl'] as String?,
      instructorName: json['instructorName'] as String?,
      difficulty: (json['difficulty'] as num?)?.toDouble(),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'status': status.toString().split('.').last,
      'progress': progress,
      'type': type.toString().split('.').last,
      'description': description,
      'videoUrl': videoUrl,
      'instructorName': instructorName,
      'difficulty': difficulty,
    };
  }

  // Copy with method
  Lesson copyWith({
    String? id,
    String? name,
    String? duration,
    LessonStatus? status,
    String? progress,
    LessonType? type,
    String? description,
    String? videoUrl,
    String? instructorName,
    double? difficulty,
  }) {
    return Lesson(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      type: type ?? this.type,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      instructorName: instructorName ?? this.instructorName,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  // Helper getters
  bool get isCompleted => status == LessonStatus.completed;
  bool get isAvailable => status == LessonStatus.available;
  bool get isLocked => status == LessonStatus.locked;
  bool get isVideo => type == LessonType.video;
  bool get isExercise => type == LessonType.exercise;
  bool get isFlashcard => type == LessonType.flashcard;
}
