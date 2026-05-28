import 'package:flutter/material.dart';

import '../models/exam_api_model.dart';

class Exam {
  final String id;
  final String title;
  final String subtitle;
  final String level;
  final Color levelColor;
  final String time;
  final String questions;
  final String taken;
  final String subjectId;
  final int durationMinutes;

  Exam({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.level,
    required this.levelColor,
    required this.time,
    required this.questions,
    required this.taken,
    required this.subjectId,
    this.durationMinutes = 45,
  });

  factory Exam.fromApi(ExamApiModel api) {
    final status = (api.status ?? 'PUBLISHED').toUpperCase();
    final (level, levelColor) = _levelFromStatus(status);
    final yearLabel = api.schoolYear != null ? ' • ${api.schoolYear}' : '';

    return Exam(
      id: api.id,
      title: api.title,
      subtitle: api.description?.trim().isNotEmpty == true
          ? api.description!
          : '${api.subject}$yearLabel',
      level: level,
      levelColor: levelColor,
      time: api.durationMinutes > 0 ? '${api.durationMinutes} phút' : '—',
      questions: api.totalQuestions > 0
          ? '${api.totalQuestions} câu hỏi'
          : 'Chưa có câu hỏi',
      taken: status == 'PUBLISHED' ? 'Đang mở' : status,
      subjectId: _subjectKey(api.subject),
      durationMinutes: api.durationMinutes > 0 ? api.durationMinutes : 45,
    );
  }

  static String _subjectKey(String subject) =>
      subject.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');

  static (String, Color) _levelFromStatus(String status) {
    switch (status) {
      case 'PUBLISHED':
        return ('ĐANG MỞ', const Color(0xFF1CC88A));
      case 'ARCHIVED':
        return ('LƯU TRỮ', const Color(0xFF858796));
      default:
        return ('BẢN NHÁP', const Color(0xFFFF6B6B));
    }
  }
}
