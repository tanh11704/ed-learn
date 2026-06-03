import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../bloc/performance_bloc/performance_bloc.dart';
import '../bloc/performance_bloc/performance_state.dart';
import '../widgets/progress_line_chart.dart';

class LearningProgressScreen extends StatelessWidget {
  const LearningProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Tiến độ học tập', style: AppTextStyles.heading2),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: BlocBuilder<PerformanceBloc, PerformanceState>(
        builder: (context, state) {
          final progress = state.progress;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _SummaryBox(
                        title: 'Điểm trung bình',
                        value: progress.averageScore.toStringAsFixed(1),
                        change: '+${progress.growthPercent.toStringAsFixed(0)}',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SummaryBox(
                        title: 'Tăng trưởng',
                        value: '+${progress.growthPercent.toStringAsFixed(0)}%',
                        change: '↑',
                      ),
                    ),
                  ],
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tăng trưởng theo tuần',
                            style: AppTextStyles.bodyLarge,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '+${progress.weeklyGrowth.toStringAsFixed(0)}%',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.success,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${progress.weeklyScore.toStringAsFixed(0)}/100',
                        style: AppTextStyles.heading2.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ProgressLineChart(points: progress.chartPoints),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Lịch sử bài kiểm tra', style: AppTextStyles.heading2),
                    Text(
                      'Tất cả',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...progress.history.map(
                  (item) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.menu_book,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title, style: AppTextStyles.bodyLarge),
                              const SizedBox(height: 4),
                              Text(
                                item.dateLabel,
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              item.score.toStringAsFixed(1),
                              style: AppTextStyles.bodyLarge,
                            ),
                            Text(
                              item.status,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
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

class _SummaryBox extends StatelessWidget {
  final String title;
  final String value;
  final String change;

  const _SummaryBox({
    required this.title,
    required this.value,
    required this.change,
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
          Text(title, style: AppTextStyles.caption),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(value, style: AppTextStyles.heading2),
              const SizedBox(width: 6),
              Text(
                change,
                style: AppTextStyles.caption.copyWith(color: AppColors.success),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
