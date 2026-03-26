import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/config/app_env.dart';
import '../models/university_model.dart';
import '../models/assessment_question_model.dart';

class AssessmentRemoteDataSource {
  AssessmentRemoteDataSource({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: AppEnv.mockApiBaseUrl));

  final Dio _dio;

  Future<List<UniversityModel>> fetchUniversities() async {
    final response = await _dio.get('/universities');
    final data = response.data;

    if (data is List) {
      return data.map((item) => UniversityModel.fromJson(item as Map<String, dynamic>)).toList();
    }

    return [];
  }

  Future<List<AssessmentQuestionModel>> fetchAssessmentQuestions() async {
    try {
      debugPrint('[AssessmentRemote] questions request -> ${_dio.options.baseUrl}/questions');
      final response = await _dio.get('/questions');
      debugPrint('[AssessmentRemote] questions response -> status=${response.statusCode} data=${response.data}');
      final data = response.data;

      if (data is List) {
        return data
            .map((item) => AssessmentQuestionModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      debugPrint('[AssessmentRemote] questions data not list');
      return [];
    } catch (error, stackTrace) {
      debugPrint('[AssessmentRemote] questions error -> $error');
      debugPrint('[AssessmentRemote] questions stack -> $stackTrace');
      rethrow;
    }
  }
}
