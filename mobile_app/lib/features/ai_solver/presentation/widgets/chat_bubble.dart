import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final String? timeLabel;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    this.timeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isUser ? AppColors.primary : const Color(0xFFF2F4F7);
    final textColor = isUser ? AppColors.white : AppColors.textPrimary;
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;

    return Align(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: const EdgeInsets.symmetric(vertical: 6),
            constraints: const BoxConstraints(maxWidth: 280),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isUser ? 16 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 16),
              ),
            ),
            child: Text(
              message,
              style: AppTextStyles.bodyLarge.copyWith(color: textColor),
            ),
          ),
          if (timeLabel != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                timeLabel!,
                style: AppTextStyles.caption,
              ),
            ),
        ],
      ),
    );
  }
}
