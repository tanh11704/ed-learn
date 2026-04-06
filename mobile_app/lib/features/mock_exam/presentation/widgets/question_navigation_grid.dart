import 'package:flutter/material.dart';

class QuestionNavigationGrid extends StatelessWidget {
  final int totalQuestions;
  final int currentIndex;
  final Set<int> answeredIndexes;
  final ValueChanged<int>? onSelect;

  const QuestionNavigationGrid({
    super.key,
    required this.totalQuestions,
    required this.currentIndex,
    required this.answeredIndexes,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: totalQuestions,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isCurrent = index == currentIndex;
          final isAnswered = answeredIndexes.contains(index);
          final bg = isCurrent
              ? const Color(0xFFEFF6FF)
              : (isAnswered ? const Color(0xFF2563EB) : Colors.white);
          final textColor = isCurrent
              ? const Color(0xFF2563EB)
              : (isAnswered ? Colors.white : const Color(0xFF94A3B8));

          return InkWell(
            onTap: () => onSelect?.call(index),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Text(
                '${index + 1}',
                style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
              ),
            ),
          );
        },
      ),
    );
  }
}
