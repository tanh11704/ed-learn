import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/learning/data/models/course_models.dart';

class LearningCacheService {
  static const Duration _cacheTtl = Duration(minutes: 10);
  static const String _coursesCacheKey = 'cached_courses_list';
  static const String _coursesCacheTimeKey = 'cached_courses_list_time';
  static const String _myCoursesCacheKey = 'cached_my_courses_list';
  static const String _myCoursesCacheTimeKey = 'cached_my_courses_list_time';

  Future<List<CourseSummary>?> getCachedCourses() async {
    return _getCachedCourseList(_coursesCacheKey, _coursesCacheTimeKey);
  }

  Future<void> cacheCourses(List<CourseSummary> courses) async {
    await _saveCourseList(_coursesCacheKey, _coursesCacheTimeKey, courses);
  }

  Future<List<CourseSummary>?> getCachedMyCourses() async {
    return _getCachedCourseList(_myCoursesCacheKey, _myCoursesCacheTimeKey);
  }

  Future<void> cacheMyCourses(List<CourseSummary> courses) async {
    await _saveCourseList(_myCoursesCacheKey, _myCoursesCacheTimeKey, courses);
  }

  Future<CourseDetail?> getCachedCourseDetail(String courseId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_courseDetailKey(courseId));
    final timestamp = prefs.getInt(_courseDetailTimeKey(courseId));
    if (jsonString == null || timestamp == null) {
      return null;
    }

    final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    if (DateTime.now().difference(cachedTime) > _cacheTtl) {
      return null;
    }

    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return CourseDetail.fromJson(jsonMap);
  }

  Future<void> cacheCourseDetail(CourseDetail detail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _courseDetailKey(detail.id),
      jsonEncode(detail.toJson()),
    );
    await prefs.setInt(
      _courseDetailTimeKey(detail.id),
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<Set<String>> getCompletedLessonIds(String courseId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_completedLessonsKey(courseId)) ?? [];
    return list.toSet();
  }

  Future<void> addCompletedLesson(String courseId, String lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_completedLessonsKey(courseId)) ?? [];
    if (!current.contains(lessonId)) {
      current.add(lessonId);
      await prefs.setStringList(_completedLessonsKey(courseId), current);
    }
  }

  Future<void> resetCourseCache(String courseId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_courseDetailKey(courseId));
    await prefs.remove(_courseDetailTimeKey(courseId));
  }

  Future<void> clearCourseLists() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_coursesCacheKey);
    await prefs.remove(_coursesCacheTimeKey);
    await prefs.remove(_myCoursesCacheKey);
    await prefs.remove(_myCoursesCacheTimeKey);
  }

  Future<List<CourseSummary>?> _getCachedCourseList(
    String cacheKey,
    String timeKey,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(cacheKey);
    final timestamp = prefs.getInt(timeKey);
    if (jsonString == null || timestamp == null) {
      return null;
    }

    final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    if (DateTime.now().difference(cachedTime) > _cacheTtl) {
      return null;
    }

    final jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((item) => CourseSummary.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveCourseList(
    String cacheKey,
    String timeKey,
    List<CourseSummary> courses,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = courses.map((course) => course.toJson()).toList();
    await prefs.setString(cacheKey, jsonEncode(jsonList));
    await prefs.setInt(timeKey, DateTime.now().millisecondsSinceEpoch);
  }

  String _courseDetailKey(String courseId) => 'cached_course_detail_$courseId';
  String _courseDetailTimeKey(String courseId) =>
      'cached_course_detail_time_$courseId';
  String _completedLessonsKey(String courseId) => 'completed_lessons_$courseId';
}
