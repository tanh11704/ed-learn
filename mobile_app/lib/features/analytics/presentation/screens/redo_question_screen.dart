import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/mistake_bank_bloc/mistake_bank_state.dart';

class RedoQuestionScreen extends StatefulWidget {
  final MistakeItem item;

  const RedoQuestionScreen({super.key, required this.item});

  @override
  State<RedoQuestionScreen> createState() => _RedoQuestionScreenState();
}

class _RedoQuestionScreenState extends State<RedoQuestionScreen> {
  String? _selectedOption;
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    final options = const ['5 cm', '5.5 cm', '6 cm', '7 cm'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Làm lại câu hỏi', style: AppTextStyles.heading2),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.item.subject.toUpperCase()} - ${widget.item.tag.toUpperCase()}',
                style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
            const SizedBox(height: 16),
            Text(widget.item.title, style: AppTextStyles.heading2),
            const SizedBox(height: 24),
            ...options.map(
              (option) => _AnswerOption(
                text: option,
                isSelected: _selectedOption == option,
                isCorrect: _submitted && option == options.first,
                onTap: () {
                  setState(() {
                    _selectedOption = option;
                  });
                },
              ),
            ),
            const Spacer(),
            if (_submitted)
              _SuccessBanner(
                text: 'Tuyệt vời! Bạn làm đúng.',
                subtitle: 'Áp dụng định lý Pythagoras: BC² = AB² + AC²',
                onDone: () => context.pop(),
              )
            else
              PrimaryButton(
                text: 'Kiểm tra đáp án',
                onPressed: _selectedOption == null
                    ? null
                    : () {
                        setState(() {
                          _submitted = true;
                        });
                      },
              ),
          ],
        ),
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final VoidCallback onTap;

  const _AnswerOption({
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.border;
    Color fillColor = AppColors.white;
    Widget? trailing;

    if (isSelected) {
      borderColor = AppColors.primary;
      fillColor = AppColors.primary.withValues(alpha: 0.08);
    }

    if (isCorrect) {
      borderColor = AppColors.success;
      fillColor = AppColors.success.withValues(alpha: 0.1);
      trailing = const Icon(Icons.check_circle, color: AppColors.success, size: 20);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: borderColor.withValues(alpha: 0.15),
              child: Text(
                text.characters.first,
                style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: AppTextStyles.bodyLarge)),
            trailing ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  final String text;
  final String subtitle;
  final VoidCallback onDone;

  const _SuccessBanner({
    required this.text,
    required this.subtitle,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
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
          Row(
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.auto_awesome, color: AppColors.success, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(text, style: AppTextStyles.bodyLarge),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 14),
          PrimaryButton(text: 'Hoàn thành', onPressed: onDone),
        ],
      ),
    );
  }
}
