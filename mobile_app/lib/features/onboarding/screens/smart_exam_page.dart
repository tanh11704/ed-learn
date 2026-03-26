import 'package:flutter/material.dart';

import 'splash_screen.dart';
import '../../../core/constants/app_colors.dart';

class SmartExamPage extends StatelessWidget {
  const SmartExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingScaffold(
      title: 'Thi thử thông minh',
      subtitle: 'AI mô phỏng đề thi và phân tích điểm yếu.',
      description: 'Luyện tập theo bối cảnh và nâng cao điểm số.',
      icon: Icons.shield_rounded,
      accent: AppColors.primaryDark,
    );
  }
}
