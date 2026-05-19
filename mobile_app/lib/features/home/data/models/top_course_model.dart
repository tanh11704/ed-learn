class TopCourseModel {
  final String courseId;
  final String title;
  final int totalStudents;

  const TopCourseModel({
    required this.courseId,
    required this.title,
    required this.totalStudents,
  });

  factory TopCourseModel.fromJson(Map<String, dynamic> json) {
    return TopCourseModel(
      courseId: (json['courseId'] ?? json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      totalStudents: (json['totalStudents'] as num?)?.toInt() ?? 0,
    );
  }
}
