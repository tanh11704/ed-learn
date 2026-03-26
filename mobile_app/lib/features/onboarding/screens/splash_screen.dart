import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingScaffold(
      title: 'ExamAI',
      subtitle: 'Preparation reimagined',
      description: 'Tối ưu hành trình ôn thi với AI đồng hành.',
      icon: Icons.school_rounded,
      accent: AppColors.primary,
    );
  }
}

class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 260,
            width: double.infinity,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24),
            ),
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: accent.withValues(alpha: 0.18),
              child: Icon(icon, size: 64, color: accent),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: AppTextStyles.heading1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
