import '../../data/models/course_models.dart';

abstract class LearningRepository {
  Future<List<CourseSummary>> getCourses({
    String? subject,
    int page,
    int size,
    bool forceRefresh,
  });
  Future<CourseDetail> getCourseDetail(String courseId, {bool forceRefresh});
  Future<void> enrollCourse(String courseId);
  Future<List<CourseSummary>> getMyCourses({bool forceRefresh});
  Future<LessonDetail> playLesson(String lessonId);
  Future<void> completeLesson(String lessonId);
}
