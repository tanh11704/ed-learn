import 'package:flutter/material.dart';

class Exam {
  final String id;
  final String title;
  final String subtitle;
  final String level;
  final Color levelColor;
  final String time;
  final String questions;
  final String taken;
  final String subjectId; // Dùng để lọc theo CategoryTabs

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
  });
}