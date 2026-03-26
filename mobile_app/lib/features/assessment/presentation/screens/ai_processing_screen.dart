import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';

class AiProcessingScreen extends StatelessWidget {
  const AiProcessingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Text('Hệ thống AI', style: AppTextStyles.heading2),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  height: 210,
                  width: 210,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.background,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 170,
                        width: 170,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primaryLight, width: 2),
                        ),
                      ),
                      Container(
                        height: 130,
                        width: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.warning.withValues(alpha: 0.5), width: 2, style: BorderStyle.solid),
                        ),
                      ),
                      const CircleAvatar(
                        radius: 34,
                        backgroundColor: AppColors.white,
                        child: Icon(Icons.settings, color: AppColors.primary, size: 30),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('AI đang thiết kế lộ trình\ndành riêng cho bạn...', style: AppTextStyles.heading1, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('Phân tích sở thích và mục tiêu cá nhân', style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ĐANG XỬ LÝ', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary)),
                        Text('65%', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        minHeight: 6,
                        value: 0.65,
                        backgroundColor: AppColors.primaryLight,
                        valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('Khởi tạo dữ liệu...', style: AppTextStyles.caption),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                text: 'Tiếp tục',
                onPressed: () => context.go('/assessment/ai-done'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
