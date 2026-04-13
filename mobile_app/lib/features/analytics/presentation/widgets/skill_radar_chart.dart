import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/performance_bloc/performance_state.dart';

class SkillRadarChart extends StatelessWidget {
  final List<RadarSkill> skills;
  final double maxValue;

  const SkillRadarChart({
    super.key,
    required this.skills,
    this.maxValue = 100,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadarPainter(skills: skills, maxValue: maxValue),
      child: SizedBox(
        height: 220,
        width: double.infinity,
        child: Center(
          child: Wrap(
            spacing: 24,
            runSpacing: 16,
            children: skills
                .map(
                  (skill) => Text(
                    skill.label,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final List<RadarSkill> skills;
  final double maxValue;

  _RadarPainter({required this.skills, required this.maxValue});

  @override
  void paint(Canvas canvas, Size size) {
    if (skills.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) * 0.32;
    final axisPaint = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final fillPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, radius * i / 4, axisPaint);
    }

    final angleStep = (2 * pi) / skills.length;

    for (int i = 0; i < skills.length; i++) {
      final angle = -pi / 2 + angleStep * i;
      final axisEnd = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      canvas.drawLine(center, axisEnd, axisPaint);
    }

    final path = Path();
    for (int i = 0; i < skills.length; i++) {
      final angle = -pi / 2 + angleStep * i;
      final normalized = (skills[i].value / maxValue).clamp(0.0, 1.0);
      final point = Offset(
        center.dx + radius * normalized * cos(angle),
        center.dy + radius * normalized * sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawCircle(point, 4, Paint()..color = AppColors.primary);
    }
    path.close();
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) {
    return oldDelegate.skills != skills || oldDelegate.maxValue != maxValue;
  }
}
