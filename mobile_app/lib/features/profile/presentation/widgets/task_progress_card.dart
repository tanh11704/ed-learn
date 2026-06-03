import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class TaskProgressCard extends StatelessWidget {
  final String title;
  final String progressText;
  final double progress;
  final String buttonText;
  final bool isClaimable;
  final Color progressColor;

  const TaskProgressCard({
    super.key,
    required this.title,
    required this.progressText,
    required this.progress,
    required this.buttonText,
    this.isClaimable = false,
    this.progressColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isClaimable
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isClaimable ? Colors.transparent : AppColors.primary,
                    width: 1.4,
                  ),
                ),
                child: Text(
                  buttonText,
                  style: AppTextStyles.caption.copyWith(
                    color: isClaimable ? Colors.white : AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            minHeight: 5,
            borderRadius: BorderRadius.circular(20),
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation(progressColor),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              progressText,
              style: AppTextStyles.caption.copyWith(
                color: progress >= 1
                    ? Colors.green.shade700
                    : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
