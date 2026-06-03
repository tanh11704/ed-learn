import 'package:flutter/material.dart';
import 'package:mobile_app/features/mock_exam/presentation/screens/exam_result_screen.dart';

class SubmitConfirmationDialog extends StatelessWidget {
  final int totalQuestions;
  final int answeredCount;
  final VoidCallback? onSubmit;
  final VoidCallback? onReview;

  const SubmitConfirmationDialog({
    super.key,
    required this.totalQuestions,
    required this.answeredCount,
    this.onSubmit,
    this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    final unanswered = (totalQuestions - answeredCount).clamp(
      0,
      totalQuestions,
    );
    final unansweredIndexes = List<int>.generate(
      unanswered,
      (index) => index + 1,
    ).take(5).toList();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const Center(
            child: Text(
              'Bạn có chắc chắn muốn nộp bài?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _InfoChip(
                label: 'TỔNG SỐ',
                value: totalQuestions.toString(),
                color: const Color(0xFF1F2937),
                background: const Color(0xFFF3F4F6),
              ),
              const SizedBox(width: 12),
              _InfoChip(
                label: 'ĐÃ LÀM',
                value: answeredCount.toString(),
                color: const Color(0xFF1D4ED8),
                background: const Color(0xFFEFF6FF),
              ),
              const SizedBox(width: 12),
              _InfoChip(
                label: 'CHƯA LÀM',
                value: unanswered.toString(),
                color: const Color(0xFFDC2626),
                background: const Color(0xFFFFF1F2),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFFEF4444), size: 18),
              SizedBox(width: 6),
              Text(
                'Câu hỏi chưa hoàn thành',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFEF4444),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: unansweredIndexes
                .map((index) => _UnansweredChip(label: index.toString()))
                .toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed:
                  onSubmit ??
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExamResultScreen(),
                    ),
                  ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E6BFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Nộp bài ngay',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: onReview ?? () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF2E6BFF),
                side: const BorderSide(color: Color(0xFF2E6BFF)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Quay lại kiểm tra',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color background;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnansweredChip extends StatelessWidget {
  final String label;

  const _UnansweredChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFFEF4444),
        ),
      ),
    );
  }
}
