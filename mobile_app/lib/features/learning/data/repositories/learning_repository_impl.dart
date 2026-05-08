import '../../domain/repositories/learning_repository.dart';
import '../../../../core/services/learning_cache_service.dart';
import '../datasources/learning_remote_datasource.dart';
import '../models/course_models.dart';

class LearningRepositoryImpl implements LearningRepository {
  final LearningRemoteDataSource remoteDataSource;
  final LearningCacheService cacheService;

  LearningRepositoryImpl(
    this.remoteDataSource, {
    LearningCacheService? cacheService,
  }) : cacheService = cacheService ?? LearningCacheService();

  @override
  Future<List<CourseSummary>> getCourses({
    String? subject,
    int page = 0,
    int size = 10,
    bool forceRefresh = false,
  }) async {
    final hasFilter = subject != null && subject.trim().isNotEmpty;
    if (!forceRefresh && !hasFilter && page == 0) {
      final cached = await cacheService.getCachedCourses();
      if (cached != null && cached.isNotEmpty) {
        return cached;
      }
    }

    final courses = await remoteDataSource.getCourses(
      subject: subject,
      page: page,
      size: size,
    );

    if (!hasFilter && page == 0) {
      await cacheService.cacheCourses(courses);
    }
    return courses;
  }

  @override
  Future<CourseDetail> getCourseDetail(String courseId, {bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await cacheService.getCachedCourseDetail(courseId);
      if (cached != null) {
        return cached;
      }
    }

    final detail = await remoteDataSource.getCourseDetail(courseId);
    await cacheService.cacheCourseDetail(detail);
    return detail;
  }

  @override
  Future<void> enrollCourse(String courseId) {
    return remoteDataSource.enrollCourse(courseId);
  }

  @override
  Future<List<CourseSummary>> getMyCourses({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await cacheService.getCachedMyCourses();
      if (cached != null) {
        return cached;
      }
    }

    final courses = await remoteDataSource.getMyCourses();
    await cacheService.cacheMyCourses(courses);
    return courses;
  }

  @override
  Future<LessonDetail> playLesson(String lessonId) {
    return remoteDataSource.playLesson(lessonId);
  }

  @override
  Future<void> completeLesson(String lessonId) {
    return remoteDataSource.completeLesson(lessonId);
  }
}
