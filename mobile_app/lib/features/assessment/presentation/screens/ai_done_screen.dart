import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/services/token_storage_service.dart';
import '../../../../core/widgets/primary_button.dart';

class AiDoneScreen extends StatelessWidget {
  const AiDoneScreen({super.key});

  Future<void> _completeAssessmentAndNavigate(BuildContext context) async {
    // Lấy email user hiện tại
    final tokenStorage = TokenStorageService();
    final userEmail = await tokenStorage.getCurrentUserEmail();
    
    if (userEmail != null) {
      // Lưu flag đã hoàn thành assessment cho user này
      await tokenStorage.setAssessmentCompleted(userEmail, true);
    }
    
    // Điều hướng tới home
    if (context.mounted) {
      context.goNamed('home');
    }
  }

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
        title: Text('Hệ thống AI', style: AppTextStyles.heading2),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryLight,
                  ),
                  child: const Icon(Icons.check_circle, size: 88, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 24),
              Text('AI đã tạo xong lộ trình\ncho bạn!', style: AppTextStyles.heading1, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                'Lộ trình được cá nhân hoá theo mục tiêu, năng lực và thời gian học của bạn.',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gợi ý tiếp theo', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text('• Học 5 ngày/tuần, mỗi ngày 1 giờ', style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 4),
                    Text('• Ưu tiên các môn theo khối thi đã chọn', style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                text: 'Hoàn tất & về Home',
                onPressed: () => _completeAssessmentAndNavigate(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
