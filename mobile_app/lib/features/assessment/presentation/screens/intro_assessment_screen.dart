import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';

class IntroAssessmentScreen extends StatelessWidget {
  const IntroAssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Text('EDTECH AI', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 280,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE7C2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 16,
                      left: 16,
                      child: _BubbleIcon(
                        icon: Icons.psychology,
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: _BubbleIcon(icon: Icons.science),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 20,
                      child: _BubbleIcon(icon: Icons.menu_book_rounded),
                    ),
                    Center(
                      child: Icon(Icons.school, size: 120, color: AppColors.primaryDark.withValues(alpha: 0.6)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Kiểm tra năng lực hiện tại', style: AppTextStyles.heading1),
              const SizedBox(height: 8),
              Text(
                'Bài kiểm tra này giúp AI hiểu rõ trình độ của bạn để xây dựng lộ trình học tập cá nhân hoá tối ưu nhất.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _InfoChip(icon: Icons.timer_outlined, label: '15 phút'),
                  _InfoChip(icon: Icons.list_alt_outlined, label: '20 câu hỏi'),
                  _InfoChip(icon: Icons.flash_on_outlined, label: 'Kết quả ngay'),
                ],
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Bắt đầu làm bài',
                onPressed: () => context.push('/assessment/testing'),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text('Tham gia cùng hơn 10,000 học viên khác', style: AppTextStyles.caption),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(height: 6),
        Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary)),
      ],
    );
  }
}

class _BubbleIcon extends StatelessWidget {
  const _BubbleIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Icon(icon, color: AppColors.primary),
    );
  }
}
