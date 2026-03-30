import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'quiz_screen.dart';

class QuizResultScreen extends StatelessWidget {
  final int correctCount;
  final int totalCount;
  final int minutes;
  final String quizName;
  final Map<int, String> userAnswers;
  final List<QuizQuestion> questions;

  const QuizResultScreen({
    Key? key,
    required this.correctCount,
    required this.totalCount,
    required this.minutes,
    this.quizName = 'Quiz',
    required this.userAnswers,
    required this.questions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = ((correctCount / totalCount) * 100).toStringAsFixed(0);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const SizedBox.shrink(),
        title: Text(
          'Kết quả',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Success icon
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                      size: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Score text
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Bạn đúng $correctCount/$totalCount câu',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$percentage%',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Stats cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.check_circle,
                        label: 'Đúng',
                        value: '$correctCount câu',
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.cancel_rounded,
                        label: 'Sai',
                        value: '${totalCount - correctCount} câu',
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.schedule_rounded,
                        label: 'Thời gian',
                        value: '$minutes phút',
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.info_outline,
                        label: 'Tổng câu',
                        value: '$totalCount câu',
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Review button
                ElevatedButton.icon(
                  onPressed: () {
                    context.push(
                      '/learning/quiz-review',
                      extra: {
                        'quizName': quizName,
                        'userAnswers': userAnswers,
                        'questions': questions,
                        'correctCount': correctCount,
                        'totalCount': totalCount,
                      },
                    );
                  },
                  icon: const Icon(Icons.visibility_rounded),
                  label: const Text('Xem lại bài làm'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Back to learning
                OutlinedButton.icon(
                  onPressed: () => context.go('/learning'),
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Về trang học tập'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
