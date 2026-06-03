import 'dart:convert';

import 'package:mobile_app/core/network/api_client.dart';

import '../models/user_task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<UserTaskModel>> getTasksForDate(DateTime date);
  Future<void> markTaskCompleted(String taskId);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  TaskRemoteDataSourceImpl({ApiClient? apiClient})
    : _client = apiClient ?? ApiClient();

  final ApiClient _client;

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  @override
  Future<List<UserTaskModel>> getTasksForDate(DateTime date) async {
    final response = await _client.get(
      '/users/me/tasks',
      queryParameters: {'date': _formatDate(date)},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final list = decoded is List
          ? decoded
          : (decoded is Map ? decoded['content'] as List? : null) ?? [];
      return list
          .map((e) => UserTaskModel.fromJson(e as Map<String, dynamic>))
          .where((t) => t.id.isNotEmpty)
          .toList();
    }

    if (response.statusCode == 404) {
      return [];
    }

    throw Exception('Get tasks failed: ${response.statusCode}');
  }

  @override
  Future<void> markTaskCompleted(String taskId) async {
    final response = await _client.patch(
      '/users/me/tasks/$taskId',
      body: {'isCompleted': true, 'completed': true},
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    }

    throw Exception('Complete task failed: ${response.statusCode}');
  }
}
