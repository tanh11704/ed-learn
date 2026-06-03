import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/performance_bloc/performance_bloc.dart';
import '../bloc/performance_bloc/performance_state.dart';
import '../bloc/prediction_bloc/prediction_bloc.dart';
import '../bloc/prediction_bloc/prediction_state.dart';

class AnalyticsDashboardScreen extends StatelessWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Tổng quan học tập', style: AppTextStyles.heading2),
        centerTitle: false,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<PerformanceBloc, PerformanceState>(
            listener: (context, state) {},
          ),
          BlocListener<PredictionBloc, PredictionState>(
            listener: (context, state) {},
          ),
        ],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SummarySection(),
              const SizedBox(height: 20),
              _PredictionCard(),
              const SizedBox(height: 20),
              _QuickLinks(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummarySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PerformanceBloc, PerformanceState>(
      builder: (context, state) {
        final capability = state.capability;
        final progress = state.progress;
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Chỉ số năng lực', style: AppTextStyles.caption),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${capability.overallScore.toStringAsFixed(0)}/100',
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '+${capability.improvementPercent.toStringAsFixed(1)}% tuần này',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _SmallInfoCard(
                      title: 'Tiến độ học tập',
                      value: progress.averageScore.toStringAsFixed(1),
                      subtitle: 'Điểm trung bình',
                      bars: const [0.3, 0.5, 0.8, 1.0],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SmallInfoCard(
                      title: 'Thời gian học',
                      value: progress.weeklyScore.toStringAsFixed(0),
                      subtitle: '45p/ngày',
                      bars: const [0.2, 0.4, 0.6, 0.5],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SmallInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final List<double> bars;

  const _SmallInfoCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.bars,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.caption),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.heading2),
          const SizedBox(height: 6),
          Text(subtitle, style: AppTextStyles.caption),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: bars
                .map(
                  (height) => Container(
                    margin: const EdgeInsets.only(right: 4),
                    height: 30 * height,
                    width: 10,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _PredictionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PredictionBloc, PredictionState>(
      builder: (context, state) {
        final prediction = state.prediction;
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('✨ Dự đoán điểm AI', style: AppTextStyles.bodyLarge),
              const SizedBox(height: 6),
              Text('Dự đoán khối A00', style: AppTextStyles.caption),
              const SizedBox(height: 8),
              Text(
                '${prediction.score.toStringAsFixed(1)} điểm',
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Độ chính xác ${(prediction.accuracy * 100).toStringAsFixed(0)}%',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                text: 'Xem lộ trình →',
                onPressed: () => context.go('/statistical/prediction'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuickLinks extends StatelessWidget {
  final List<_QuickLinkItem> items = const [
    _QuickLinkItem(
      'Phân tích năng lực',
      '/statistical/capability',
      Icons.radar,
    ),
    _QuickLinkItem(
      'Tiến độ học tập',
      '/statistical/progress',
      Icons.show_chart,
    ),
    _QuickLinkItem('Kiểm soát thời gian', '/statistical/time', Icons.timer),
    // _QuickLinkItem('Dự đoán điểm thi', '/statistical/prediction', Icons.auto_awesome),
    _QuickLinkItem(
      'Ngân hàng lỗi sai',
      '/statistical/mistakes',
      Icons.error_outline,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Khám phá chi tiết', style: AppTextStyles.heading2),
        const SizedBox(height: 12),
        ...items.map(
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
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(item.title, style: AppTextStyles.bodyLarge),
                ),
                IconButton(
                  onPressed: () => context.go(item.route),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickLinkItem {
  final String title;
  final String route;
  final IconData icon;

  const _QuickLinkItem(this.title, this.route, this.icon);
}
