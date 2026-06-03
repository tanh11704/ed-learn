import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/prediction_bloc/prediction_bloc.dart';
import '../bloc/prediction_bloc/prediction_state.dart';
import '../widgets/prediction_circular_progress.dart';

class ScorePredictionScreen extends StatelessWidget {
  const ScorePredictionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Dự đoán điểm thi', style: AppTextStyles.heading2),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: BlocBuilder<PredictionBloc, PredictionState>(
        builder: (context, state) {
          final prediction = state.prediction;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    size: 64,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),
                PredictionCircularProgress(
                  value: prediction.score / 30,
                  label: prediction.score.toStringAsFixed(1),
                ),
                const SizedBox(height: 16),
                Text(
                  'AI dự đoán điểm thi khối A00 của bạn',
                  style: AppTextStyles.bodyLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  'Dựa trên kết quả 12 bài luyện tập gần nhất',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prediction.targetLabel,
                        style: AppTextStyles.bodyLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        prediction.targetDescription,
                        style: AppTextStyles.caption,
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: prediction.accuracy,
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${(prediction.accuracy * 100).toStringAsFixed(0)}%',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  text: 'Xem lộ trình tăng điểm',
                  onPressed: () => context.go('/statistical/learning-path'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
