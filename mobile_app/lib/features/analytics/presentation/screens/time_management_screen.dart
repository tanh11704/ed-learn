import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../bloc/performance_bloc/performance_bloc.dart';
import '../bloc/performance_bloc/performance_state.dart';
import '../widgets/time_bar_chart.dart';

class TimeManagementScreen extends StatelessWidget {
  const TimeManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Kiểm soát thời gian', style: AppTextStyles.heading2),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: BlocBuilder<PerformanceBloc, PerformanceState>(
        builder: (context, state) {
          final timeStats = state.timeManagement;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Phân tích thời gian', style: AppTextStyles.heading2),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Trung bình tuần này', style: AppTextStyles.caption),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            timeStats.weeklyMinutes.toStringAsFixed(1),
                            style: AppTextStyles.heading1,
                          ),
                          const SizedBox(width: 6),
                          Text('phút', style: AppTextStyles.bodyMedium),
                          const Spacer(),
                          Text(
                            '${timeStats.deltaPercent > 0 ? '+' : ''}${timeStats.deltaPercent.toStringAsFixed(0)}%',
                            style: AppTextStyles.caption.copyWith(
                              color: timeStats.deltaPercent >= 0
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TimeBarChart(categories: timeStats.categories),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _LegendDot(color: AppColors.primary.withValues(alpha: 0.2), label: 'Chuẩn'),
                          const SizedBox(width: 12),
                          _LegendDot(color: AppColors.primary, label: 'Của bạn'),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.timer, color: AppColors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Phân tích quan trọng', style: AppTextStyles.bodyLarge),
                            const SizedBox(height: 4),
                            Text(
                              'Bạn đang tập trung nhiều thời gian cho phần Đọc hiểu.',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text('Gợi ý cho bạn', style: AppTextStyles.heading2),
                const SizedBox(height: 12),
                _SuggestionRow(icon: Icons.lightbulb_outline, text: 'Luyện tập kỹ thuật Skimming & Scanning'),
                const SizedBox(height: 8),
                _SuggestionRow(icon: Icons.timer_outlined, text: 'Đặt giới hạn 15 phút cho mỗi bài đọc'),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(height: 8, width: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _SuggestionRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SuggestionRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}
