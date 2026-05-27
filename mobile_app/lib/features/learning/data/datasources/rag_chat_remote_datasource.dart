import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_app/core/network/api_config.dart';

class RagChatRemoteDataSource {
  final http.Client _client;

  RagChatRemoteDataSource({http.Client? client}) : _client = client ?? http.Client();

  Future<RagChatResponse> chat({
    required String courseId,
    String? lessonId,
    required String question,
    required List<RagChatMessage> chatHistory,
  }) async {
    final response = await _client
        .post(
          Uri.parse('${ApiConfig.aiServiceBaseUrl}/api/v1/chat'),
          headers: const {
            'Content-Type': 'application/json',
            'X-AI-Service-Key': ApiConfig.aiServiceKey,
          },
          body: jsonEncode({
            'user_id': 'mobile-student',
            'course_id': courseId,
            if (lessonId != null && lessonId.isNotEmpty) 'lesson_id': lessonId,
            'question': question,
            'chat_history': chatHistory
                .map((message) => {
                      'role': message.role,
                      'content': message.content,
                    })
                .toList(),
          }),
        )
        .timeout(ApiConfig.requestTimeout);

    final body = response.body.isEmpty ? null : jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_errorMessage(response.statusCode, body));
    }

    return RagChatResponse.fromJson(body as Map<String, dynamic>);
  }

  String _errorMessage(int statusCode, Object? body) {
    if (body is Map<String, dynamic>) {
      final message = body['message'] ?? body['error'];
      if (message != null) return message.toString();
    }
    if (statusCode == 401) return 'Không có quyền gọi AI service.';
    if (statusCode == 422) return 'Nội dung gửi lên chưa đúng định dạng.';
    if (statusCode == 503) return 'AI tạm thời chưa sẵn sàng. Vui lòng thử lại.';
    return 'AI service lỗi HTTP $statusCode.';
  }
}

class RagChatMessage {
  final String role;
  final String content;
  final List<RagSource> sources;
  final double? confidence;
  final bool usedFallback;

  const RagChatMessage({
    required this.role,
    required this.content,
    this.sources = const [],
    this.confidence,
    this.usedFallback = false,
  });
}

class RagChatResponse {
  final String answer;
  final List<RagSource> sources;
  final double? confidence;
  final bool usedFallback;

  const RagChatResponse({
    required this.answer,
    required this.sources,
    this.confidence,
    required this.usedFallback,
  });

  factory RagChatResponse.fromJson(Map<String, dynamic> json) {
    final sourcesJson = json['sources'] as List? ?? [];
    return RagChatResponse(
      answer: (json['answer'] ?? '').toString(),
      sources: sourcesJson
          .map((source) => RagSource.fromJson(source as Map<String, dynamic>))
          .toList(),
      confidence: (json['confidence'] as num?)?.toDouble(),
      usedFallback: json['used_fallback'] as bool? ?? false,
    );
  }
}

class RagSource {
  final String chunkId;
  final String lessonTitle;
  final String sectionTitle;
  final String sectionType;
  final double score;
  final String text;

  const RagSource({
    required this.chunkId,
    required this.lessonTitle,
    required this.sectionTitle,
    required this.sectionType,
    required this.score,
    required this.text,
  });

  factory RagSource.fromJson(Map<String, dynamic> json) {
    return RagSource(
      chunkId: (json['chunk_id'] ?? '').toString(),
      lessonTitle: (json['lesson_title'] ?? '').toString(),
      sectionTitle: (json['section_title'] ?? '').toString(),
      sectionType: (json['section_type'] ?? '').toString(),
      score: (json['score'] as num?)?.toDouble() ?? 0,
      text: (json['text'] ?? '').toString(),
    );
  }
}
