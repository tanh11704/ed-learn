import 'package:flutter/material.dart';

import 'splash_screen.dart';
import '../../../core/constants/app_colors.dart';

class AdaptiveLearningPage extends StatelessWidget {
  const AdaptiveLearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingScaffold(
      title: 'AI Adaptive Learning',
      subtitle: 'Personalized study paths tailored to your pace.',
      description: 'Học tập thích ứng theo tốc độ và mục tiêu của bạn.',
      icon: Icons.psychology_alt_rounded,
      accent: AppColors.primaryDark,
    );
  }
}
