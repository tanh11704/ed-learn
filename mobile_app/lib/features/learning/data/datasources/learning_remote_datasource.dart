import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/core/network/api_config.dart';
import '../../../../core/services/token_storage_service.dart';
import '../models/course_models.dart';
import '../models/flashcard_model.dart';
import '../models/quiz_question_model.dart';

abstract class LearningRemoteDataSource {
  Future<List<CourseSummary>> getCourses({String? subject, int page, int size});
  Future<CourseDetail> getCourseDetail(String courseId);
  Future<void> enrollCourse(String courseId);
  Future<List<CourseSummary>> getMyCourses();
  Future<LessonDetail> playLesson(String lessonId);
  Future<void> completeLesson(String lessonId);
  Future<List<Flashcard>> getLessonFlashcards(
    String lessonId,
    String moduleName,
  );
  Future<List<QuizQuestion>> getLessonExercises(String lessonId);
}

class LearningRemoteDataSourceImpl implements LearningRemoteDataSource {
  final String baseUrl = ApiConfig.baseUrl;

  @override
  Future<List<CourseSummary>> getCourses({
    String? subject,
    int page = 0,
    int size = 10,
  }) async {
    final subjectQuery = (subject != null && subject.trim().isNotEmpty)
        ? '&subject=${Uri.encodeComponent(subject.trim())}'
        : '';

    final response = await http
        .get(
          Uri.parse('$baseUrl/courses?page=$page&size=$size$subjectQuery'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        )
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw Exception('Request timeout'),
        );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final content = jsonResponse['content'] as List? ?? [];
      return content
          .map(
            (item) =>
                CourseSummary.fromCourseJson(item as Map<String, dynamic>),
          )
          .toList();
    }

