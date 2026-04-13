import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../bloc/performance_bloc/performance_bloc.dart';
import '../bloc/performance_bloc/performance_state.dart';
import '../widgets/skill_radar_chart.dart';

class CapabilityAnalysisScreen extends StatelessWidget {
  const CapabilityAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Phân tích năng lực', style: AppTextStyles.heading2),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: BlocBuilder<PerformanceBloc, PerformanceState>(
        builder: (context, state) {
          final capability = state.capability;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        '${capability.overallScore.toStringAsFixed(0)}/100',
                        style: AppTextStyles.heading1.copyWith(color: AppColors.primary),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '+${capability.improvementPercent.toStringAsFixed(1)}% tháng này',
                          style: AppTextStyles.caption.copyWith(color: AppColors.success),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Biểu đồ kỹ năng', style: AppTextStyles.bodyLarge),
                      const SizedBox(height: 16),
                      SkillRadarChart(skills: capability.skills),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _InsightCard(
                        title: 'Điểm mạnh',
                        color: AppColors.primary,
                        insight: capability.strengths.first,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InsightCard(
                        title: 'Cần cải thiện',
                        color: AppColors.warning,
                        insight: capability.weaknesses.first,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Tiến độ chi tiết', style: AppTextStyles.heading2),
                const SizedBox(height: 12),
                ...capability.skills.map(
                  (skill) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text(skill.label, style: AppTextStyles.bodyLarge)),
                        Text('${skill.value.toStringAsFixed(0)}%', style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String title;
  final Color color;
  final SkillInsight insight;

  const _InsightCard({
    required this.title,
    required this.color,
    required this.insight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.caption.copyWith(color: color)),
          const SizedBox(height: 8),
          Text(insight.title, style: AppTextStyles.bodyLarge),
          const SizedBox(height: 4),
          Text(insight.subtitle, style: AppTextStyles.caption),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: insight.progressPercent,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ],
      ),
    );
  }
}
