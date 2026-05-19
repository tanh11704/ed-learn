class CourseSummary {
  final String id;
  final String title;
  final String? description;
  final String? subject;
  final String? thumbnailUrl;

  CourseSummary({
    required this.id,
    required this.title,
    this.description,
    this.subject,
    this.thumbnailUrl,
  });

  factory CourseSummary.fromCourseJson(Map<String, dynamic> json) {
    return CourseSummary(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: json['description']?.toString(),
      subject: json['subject']?.toString(),
      thumbnailUrl: json['thumbnailUrl']?.toString(),
    );
  }

  factory CourseSummary.fromEnrolledJson(Map<String, dynamic> json) {
    return CourseSummary(
      id: (json['courseId'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      thumbnailUrl: json['thumbnailUrl']?.toString(),
      description: null,
      subject: null,
    );
  }

  factory CourseSummary.fromJson(Map<String, dynamic> json) {
    return CourseSummary(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: json['description']?.toString(),
      subject: json['subject']?.toString(),
      thumbnailUrl: json['thumbnailUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subject': subject,
      'thumbnailUrl': thumbnailUrl,
    };
  }
}

class CourseDetail extends CourseSummary {
  final List<ChapterDetail> chapters;

  CourseDetail({
    required super.id,
    required super.title,
    super.description,
    super.subject,
    super.thumbnailUrl,
    required this.chapters,
  });

  factory CourseDetail.fromJson(Map<String, dynamic> json) {
    final chaptersJson = json['chapters'] as List? ?? [];
    return CourseDetail(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: json['description']?.toString(),
      subject: json['subject']?.toString(),
      thumbnailUrl: json['thumbnailUrl']?.toString(),
      chapters: chaptersJson
          .map((chapter) => ChapterDetail.fromJson(chapter as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subject': subject,
      'thumbnailUrl': thumbnailUrl,
      'chapters': chapters.map((chapter) => chapter.toJson()).toList(),
    };
  }
}

class ChapterDetail {
  final String id;
  final String courseId;
  final String title;
  final int orderIndex;
  final List<LessonDetail> lessons;

  ChapterDetail({
    required this.id,
    required this.courseId,
    required this.title,
    required this.orderIndex,
    required this.lessons,
  });

  factory ChapterDetail.fromJson(Map<String, dynamic> json) {
    final lessonsJson = json['lessons'] as List? ?? [];
    return ChapterDetail(
      id: (json['id'] ?? '').toString(),
      courseId: (json['courseId'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      orderIndex: (json['orderIndex'] as num?)?.toInt() ?? 0,
      lessons: lessonsJson
          .map((lesson) => LessonDetail.fromJson(lesson as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'orderIndex': orderIndex,
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
    };
  }
}

class LessonDetail {
  final String id;
  final String chapterId;
  final String title;
  final String? videoUrl;
  final String? pdfUrl;
  final int orderIndex;
  final bool isPreview;
  final String? description;
  final int? durationMinutes;

  LessonDetail({
    required this.id,
    required this.chapterId,
    required this.title,
    required this.videoUrl,
    required this.pdfUrl,
    required this.orderIndex,
    required this.isPreview,
    this.description,
    this.durationMinutes,
  });

  factory LessonDetail.fromJson(Map<String, dynamic> json) {
    return LessonDetail(
      id: (json['id'] ?? '').toString(),
      chapterId: (json['chapterId'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      videoUrl: json['videoUrl']?.toString(),
      pdfUrl: json['pdfUrl']?.toString(),
      orderIndex: (json['orderIndex'] as num?)?.toInt() ?? 0,
      isPreview: json['isPreview'] as bool? ?? false,
      description: json['description']?.toString(),
      durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapterId': chapterId,
      'title': title,
      'videoUrl': videoUrl,
      'pdfUrl': pdfUrl,
      'orderIndex': orderIndex,
      'isPreview': isPreview,
      'description': description,
      'durationMinutes': durationMinutes,
    };
  }
}
