import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class PredictionCircularProgress extends StatelessWidget {
  final double value;
  final String label;

  const PredictionCircularProgress({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      width: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 160,
            width: 160,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: 10,
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: AppTextStyles.heading1.copyWith(fontSize: 28)),
              const SizedBox(height: 4),
              Text('Điểm dự kiến', style: AppTextStyles.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }
}
