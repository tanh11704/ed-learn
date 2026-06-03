import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/performance_bloc/performance_state.dart';

class ProgressLineChart extends StatelessWidget {
  final List<ChartPoint> points;

  const ProgressLineChart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LineChartPainter(points),
      child: SizedBox(
        height: 180,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: points
                .map(
                  (point) => Text(
                    point.label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<ChartPoint> points;

  _LineChartPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final padding = 20.0;
    final chartHeight = size.height - 48;
    final chartWidth = size.width - padding * 2;
    final maxValue = points.map((e) => e.value).reduce(max);
    final minValue = points.map((e) => e.value).reduce(min);
    final range = max(1, maxValue - minValue);

    final linePath = Path();
    final areaPath = Path();

    for (int i = 0; i < points.length; i++) {
      final dx = padding + chartWidth * (i / (points.length - 1));
      final normalized = (points[i].value - minValue) / range;
      final dy = padding + chartHeight * (1 - normalized);
      if (i == 0) {
        linePath.moveTo(dx, dy);
        areaPath.moveTo(dx, size.height - 24);
        areaPath.lineTo(dx, dy);
      } else {
        linePath.lineTo(dx, dy);
        areaPath.lineTo(dx, dy);
      }
      canvas.drawCircle(Offset(dx, dy), 4, Paint()..color = AppColors.primary);
    }

    areaPath.lineTo(padding + chartWidth, size.height - 24);
    areaPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppColors.primary.withValues(alpha: 0.25),
          AppColors.primary.withValues(alpha: 0.05),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawPath(areaPath, fillPaint);
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) =>
      oldDelegate.points != points;
}
