import 'dart:convert';

import 'package:mobile_app/core/network/api_client.dart';

import '../models/top_course_model.dart';

abstract class StatisticsRemoteDataSource {
  Future<List<TopCourseModel>> getTopCourses();
}

class StatisticsRemoteDataSourceImpl implements StatisticsRemoteDataSource {
  StatisticsRemoteDataSourceImpl({ApiClient? apiClient})
    : _client = apiClient ?? ApiClient();

  final ApiClient _client;

  @override
  Future<List<TopCourseModel>> getTopCourses() async {
    final response = await _client.get('/statistics/top-courses');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final list = decoded is List ? decoded : <dynamic>[];
      return list
          .map((e) => TopCourseModel.fromJson(e as Map<String, dynamic>))
          .where((c) => c.courseId.isNotEmpty)
          .toList();
    }

    throw Exception('Get top courses failed: ${response.statusCode}');
  }
}
