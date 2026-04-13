import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/task_progress_card.dart';

class LearningTasksScreen extends StatelessWidget {
  const LearningTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text('Nhiệm vụ học tập', style: AppTextStyles.heading2),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Text('12', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(width: 4),
                const Icon(Icons.local_fire_department, color: Color(0xFFFF7A1A), size: 18),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _progressCard(),
          const SizedBox(height: 26),
          Row(
            children: [
              Text('Nhiệm vụ hằng ngày', style: AppTextStyles.heading2),
              const Spacer(),
              Text('Tất cả', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          const TaskProgressCard(
            title: 'Học tập trung 45 phút',
            progressText: '45/45',
            progress: 1,
            buttonText: 'Nhận 50 XP',
            isClaimable: true,
            progressColor: Color(0xFF18B368),
          ),
          const TaskProgressCard(
            title: 'Hoàn thành 1 bài thi thử',
            progressText: '0/1',
            progress: 0,
            buttonText: 'Làm ngay',
          ),
          const TaskProgressCard(
            title: 'Chữa 5 câu lỗi sai',
            progressText: '2/5',
            progress: .4,
            buttonText: 'Làm ngay',
            progressColor: Color(0xFF8B97B3),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Text('Nhiệm vụ tuần', style: AppTextStyles.heading2),
              const Spacer(),
              Text('Xem thêm', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _weekly('Đọc 3 chương\nlý thuyết', .38, Icons.menu_book_rounded)),
              const SizedBox(width: 12),
              Expanded(child: _weekly('Duy trì streak 7\nngày', .55, Icons.timer_outlined)),
            ],
          ),
        ]),
      ),
    );
  }

  Widget _progressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF1FA),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 4,
            bottom: -2,
            child: Icon(Icons.school_outlined, size: 78, color: Colors.black.withValues(alpha: 0.08)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TIẾN ĐỘ HÔM NAY', style: AppTextStyles.bodyMedium.copyWith(letterSpacing: 1, color: AppColors.textSecondary)),
              const SizedBox(height: 6),
              Text('Tuyệt vời!', style: AppTextStyles.heading1.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: 1 / 3,
                minHeight: 7,
                borderRadius: BorderRadius.circular(20),
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
              const SizedBox(height: 8),
              Text('Bạn đã hoàn thành 1/3 nhiệm vụ', style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }

  Widget _weekly(String title, double progress, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF1FA),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(height: 6),
          Text(title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            borderRadius: BorderRadius.circular(20),
            backgroundColor: const Color(0xFFC2CBDE),
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          )
        ],
      ),
    );
  }
}