    throw Exception('Get courses failed: ${response.statusCode}');
  }

  @override
  Future<CourseDetail> getCourseDetail(String courseId) async {
    final response = await http
        .get(
          Uri.parse('$baseUrl/courses/$courseId'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        )
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw Exception('Request timeout'),
        );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return CourseDetail.fromJson(jsonResponse);
    }

    throw Exception('Get course detail failed: ${response.statusCode}');
  }

  @override
  Future<void> enrollCourse(String courseId) async {
    final tokenStorage = TokenStorageService();
    final accessToken = await tokenStorage.getAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found. Please login again.');
    }

    final response = await http
        .post(
          Uri.parse('$baseUrl/courses/$courseId/enroll'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        )
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw Exception('Request timeout'),
        );

    if (response.statusCode != 200) {
      throw Exception('Enroll course failed: ${response.statusCode}');
    }
  }

  @override
  Future<List<CourseSummary>> getMyCourses() async {
    final tokenStorage = TokenStorageService();
    final accessToken = await tokenStorage.getAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found. Please login again.');
    }

    final response = await http
        .get(
          Uri.parse('$baseUrl/users/my-courses'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        )
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw Exception('Request timeout'),
        );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as List<dynamic>;
      return jsonResponse
          .map(
            (item) =>
                CourseSummary.fromEnrolledJson(item as Map<String, dynamic>),
          )
          .toList();
    }

    throw Exception('Get my courses failed: ${response.statusCode}');
  }

  @override
  Future<LessonDetail> playLesson(String lessonId) async {
    final tokenStorage = TokenStorageService();
    final accessToken = await tokenStorage.getAccessToken();

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };

    final response = await http
        .get(
          Uri.parse('$baseUrl/learning/lessons/$lessonId/play'),
          headers: headers,
        )
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw Exception('Request timeout'),
        );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return LessonDetail.fromJson(jsonResponse);
    }

    throw Exception('Play lesson failed: ${response.statusCode}');
  }

  @override
  Future<void> completeLesson(String lessonId) async {
    final tokenStorage = TokenStorageService();
    final accessToken = await tokenStorage.getAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found. Please login again.');
    }

    final response = await http
        .post(
          Uri.parse('$baseUrl/learning/lessons/$lessonId/complete'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        )
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw Exception('Request timeout'),
        );

    if (response.statusCode != 200) {
      throw Exception('Complete lesson failed: ${response.statusCode}');
    }
  }

  @override
  Future<List<Flashcard>> getLessonFlashcards(
    String lessonId,
    String moduleName,
  ) async {
    final tokenStorage = TokenStorageService();
    final accessToken = await tokenStorage.getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };

    final paths = [
      '/learning/lessons/$lessonId/content-items?type=FLASHCARD',
      '/lessons/$lessonId/content-items?type=FLASHCARD',
      '/management/lessons/$lessonId/content-items?type=FLASHCARD',
    ];

    Object? lastError;
    for (final path in paths) {
      try {
        final response = await http
            .get(Uri.parse('$baseUrl$path'), headers: headers)
            .timeout(
              const Duration(seconds: 10),
              onTimeout: () => throw Exception('Request timeout'),
            );

        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);
          final items = _extractContentItems(decoded);
          final flashcards = items
              .where(
                (item) =>
                    (item['type'] ?? 'FLASHCARD').toString().toUpperCase() ==
                    'FLASHCARD',
              )
              .map(
                (item) => Flashcard.fromJson(
                  item,
                  fallbackLessonId: lessonId,
                  fallbackModuleName: moduleName,
                ),
              )
              .where(
                (card) =>
                    card.question.trim().isNotEmpty &&
                    card.answer.trim().isNotEmpty,
              )
              .toList();
          if (flashcards.isNotEmpty) {
            return flashcards;
          }
        }

        if (response.statusCode != 404) {
          lastError = 'Get flashcards failed: ${response.statusCode}';
        }
      } catch (e) {
        lastError = e;
      }
    }

    if (lastError != null) {
      throw Exception(lastError.toString());
    }
    return [];
  }

  @override
  Future<List<QuizQuestion>> getLessonExercises(String lessonId) async {
    final tokenStorage = TokenStorageService();
    final accessToken = await tokenStorage.getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };

    final paths = [
      '/learning/lessons/$lessonId/content-items?type=EXERCISE',
      '/lessons/$lessonId/content-items?type=EXERCISE',
      '/management/lessons/$lessonId/content-items?type=EXERCISE',
    ];

    Object? lastError;
    for (final path in paths) {
      try {
        final response = await http
            .get(Uri.parse('$baseUrl$path'), headers: headers)
            .timeout(
              const Duration(seconds: 10),
              onTimeout: () => throw Exception('Request timeout'),
            );

        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);
          final items = _extractContentItems(decoded);
          var fallbackId = 1;
          final questions = items
              .where(
                (item) =>
                    (item['type'] ?? 'EXERCISE').toString().toUpperCase() ==
                    'EXERCISE',
              )
              .map(
                (item) => QuizQuestion.fromJson(item, fallbackId: fallbackId++),
              )
              .where(
                (question) =>
                    question.question.trim().isNotEmpty &&
                    question.options.length >= 2 &&
                    question.correctAnswer.trim().isNotEmpty,
              )
              .toList();
          if (questions.isNotEmpty) {
            return questions;
          }
        }

        if (response.statusCode != 404) {
          lastError = 'Get exercises failed: ${response.statusCode}';
        }
      } catch (e) {
        lastError = e;
      }
    }

    if (lastError != null) {
      throw Exception(lastError.toString());
    }
    return [];
  }

  List<Map<String, dynamic>> _extractContentItems(dynamic decoded) {
    final dynamic source = decoded is Map<String, dynamic>
        ? (decoded['content'] ??
              decoded['items'] ??
              decoded['data'] ??
              decoded['flashcards'] ??
              decoded)
        : decoded;

    if (source is List) {
      return source
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }

    if (source is Map<String, dynamic>) {
      return [source];
    }

    return [];
  }
}
