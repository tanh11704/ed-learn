import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/prediction_bloc/prediction_bloc.dart';
import '../bloc/prediction_bloc/prediction_state.dart';

class LearningPathScreen extends StatelessWidget {
  const LearningPathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Lộ trình của bạn', style: AppTextStyles.heading2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: BlocBuilder<PredictionBloc, PredictionState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GoalHeader(prediction: state.prediction),
                const SizedBox(height: 20),
                Text('Lộ trình tăng điểm', style: AppTextStyles.heading2),
                const SizedBox(height: 12),
                ...state.stages.map(
                  (stage) => _StageCard(stage: stage),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GoalHeader extends StatelessWidget {
  final ScorePrediction prediction;

  const _GoalHeader({required this.prediction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            prediction.targetLabel,
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 6),
          Text(
            'Hiện tại: ${prediction.score.toStringAsFixed(1)} điểm',
            style: AppTextStyles.caption.copyWith(color: AppColors.white.withValues(alpha: 0.85)),
          ),
          const SizedBox(height: 4),
          Text(
            'Mục tiêu: ${(prediction.score + prediction.remainingScore).toStringAsFixed(1)} điểm',
            style: AppTextStyles.caption.copyWith(color: AppColors.white.withValues(alpha: 0.85)),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: prediction.accuracy,
            backgroundColor: AppColors.white.withValues(alpha: 0.25),
            valueColor: const AlwaysStoppedAnimation(AppColors.white),
          ),
          const SizedBox(height: 10),
          Text(
            'AI đề xuất lộ trình học 20 ngày để đạt mục tiêu.',
            style: AppTextStyles.caption.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}

class _StageCard extends StatelessWidget {
  final LearningStage stage;

  const _StageCard({required this.stage});

  @override
  Widget build(BuildContext context) {
    final isLocked = stage.isLocked;
    final accentColor = isLocked ? AppColors.border : AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: isLocked
                      ? const Icon(Icons.lock, size: 18, color: AppColors.textSecondary)
                      : Text(stage.index.toString(), style: AppTextStyles.bodyMedium),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(stage.title, style: AppTextStyles.bodyLarge)),
            ],
          ),
          const SizedBox(height: 10),
          Text(stage.description, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    stage.actionLabel,
                    style: AppTextStyles.caption.copyWith(
                      color: isLocked ? AppColors.textSecondary : AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (!isLocked)
                PrimaryButton(
                  text: 'Bắt đầu',
                  width: 110,
                  onPressed: () {},
                ),
            ],
          ),
        ],
      ),
    );
  }
}
