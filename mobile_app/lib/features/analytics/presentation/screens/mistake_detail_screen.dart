import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/mistake_bank_bloc/mistake_bank_state.dart';
import '../widgets/ai_suggestion_box.dart';

class MistakeDetailScreen extends StatelessWidget {
  final MistakeItem item;

  const MistakeDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Chi tiết câu sai', style: AppTextStyles.heading2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${item.subject.toUpperCase()} - ${item.tag.toUpperCase()}',
                style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
            const SizedBox(height: 12),
            Text(item.title, style: AppTextStyles.heading2),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.close, color: AppColors.error),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Lựa chọn của bạn', style: AppTextStyles.bodyMedium),
                  ),
                  Text('5.5 cm', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check, color: AppColors.success),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Đáp án đúng', style: AppTextStyles.bodyMedium),
                  ),
                  Text('5 cm', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.success)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AiSuggestionBox(
              title: 'Gợi ý từ Gia sư AI',
              message: item.hint,
              trailing: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.play_arrow, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
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
                    child: const Icon(Icons.video_library, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Video bài giảng liên quan', style: AppTextStyles.bodyLarge),
                        const SizedBox(height: 4),
                        Text('Ứng dụng định lý Pythagoras', style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Làm lại câu này',
              onPressed: () => context.go('/statistical/mistakes/${item.id}/redo', extra: item),
            ),
          ],
        ),
      ),
    );
  }
}
