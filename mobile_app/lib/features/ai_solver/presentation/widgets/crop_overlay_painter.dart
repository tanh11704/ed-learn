import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CropOverlayPainter extends CustomPainter {
  final Rect? cropRect;
  final Color borderColor;
  final double cornerLength;
  final double strokeWidth;

  CropOverlayPainter({
    this.cropRect,
    this.borderColor = AppColors.primary,
    this.cornerLength = 22,
    this.strokeWidth = 2.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = cropRect ??
        Rect.fromLTWH(
          24,
          24,
          size.width - 48,
          size.height - 48,
        );

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawRect(rect, borderPaint);

    final cornerPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 0.5
      ..strokeCap = StrokeCap.round;

    // Top-left
    canvas.drawLine(
      rect.topLeft,
      rect.topLeft + Offset(cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      rect.topLeft,
      rect.topLeft + Offset(0, cornerLength),
      cornerPaint,
    );

    // Top-right
    canvas.drawLine(
      rect.topRight,
      rect.topRight + Offset(-cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      rect.topRight,
      rect.topRight + Offset(0, cornerLength),
      cornerPaint,
    );

    // Bottom-left
    canvas.drawLine(
      rect.bottomLeft,
      rect.bottomLeft + Offset(cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      rect.bottomLeft,
      rect.bottomLeft + Offset(0, -cornerLength),
      cornerPaint,
    );

    // Bottom-right
    canvas.drawLine(
      rect.bottomRight,
      rect.bottomRight + Offset(-cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      rect.bottomRight,
      rect.bottomRight + Offset(0, -cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CropOverlayPainter oldDelegate) {
    return cropRect != oldDelegate.cropRect ||
        borderColor != oldDelegate.borderColor ||
        cornerLength != oldDelegate.cornerLength ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
